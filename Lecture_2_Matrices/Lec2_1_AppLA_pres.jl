### A Pluto.jl notebook ###
# v0.19.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ cb5b4180-7e05-11ec-3b82-cd8631fc57ba
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
	using Plots
	using LaTeXStrings
	using LinearAlgebra
end

# ╔═╡ b5449b8e-3000-48dc-a788-1d357569a5a9
using QuartzImageIO # required to load a gif file

# ╔═╡ 5504aec1-ecb0-41af-ba19-aaa583870875
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 98ddb325-2d12-44b5-90b6-61e7eb55bd68
struct TwoColumn{A, B}
	left::A
	right::B
end

# ╔═╡ 1c5063ab-e965-4c3b-a0d9-7cf2b272ad48
function Base.show(io, mime::MIME"text/html", tc::TwoColumn)
	write(io,
		"""
		<div style="display: flex;">
			<div style="flex: 50%;">
		""")
	show(io, mime, tc.left)
	write(io,
		"""
			</div>
			<div style="flex: 50%;">
		""")
	show(io, mime, tc.right)
	write(io,
		"""
			</div>
		</div>
	""")
end

# ╔═╡ b1eefcd2-3d91-42e5-91e8-edc2ed3a5aa8
html"<button onclick='present()'>present</button>"

# ╔═╡ a9c98903-3f39-4d69-84cb-2e41f8cca9ac
md"""# Applied Linear Algebra for Everyone
``M. \;İrşadi \;Aksun, \;\;September \;xx, \;2022`` 

``Electrical \;and \;Electronics \;Engineering``

`` {\bf e-mail}: iaksun@ku.edu.tr``

``{\bf Tel}:\;1539``

``Course \;webpage:xxxxxx``

#### Reference Books:
* Stephen P. Boyd and ... _Introduction to Applied Linear Algebra - Vectors, Matrices, and Least Squares_


* W. Gilbert Strang, _Linear Algebra for Everyone_

"""

# ╔═╡ 0c2bf16a-92b9-4021-a5f0-ac2334fb986a
md"""# Lecture - 2: _Matrices_

### Content 

> ##### 2.1. Linear Equations
>>> ##### A brief digression: Linear, non-linear equations 
>> ##### 2.1.1. Ellimination and back substitution 
>> ##### 2.1.2. Unique, many and no solutions

> ##### 2.2. Matrices
>> ##### 2.2.1. ...
>> ##### 2.2.2. ...
>>> #####  Brief digression

> ##### 2.3. Matrix operations
>> ##### 2.3.1. Add, subtract and transpose
>> ##### 2.3.2. Matrix multiplication
>>> ##### Matrix-Scalar multiplication
>>> ##### Matrix-Vector multiplication
>>>> ##### Multiplication by rows
>>>> ##### Multiplication by columns
>>> ##### Matrix-Matrix multiplication
>> ##### 2.3.3. Inverse of a matrix
>> ##### 2.3.4. Determinant of a matrix

> ##### 2.4. Some applications
>> ##### 2.4.1. Markov processes
>>> ##### Example: Page rank algorithm
>>> ##### Example: Covid-19 survival analysis

---

"""

# ╔═╡ 3de20f99-af1c-413a-b8f4-dc2d259ece3a
md""" # 2.1. Linear Equations
* **Linear Equations** lie at the heart of linear algebra and appear almost in every field, Engineering, Finance, Sciences, Social Sciences,…

* Even as early as in junior high, we have all learned how to solve a few linear equations simulatanously.

* Here is a simple system of 2 equations with 2 unknowns:

>$x + 2 y = 3  \qquad \qquad   x_1 + 2 x_2 = 3$
>$4 x + 5 y = 6  \qquad \qquad    4 x_1 + 5 x_2 = 6$

where $x$ and $y$ are unknowns (or use $x_1, x_2, \dots, x_n$ in cases of $n$ unknowns), and individual equations are **_linear_**. 

!!! note
	We will be using $x_1$, $x_2$,...,$x_n$ notation from now on to help you detach from the terminology of Physics.

The whole idea of **Linear Equations** and most part of **Linear Algebra** stem from the efforts of how to find a solution (or solutions) **_accurately_** and **_efficiently_** for such equations.

We all know how to solve this by **ellimination**. So, let us plot these two equations and see if there is a solution:

"""

# ╔═╡ 8d0ad71b-34ca-407c-bd09-3fa191122c70
md"""# 
$x_1 + 2 x_2 = 3 \qquad \qquad    4 x_1 + 5 x_2 = 6$
"""

# ╔═╡ 2fdeb1e8-5811-4dcb-881a-5e857889f6ca
let # "Let ... end" allows the variables to be used only in the cell.
	#x =[-3:1:3;]; x = range(-3,3,7); x = collect(-3:1:3)
	x_1 = range(-3,3,7)
	x_21 = (3 .- x_1)/2;
	x_22 = (6 .- 4x_1)/5;
	plot(x_1, x_21, xlabel = L"x_1", label = L"x_1+ 2 x_2 =3", ylabel = L"x_2", frame = :origin, aspect_ratio = :equal)
	plot!(x_1, x_22, label = L"4x_1+5x_2=6", fg_legend = false, annotations = [(-1.3,1.7,Plots.text(L"^{(-1,2)}"))])
	# `fg_legend = false` is to turn off the box around the legends
end

# ╔═╡ 9648cc3d-3e45-4dee-b245-1865b31f3c4c
md" 
!!! julia
	**_range_** commend `range(-3.0, stop=3.0, length=7)` does not allocate but creates `start`, `stop` and `length`. `range` is refered to as ``lazy \;vector`` and used as `range(-3,3,7)` in this case.

	If needed to create an array according to the limits
	* `x =[-3:1:3;]` start=-3, step=1, stop=3, or
	* `x = collect(-3:1:3)` start=-3, step=1, stop=3
	can be used. Note the semicolon (`;`) in the first assignment, which refers to 	`vcat` (vertical concatenation) for the entries defined.
"

# ╔═╡ ae8bd2b8-f1a2-4ec4-a688-36be1d74b22f
md"""#
### A brief digression: Linear, nonlinear equations

To make sure what ``\color{red} non \;linear \;equation`` means, here are two pairs of simple non-linear and linear equations:

> Non Linear: $f_1(x_1, x_2) = 4 x_1 - 5 x_2 + 2 {\color{red} x_1 x_2} \qquad \qquad   g_1(x_1,x_2) = 10 {\color{red} \sqrt{x_1}} + x_2 - 5$
>
> Linear: $\quad\;\; f_2(x_1, x_2) = 4 x_1 - 10 x_2 -10  \qquad \qquad \;\;\;\;  g_2(x_1,x_2) = 10 x_1 + 5 x_2 + 5$

which do not define lines or planes, but curved geometries as shown below:
"""

# ╔═╡ a01b7bc9-ed73-42a1-af62-40cad8a403a8
let
	x=range(0,stop=5,length=100)
	y=range(0,stop=5,length=100)
	#f(x,y) = x*y-x-y+1
	fnl(x,y) = 4x - 5y + 2 * x .* y
	fl(x,y) = 4x - 10y .- 10
	gnl(x,y) = 20 * sqrt.(x) + 2 * y .- 20
	gl(x,y) = 10x + 5y .+ 5
	fig1 = plot(x,y,fnl,st=:surface, xlabel = L"x_1", ylabel = L"x_2", zlabel = L"f(x,y)", color=cgrad(:jet), colorbar = false)
	plot!(x,y,fl,st=:surface, color=cgrad(:jet))
	fig2 = plot(x,y,gnl,st=:surface, color=cgrad(:jet), colorbar = false, xlabel = L"x_1", ylabel = L"x_2", zlabel = L"g(x,y)")
	plot!(x,y,gl,st=:surface, color=cgrad(:jet))
	plot(fig1,fig2, layout = (1,2))
end

# ╔═╡ d5551789-6389-4a4e-be19-2399ece4236b
md"""## 2.1.1. Ellimination and back substitution

* Note that **multiplying an equation by a constant and subtracting one from the other will not change the solution**.


* **Ellimination:** Multiply the first equation by 4 and substract it from the second equation,
>  4 × ($x_1 + 2 x_2 = 3$) ⇒ $4 x_1 + 8 x_2 = 12$ ⇒ $4 x_1 + 8 x_2 = 12$\
> $\;\;\;\;\;4 x_1 + 5 x_2 = 6$ ⇒ $4 x_1 + 5 x_2 = \;\;6$ ⇒ $\;\;\;\;\; -3 x_2 = -6$

* **Back-substitution:** Starting from the second equation, solve for the unknowns,
>  $x_2 = -6/-3\;\;\;\;\;$ ⇒ $x_2 = 2$\
> $4 x_1 + 8 × 2 = 12$ ⇒ $x_1 = -1$ 

* This is know as **Gaussian ellimination** and is widely used to solve large systems of equations.
"""

# ╔═╡ d553f6c0-364d-4b8c-ba9f-dec14261be06
md"""## 2.1.2. Unique, many and no solution

##### How do we have many or no solution?
\
Let us modify the second equation as follows:

${\color{blue} x_1 + 2 x_2 = 3} \qquad \qquad  {\color{red} x_1 + 2 x_2 = 3}$
${\color{blue} 2 x_1 + 4 x_2 = 1} \qquad \qquad  {\color{red} 2 x_1 + 4 x_2 = 6}$

##### What do you notice?

* Left-hand sides give the same information, so what?


* Right-hand sides on the blue equations are not consistent, what does it mean?


* Right-hand sides on the red equations are consistent, what does it mean? 

"""

# ╔═╡ 520539c0-479e-4168-8667-668ef2077a18
let
	#x =[-3:1:3;]; x = range(-3,3,7); x = collect(-3:1:3)
	x_1 = range(-3,3,7)
	x_21 = (3 .- x_1)/2;
	x_22 = (1 .- 2x_1)/4;
	fig1 = plot(x_1, x_21, xlabel = L"x_1", label = L"x_1+ 2 x_2 =3", ylabel = L"x_2", frame = :origin, color = :blue);
	plot!(x_1, x_22, label = L"2x_1+4x_2=1", fg_legend = :false, color = :blue, linestyle = :dash, title = "No solution");
	x_31 = (3 .- x_1)/2;
	x_32 = (6 .- 2x_1)/4;
	fig2 = plot(x_1, x_31, xlabel = L"x_1", label = L"x_1+ 2 x_2 =3", frame = :origin, color = :red);
	plot!(x_1, x_32, label = L"2x_1+4x_2=6", fg_legend = :false, color = :red, linestyle = :dash, title = "Many solutions");
	plot(fig1, fig2, layout= (1,2), aspect_ratio = :equal)
	# `fg_legend = :false` is to turn off the box around the legends
end

# ╔═╡ fb2795d8-63e4-4d30-bb77-b1e30d59b185
md" 
*  the ${\color{blue} blue \;equations}$ give conflicting information (${\color{blue} inconsistent, \;no \;solution}$), while 
*  the ${\color{red} red \;equations}$ give the same information (${\color{red} consistent, \;infinitely \;many \;solutions}$).
"

# ╔═╡ 59abb2ae-9614-4ffe-bb2c-c2646629e509
md"# 
### Solutions of Linear Equations
#### Unique Solution
* It is simple to solve for unknowns in a set of 2 equations with 2 unknowns. 

* Perhaps, for 3 equations and 3 unknown, it may still be tractible by hand, at least for some people.

* In general, solutions are obtained by **_elimination_** and **_back-substitution_**, either by hand or by computer.
"

# ╔═╡ 77cd7684-b0ee-4cb7-a0f7-be9a4cbb3b58
TwoColumn(
	md""" 

$x_1 - 2 x_2 + x_3 =0$ 
$\qquad 2 x_2 - 8 x_3 = 8$ 
$5 x_1 \qquad -5 x_3 = 10$
""",
	md""" #####  Matrix representation ($\bf A x = b$)
\
 $\begin{bmatrix} 1 & -2 & 1 \\  0 & 2 & -8 \\ 5 & 0 & -5 \end{bmatrix} 
\begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = \begin{bmatrix} 0 \\ 8 \\ 10 \end{bmatrix}$ $\Rightarrow \bf x = A^{-1} b$
"""		
)

# ╔═╡ 3c0a921b-c8cc-4e8b-b0a6-3eb5d339fa63
let
A = [1 -2 1; 0 2 -8; 5 0 -5] # Matrix A
b = [0, 8, 10] # Column vector b
x = A\b # Solution for the unknown vector x
x = inv(A) * b # Solution with inverse of A
end

# ╔═╡ 3a417947-eb23-4247-9e79-af925733aabf
md"# 
#### No Solution or Many Solutions
Let us see what happens when we have no solution or many solutions, that is, at least one equation is parallel to the one of the others or the combination of others.

For the sake of illustration, let us double the first equation and use it as the second one:
* with different right hand side (_inconsistent_, **_no solution_**), or
* with doubing the right-hand side (_consistent_ but **_inifinitely many solutions_**) as well. 
"

# ╔═╡ aa13c9ca-4b07-4a64-a073-65ea7e0e6c99
TwoColumn(
	md"""
 
$\color{red} x_1 - 2 x_2 + x_3 =0$ 
$\color{red} 2 x_1 - 4 x_2 + 2 x_3 = 8$ 
$5 x_1 \qquad -5 x_3 = 10$
""",
	md"""
\
 $\begin{bmatrix} 1 & -2 & 1 \\  2 & -4 & 2 \\ 5 & 0 & -5 \end{bmatrix} 
\begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = \begin{bmatrix} 0 \\ 8 \\ 10 \end{bmatrix}$
"""		
)

# ╔═╡ af88ebfb-e6bf-4fa0-85c7-79fe09705509
let
A = [1 -2 1; 2 -4 2; 5 0 -5] # Matrix A
b = [0, 8, 10] # Column vector b
# x_1 = A\b # Solution for the unknown vector x
end

# ╔═╡ 0d1fd69e-9290-43dd-b79d-e78a8aab65b0
md""" # 2.2. Matrices

A **matrix** is a rectangular array of numbers written between rectangular (or round) brackets, as in

${\bf A} = \begin{bmatrix} 1 & 0.1 & 3 & -2.5 \\
				2.5 & 1.5 & 0 & 1.7 \\
				3 & -4.2 & 1 & 3 \end{bmatrix} \qquad OR \qquad
	{\bf A} = \begin{pmatrix} 1 & 0.1 & 3 & -2.5 \\
				2.5 & 1.5 & 0 & 1.7 \\
				3 & -4.2 & 1 & 3 \end{pmatrix}$

* An important attribute of a matrix is its size or dimensions, i.e., the numbers of rows and columns. The matrix above has 3 rows and 4 columns, so its size is 3 × 4.

* The $i,j$ element of matrix $A$ is the value in the $i^{th}$ row and $j^{th}$ column, denoted by double subscripts: $A_{ij}$. For example, $A_{23}=0$, $A_{32}=-4.2$, $A_{13}=-2.5$ 

* If $A$ is an m × n matrix, then the row index $i$ runs from 1 to m and the column index $j$ runs from 1 to n.
  - A `square matrix` has an equal number of rows and columns (n × n),
  - A `tall matrix` has more rows than columns (m × n, where m > n),
  - A `wide matrix` has more columns than rows (m × n, where m < n).
  
!!! note \"Throughout this course\" 
	the salient features of matrices will be introduced (when and where needed) enough for anyone (with no a priori knowledge on Linear Algebra) to be able to follow the rest of the materials.

!!! danger \" Inevitable\"
	Some concepts in Linear Algebra are inevitable; rather than derivations in math, **intuitions** will play a central role in this course.
 
"""

# ╔═╡ 7a1eb229-da44-40e0-8365-640a5ce88569
md"""#

#### Matrices in the context of linear equations

In real life problems, we usually have many unknowns (thousands, millions) with generally much more equations than the number of unknowns. That is,

* systems may not be square (mostly not) - more equations than unknowns;
* they need to be cast into ``Matrix`` forms with $m$ rows ($\equiv$ number of equations) and $n$ columns ($\equiv$ number of unknowns) in order to be able to work on with comparative ease and computational efficiency;

$\begin{bmatrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \vdots & \vdots & \cdots & \vdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{bmatrix} 
\begin{bmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = \begin{bmatrix} b_1 \\ b_2 \\ \vdots \\ b_m \end{bmatrix}$ 

$\bf A  x   =  b$

* **_no one can solve such a huge system by hand, or even by computer if not come up with smart algorithms_**. That is the main reason why we refer to Matrix notation and Linear Algebra tools in Big Data problems.

"""

# ╔═╡ c72c74f8-d5e5-4ebb-a0e5-384fc00a13e6
md" 
## Matrices in Julia

* **Creating matrices from the entries:**
"

# ╔═╡ ae6fbc53-26d9-4980-b755-9d2278badfc3
A_34 = [0.0 1.0 -2.3 0.1;
1.3 4.0 -0.1 0.0;
4.1 -1.0 0.0 1.7];

# ╔═╡ a9873638-7338-414e-8f30-054ba220114d
A2_34 = [0.0 1.0 -2.3 0.1; 1.3 4.0 -0.1 0.0; 4.1 -1.0 0.0 1.7];

# ╔═╡ 2b9984b3-b38e-498b-9a05-3df4f56c525e
size(A_34) # Gives the dimension as a tuple; size(A_34,1) = 3

# ╔═╡ 8c39de20-0c8e-4d02-bcf6-b8f89dd83a8f
md"#
* **Indexing entries:**
  - The i, j entry of a matrix A ⇒ A[i,j], or 
  - Assign a new value to any entry ⇒ A[i,j] = 'value'
  - ``Julia`` allows you to access an entry of a matrix using only one index:
     - matrices in Julia are stored in **_column-major_** order,
     - a matrix can be considered as a one dimensional array, with the first column stacked on top of the second, stacked on top of the third, and so on. Note that this is **_not standard mathematical notation_**.
"

# ╔═╡ 19adef74-4e28-4aab-9f05-92bcfde1bf73
A_34;

# ╔═╡ e4df508d-9f85-41a1-8cae-45d1505784b9
A_34[2,3] == A_34[8] # 8th entry is counted colomnwise, which corresponds to the (2,3) entry of A_34

# ╔═╡ 3bf2e096-bd06-431c-b771-a0fb5ebc1233
A_34[2,1] = 10;

# ╔═╡ 148996bf-5bf0-425f-bc42-215ff2bce311
A_34;

# ╔═╡ 9940c439-de80-4fc0-8c4d-b59ac2adb379
A_34[:,3] # Third column of A_34

# ╔═╡ c07dff77-c850-4f74-a5b6-18a1c7ecb176
A_34[2,:] # Second row of A_34 returned as a column vector

# ╔═╡ f70af9cd-6a95-4d1e-af12-2dd8d52399dc
a = [ -2.1 -3 0 ] # A 3-row vector or 1x3 matrix

# ╔═╡ b198c118-34eb-478e-a2cd-c8e6c19aec93
b = [ -2.1; -3; 0 ] # A 3-vector or 3x1 matrix

# ╔═╡ 19e9c605-fb39-450a-a4a2-edf617c72614
md"#
* **Slicing and Submatrices:** Using colon notation you can extract a submatrix.
"

# ╔═╡ 060cb524-7c1d-422d-82ea-7263d829a0cb
A = [ -1 0 1 0 ; 2 -3 0 1 ; 0 4 -2 1]

# ╔═╡ 856870ec-570a-4fe9-a602-128d8bbe2db0
A[1:2,3:4]

# ╔═╡ c7c0a6ba-060b-48c5-82cb-af8845fab924
A[:,2:3]

# ╔═╡ dce70b81-3fe7-4056-a54b-a8fb3992c80a
B = [ 1 -3 ; 2 0 ; 1 -2]

# ╔═╡ 9eb501af-996e-4300-aa87-3f1d32b08d0b
B[:] # Not standard mathematical notation

# ╔═╡ 2ce8dab0-14ea-46b3-914a-59968dcff4ec
reshape(B,(2,3)) # The Julia function reshape(B,(k,l)) gives a new k × l matrix, with the entries taken in the column-major order from B(m,n). Must have mn = kl,

# ╔═╡ e10b126b-17ee-4f93-aaeb-a5f1a1b34cb1
reshape(A,(2,6));

# ╔═╡ 4f0deacb-cd05-4786-aec1-4f6bc635b787
rand(2,3); # rand(m,n) generates an mxn matrix of random numbers between -1 and 1

# ╔═╡ b49cf4b8-f690-4768-b27d-0104b0619317
rand((-3:3),2,3); #rand((k:step:l), m,n) generates an mxn matrix of random numbers between -k and l with step size 'step' (the default step size is 1)

# ╔═╡ 78f0d566-903a-4018-b3e4-b1748e60c10c
md"#
* **Block Matrices:**
"

# ╔═╡ a5d67212-6356-4caf-966e-14b0a851b00e
begin
	B1 = [ 0 2 3 ]; # 1x3 matrix
	C1 = [ -1 ]; # 1x1 matrix
	D1 = [ 2 2 1 ; 1 3 5]; # 2x3 matrix
	E1 = [4 ; 4 ]; # 2x1 matrix
# construct 3x4 block matrix
	A1 = [B1 C1 ; D1 E1]
end

# ╔═╡ f3838d6f-0b17-48fe-b90a-0053f7ce74dc
md"## Matrix Operations

As stated above, this review is not going to be a mathematically rigirous one, rather it will review the operations in Matrix algebra 

### 1. Matrix transpose

* If $\bf A$ is an m × n matrix, its transpose, denoted ${\bf A}^T$ (or sometimes ${\bf A}^′$ or ${\bf A}^∗$), is the n × m matrix given by (${\bf A}^T)_{ij} = {\bf A}_{ji}$. 


* Transposing a matrix twice results in the original matrix.

"

# ╔═╡ dc5e390f-ece4-4e27-9b25-023a731cc633
A_exT = rand(-3:3, 3,2)

# ╔═╡ eec8c31c-5324-44a4-8e55-3fed81d9dbd8
A_exT'# Transposing a matrix twice results in the original matrix

# ╔═╡ f130d717-bedc-4ebd-bba5-3908d54c07bc
md"#

### 2. Matrix addition

* Two matrices of **the same size** can be added together.


* The result is another matrix of the same size, obtained by **adding the corresponding elements** of the two matrices. 

"

# ╔═╡ 4fd22565-7443-4f10-baf3-a2881651a2be
A_exA = rand(-3:3, 3,2)

# ╔═╡ 556f68f3-481b-4660-b5bd-f1a643676ee2
B_exA = rand(-3:3, 3,2)

# ╔═╡ 05c341eb-3db3-42bd-ae08-05f8aa370cb7
A_exA + B_exA

# ╔═╡ ba787e69-7f86-4f41-87f5-b20d9e8831c6
md"#

### 3. Matrix-Scalar multiplication

Given a matrix $\bf A$ and a scalar $c$, then $c \bf A$ is equal to the matrix whose entries are the entries of $\bf A$ multiplied by $c$:

!!! julia
	```math
	c {\bf A} = [c*{\bf A}[i,j] \;for \;i \;in \;1:m, \;j \;in \;1:n]
	```

```math
c \begin{bmatrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \vdots & \vdots & \cdots & \vdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{bmatrix} = \begin{bmatrix} ca_{11} & ca_{12} & \cdots & ca_{1n} \\ ca_{21} & ca_{22} & \cdots & ca_{2n} \\ \vdots & \vdots & \cdots & \vdots \\ ca_{m1} & ca_{m2} & \cdots & ca_{mn} \end{bmatrix}
```
"

# ╔═╡ 144114a0-20f1-4fee-8d7b-331274442bfb
# c1 = rand((-3:3)) # random integer number between -3 and 3

# ╔═╡ 8ead573c-e4a3-41e7-9d5e-8494f53ca6e4
# A1 = rand((-4:4),2,3) # random 2x3 matrix from integers between -4 and 4; or a fixed matrix like A = [1 2 3; 4 5 6; 7 8 9] 

# ╔═╡ 2efcc362-ebb1-41d7-a899-7854efa215ca
# cA1=[c1*A1[i,j] for i in 1:2, j in 1:3]

# ╔═╡ f190b01d-9268-4c44-ae01-cc17f927704e
# cA2=c1*A1

# ╔═╡ 45ced395-a8a2-465b-9552-186806b0e6e1
# cA1 == cA2 # elementwise comparison ".=="

# ╔═╡ 2cf6c3c0-0406-49d8-b53b-56983d290188
md"""#
### 4. Matrix-vector multiplication

>Here is a nice overview of **_Matrix-vector Multiplication_** by 3-Blue-1-Brown (Grant Sanderson) for your reference. I strongly recommend you to watch it and try to understand the intuitive picture of the concept rather than the mathematical details.

"""

# ╔═╡ 55fdee4a-3860-4a88-9790-bcfba7ee35fb
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/kYB8IZa5AuE" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 2d3abfe1-8cda-49f8-b5b1-b8b602626d92
md"#
##### Rotation matrix 
```math 
	{\bf R}_\theta = \begin{bmatrix} cos\theta & -sin\theta \\
 									 sin\theta & cos\theta \end{bmatrix}
```
rotates each point in the plane counterclockwise around the origin by angle $\theta$.
"

# ╔═╡ b86955b4-9a9f-47c7-bec4-9069fbbd4061
load("Picture1.png")

# ╔═╡ 346bba70-2209-4d07-8c02-63a74e8c622d
md"
How can you show that it actually rotates x- and y-axis counterclockwise by angle $\theta$.

Can you write x-axis as ${\bf x}=[1, 0]$ and y-axis as ${\bf y}=[0, 1]$?
"

# ╔═╡ 5ed395e8-20c8-4e34-8a15-7d51b1d9949a
θ° = (@bind θ° Slider(0:5:360, show_value=true, default=30))

# ╔═╡ e022e5e5-186b-48f8-bd7d-4be9dc6610ab
begin
θ = θ° * π / 180
x₀ = [1, 0]
y₀ = [0, 1]
A_rot = [cos(θ) -sin(θ);
		sin(θ) cos(θ)]
x_rot = A_rot * x₀
y_rot = A_rot * y₀
	x_vals = [0 0 0 0; x₀[1] y₀[1] x_rot[1] y_rot[1] ]
	y_vals = [0 0 0 0; x₀[2] y₀[2] x_rot[2] y_rot[2] ]

# 	# After importing LaTeXStrings package, L stands for Latex in the following expressions; L"v_1"
	plot(x_vals, y_vals, arrow = true, color = [:blue :blue :red :red],
     legend = :none, xlims = (-1, 1), ylims = (-1, 1), aspectratio = true,
	 annotations = [(x₀[1]-0.1, x₀[2]-0.1, Plots.text(L"x_0", color="blue")),
		 			(y₀[1]+0.1, y₀[2]-0.1, Plots.text(L"y_0", color="blue")),
	 			(x_rot[1]+0.05, x_rot[2]+0.05, Plots.text(L"x_\theta", color="red")),
		 		(y_rot[1]+0.05, y_rot[2]+0.05, Plots.text(L"y_\theta", color="red"))],
     xticks = -1:0.5:1, yticks = -1:0.5:1,
     framestyle = :origin)
end

# ╔═╡ a55816f3-1c24-4e6f-b35f-2aba8f8e8194
md"""#
For a given ($m,\color{red}n$) matrix $\bf A$ and a (${\color{red}n},1$) column vector $\bf x$, there are two ways of multiplying a matrix and a column vector, which will be introduced below:

!!! note
	**Ax is only possible when the number of columns in $\bf A$ is equal to the number of rows in $\bf x$.**

\
``\large Multiplication \;by \;Rows \;(\equiv Inner \;Product)``

!!! julia
	```math
	{\bf A x} =  [{\bf A}[i,:]' * {\bf x} \;for \;i \;in \;1:m]\;\;\; \leftarrow Row-Column \;Multiplication
	```

```math
\begin{bmatrix} {\color{green} a_{11}} & {\color{green} a_{12}} & {\color{green} \cdots} & {\color{green} a_{1n}} \\ {\color{blue} a_{21}} & {\color{blue} a_{22}} & {\color{blue} \cdots} & {\color{blue} a_{2n}} \\ \vdots & \vdots & \cdots & \vdots \\ {\color{red} a_{m1}} & {\color{red} a_{m2}} & {\color{red} \cdots} & {\color{red} a_{mn}} \end{bmatrix} \begin{bmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = \begin{bmatrix} {\color{green} a_{11} x_1 + a_{12} x_2 + \cdots + a_{1n} x_n} \\ {\color{blue} a_{21} x_1 + a_{22} x_2 + \cdots + a_{2n} x_n} \\ \vdots \\ {\color{red} a_{m1} x_1 + a_{m2} x_2 + \cdots + a_{mn} x_n} \end{bmatrix}
```
"""

# ╔═╡ c7f02d62-d81c-4cf0-860c-79ea6b5fd7ab
A2=rand((-2:2),2,2); # let us remember 

# ╔═╡ 7f367404-7275-4e35-9242-ebec5ac0668d
A2[1,:]; # Even though we choose a row, Julia still stores it as a column vector

# ╔═╡ 28ec3f99-0741-478d-b5e0-94b0baefd56c
x = rand((-2:2),size(A2,2)); # size(A2,2) gives the number of columns of A2

# ╔═╡ 444147d7-b570-4685-b1b9-cbab58f0bd7b
A2x_1 = [A2[i,:]' * x for i in 1:size(A2,1)]; # "'" is the transpose of A2[i,:], and size(A2,1) gives the number of rows of A2

# ╔═╡ 4e2ca663-4fa4-4d33-96b4-bc495c911871
A2 * x; # Notice that just writing A * x gives the right result, provided the two can be multiplied (number of columns of A = number of rows of x) 

# ╔═╡ e36cbcee-5092-4d91-ad44-be63b695ce60
md"""#

``\large Multiplication \;by \;Columns``

!!! julia
	```math
	{\bf A x} =  sum({\bf A}[:,j]*{\bf x}[j] \;for \;j \;in \;1:n)\;\;\; \leftarrow Multiplication \;by \; Columns
	```

```math
\begin{bmatrix} {\color{green} a_{11}} & {\color{blue} a_{12}} & \cdots & {\color{red} a_{1n}} \\ {\color{green} a_{21}} & {\color{blue} a_{22}} & \cdots & {\color{red} a_{2n}} \\ {\color{green} \vdots} & {\color{blue} \vdots} & \cdots & {\color{red} \vdots} \\ {\color{green} a_{m1}} & {\color{blue} a_{m2}} & \cdots & {\color{red} a_{mn}} \end{bmatrix} \begin{bmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = 
x_1 \begin{bmatrix} {\color{green} a_{11}} \\ {\color{green} a_{21}}  \\ {\color{green} \vdots} \\ {\color{green} a_{m1}} \end{bmatrix} + 
x_2 \begin{bmatrix} {\color{blue} a_{12}} \\ {\color{blue} a_{22}}  \\ {\color{blue} \vdots} \\ {\color{blue} a_{m2}} \end{bmatrix} + \cdots +
x_n \begin{bmatrix} {\color{red} a_{1n}} \\ {\color{red} a_{2n}}  \\ {\color{red} \vdots} \\ {\color{red} a_{mn}} \end{bmatrix}
```
"""

# ╔═╡ 612e0950-320c-4bbc-ae1a-db85307696fc
#A2x_2 = sum(A2[:,j] * x[j] for j in 1:size(A2,2))

# ╔═╡ 7e0ce959-5a70-4311-9031-540bf2414dd6
#A2 * x # Notice that just writing A * x gives the right result, provided the two can be multiplied (number of columns of A = number of rows of x) 

# ╔═╡ e3d39b29-c0ef-45b1-96a5-e26a1e8763c5
TwoColumn(
	md"""
Examine the following sets of equations: 
 $\;\;x_1 - 2 x_2 + \;x_3 =1$ \
 $2 x_1 - 4 x_2 + 2 x_3 = 2$ \
 $5 x_1 \qquad \;\;\, -5 x_3 = 5$ 
 
 **OR** \
 $\;\;x_1 - 2 x_2 + \;x_3 =2$ \
 $2 x_1 - 4 x_2 + 2 x_3 = 4$ \
 $5 x_1 \qquad \;\;\, -5 x_3 = 0$ \
""",
	md"""
 In matrix form: \
  $\begin{bmatrix} 1 & -2 & 1 \\  2 & -4 & 2 \\ 5 & 0 & -5 \end{bmatrix} 
  \begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = \begin{bmatrix} 1 \\ 2 \\ 5 
  \end{bmatrix} \rightarrow \begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = ?$ 

**OR** 

 $\begin{bmatrix} 1 & -2 & 1 \\  2 & -4 & 2 \\ 5 & 0 & -5 \end{bmatrix} 
\begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = \begin{bmatrix} 2 \\ 4 \\ 0 \end{bmatrix} \rightarrow \begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = ?$ 
"""		
)

# ╔═╡ 1668cb38-6078-4a7f-8ade-96f6d42280b6
md"""#

### 5. Matrix-Matrix multiplication

For a given ($m,\color{red}n$) matrix $\bf A$ and a (${\color{red}n},k$) matrix $\bf B$,

!!! note
	**AB is only possible when the number of columns in $\bf A$ is equal to the number of rows in $\bf B$.**

Considering Matrix-Vector multiplication by rows, and treating the columns of ${\bf B}$ as the vectors ${\bf B} = [b_1 \; b_2 \; \cdots \; b_k]$, then

```math
	{\bf A B} =  [{\bf A} b_1 \; {\bf A} b_2 \; \cdots \; {\bf A} b_k] 
```

```math
\begin{bmatrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \vdots & \vdots & \cdots & \vdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{bmatrix} 
\begin{bmatrix} b_{11} & b_{12} & \cdots & b_{1k} \\ b_{21} & b_{22} & \cdots & b_{2k} \\ \vdots & \vdots & \cdots & \vdots \\ b_{n1} & b_{n2} & \cdots & b_{nk} \end{bmatrix} 
```
${\bf AB}[i,j] = \; (i-th \;row \;of \;{\bf A}) \cdot \; (j-th \;column \;of \;{\bf B})$ 	

!!! julia
	```math
	{\bf A*B} = [ A[i,:] ⋅ B[:,j] \;\;for \;i \;in \;(1:m), \;j \;in \;(1:k)] 
	```
"""

# ╔═╡ d9636375-def7-4693-a2c3-91879d304b81
#A3 = rand((-2:2), 3,3)

# ╔═╡ 9023f8f4-2084-4ef6-b9ca-a94e967320e5
#B3 = rand((-2:2), 3,5)

# ╔═╡ 01c9e212-8cbc-4fb5-83d3-62dd0bfe48f7
#A3 * B3

# ╔═╡ 4c42ba85-442d-4ca8-9731-1bf71563e86e
#AB = [A3[i,:] ⋅ B3[:,j] for i in (1:size(A3)[1]), j in (1:size(B3)[2])]

# ╔═╡ d9a74a15-8867-4b62-a6c3-943f6b6b6179
#AB2 = [A3[i,:]' * B3[:,j] for i in (1:size(A3)[1]), j in (1:size(B3)[2])]

# ╔═╡ 75e91ef3-8893-48fc-a297-e54aa6b6c671
md"""#

### 4. Determinant of a Matrix

>Here is a nice overview of **_Determinant_** by 3-Blue-1-Brown (Grant Sanderson) for your reference. I strongly recommend you to lisen to it and try to understand the intuitive picture of the concept rather than the mathematical details.

"""

# ╔═╡ 1de74de8-36c5-467f-a749-4cefd0b2acdc
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/Ip3X9LOh2dk" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 877ef381-df6c-4a5b-bf99-88f8afba0995
md"#
##### Properties:
1.  $det \;{\bf I}$ = $1$
2. if two rows are interchanged, the determinant changes sign.
3. If a row is multiplied by a number, the determinant is multiplied by the same number.
4. Two equal rows => $det = 0$.
5. if a multiple of a row is added to another row, the determinant does not change.
6. Row of zeros leads to zero determinant.
7. Determinant of upper triangular matrix:
```math
	det \begin{bmatrix} d_1 & * & \cdots & * \\ 0 & d_2 & \cdots & * \\ 		\vdots & \vdots & \cdots & \vdots \\ 0 & 0 & \cdots & d_n 
 	\end{bmatrix} = d_1 d_2 \cdots d_n
```
9.  $det \;{\bf A} = 0$ when $\bf A$ is singular
10.  $det \;{\bf A} = det \;{\bf A}^𝑇$ → (All the properties are also valid for the columns)
12.  $det \;{\bf A\;B} = (det \;{\bf A}) (\;det \;{\bf B})$
    -  $det (\;{\bf A\;A}^{-1})=det \;{\bf I} \Rightarrow det \;{\bf A}^{-1}=1/det \;{\bf A}$
    -  $det \;{\bf A}^2 = (det \;{\bf A})^2$

"

# ╔═╡ 2d036e2e-6850-46d8-bbb5-21856403ecc8
md"# A Few Applications
\
`` \bullet \Large \;\; Markov \;\; Process``

`` 	\qquad - PageRank``

``  \qquad - Covid-19 \;\; Survival \;\; Analysis ``

`` \bullet \Large \;\;Compression \;\;(Image, \;Data, \;etc.) ``

`` \qquad - A \;sample \;image \;and \;compression \;via \;SVD ``

 `` \bullet \Large \;\;Regression ``

 `` \qquad - Linear \;and \;non-linear ``

"

# ╔═╡ 7ad20af1-a7d6-4092-b982-fad27d6e51ea
md"## Markov Processes 

### 1. Page Rank[^1] 
**_Birth of Google's PageRank algorithm:_** Lawrence Page, Sergey Brin, Rajeev Motwani and Terry Winograd published [“The PageRank Citation Ranking: Bringing Order to the Web”](http://ilpubs.stanford.edu:8090/422/), in 1998, and it has been the bedrock of the now famous PageRank algorithm at the origin of Google. 

From a theoretical point of view, the PageRank algorithm relies on the simple but fundamental mathematical notion of **_Markov chains_**.

PageRank is a function that assigns a real number to each page in the Web
that the higher the number, the more **important** it is.

[^1]: _Introduction to Markov chains: 
	Definitions, properties and PageRank example_, Joseph Rocca, Published in _Towards Data Science_ in Feb 25, 2019.
"

# ╔═╡ ba3404b3-956e-4ca8-93aa-070897bdaa9a
begin
	pgrank = load("PageRank-hi-res.png");
	pgrank[1:10:size(pgrank)[1],1:10:size(pgrank)[2]]
end

# ╔═╡ 2633b604-7476-48d0-8cdc-05645ea0ed57
md"#
### PageRank of a tiny website
"

# ╔═╡ 3e93d41f-e465-42c4-b18e-e6dc99a3d1ad
markov_example = load("markov_fig.gif");

# ╔═╡ d50ef757-c687-4695-a4f3-2740a646ccd8
TwoColumn(
plot(markov_example[:,:,1], xmirror=true, title="Website with 7 pages", axis = false, ticks = false, aspect_ratio=1.0, size = (350, 400)),
md"""
$\Large Markov \;\;Matrix$
```math
 {\bf M} = \begin{bmatrix} \cdot & \cdot & \cdot & 0.5 & 1.0 & \cdot & 0.5 \\ 0.25 & \cdot & 0.5 & \cdot & \cdot & \cdot & \cdot \\ \cdot & 0.5 & \cdot & \cdot & \cdot & \cdot & \cdot \\ \cdot & 0.5 & 0.5 & \cdot & \cdot & \cdot & 0.5 \\ 0.25 & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\ 0.25 & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\ 0.25 & \cdot & \cdot & 0.5 & \cdot & 1.0 & \cdot \end{bmatrix}  
```
where 
- '$\cdot$' represents zero,
- each column represents a page,
- numbers in the columns represent the transition probabilities
- sum of the probabilities of transioning from a page to all other pages must be equal to 1.
"""		
)

# ╔═╡ b802bd1c-c590-499c-990f-596159fea135
M = [0.0 0.0 0.0 0.5 1.0 0.0 0.5;
	0.25 0.0 0.5 0.0 0.0 0.0 0.0
	0.0 0.5 0.0 0.0 0.0 0.0 0.0
	0.0 0.5 0.5 0.0 0.0 0.0 0.5
	0.25 0.0 0.0 0.0 0.0 0.0 0.0
	0.25 0.0 0.0 0.0 0.0 0.0 0.0
	0.25 0.0 0.0 0.5 0.0 1.0 0.0] # "Command + /" to toggle between commented and actived cells

# ╔═╡ 0872e2b8-386a-40a4-b2cb-48f564c921d8
ones(7)' * M # Sum of all columns must be 1 as the total probability can not exceed 1

# ╔═╡ a3611641-256e-49e8-9e2e-c78b9efc21ce
md"""#
#### Next Steps

* Define an inital state: suppose a random surfer starts at Page-1, so the inital state is ${\bf x_0}=[1 \; 0 \; 0 \; 0 \; 0 \; 0 \; 0]'$.
* Next state $\bf x_1 = M x_0$ is given as 

```math 
{\bf x_1} = \begin{bmatrix} \cdot & \cdot & \cdot & 0.5 & 1.0 & \cdot & 0.5 \\ 0.25 & \cdot & 0.5 & \cdot & \cdot & \cdot & \cdot \\ \cdot & 0.5 & \cdot & \cdot & \cdot & \cdot & \cdot \\ \cdot & 0.5 & 0.5 & \cdot & \cdot & \cdot & 0.5 \\ 0.25 & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\ 0.25 & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\ 0.25 & \cdot & \cdot & 0.5 & \cdot & 1.0 & \cdot \end{bmatrix} \begin{bmatrix} 1 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix} = \begin{bmatrix} \cdot \\ 0.25 \\ \cdot \\ \cdot \\ 0.25 \\ 0.25 \\ 0.25 \end{bmatrix}
```
"""

# ╔═╡ 541a573c-2e87-49dc-97e7-778a50364e52
state0 = [0, 0, 1, 0, 0, 0, 0] # [1/7, 1/7, 1/7, 1/7, 1/7, 1/7, 1/7] 

# ╔═╡ dd6f459f-898f-4370-9cc8-35e410a76cc7
state = zeros(7,50); # Initialize the state matrix

# ╔═╡ f6e62718-42b7-4e0b-b9ab-60fbf3bfa4a6
state[:,1] = M * state0

# ╔═╡ 7516b6a6-1f70-4bab-a320-ae16b028e6be
md"#
and 
* the following states
```math
{\bf x_2 = M x_1} → {\bf x_3 = M x_2} → \cdots → {\bf x_n = M x_{n-1}}
```
OR

```math
{\bf x_n = M^n x_0}
```
"

# ╔═╡ d1eec44f-5373-4a5c-8013-46434a6679b2
state[:,2] = M * state[:,1]

# ╔═╡ aacf8539-f733-4c1b-a7e6-46c6c81cf256
state[:,3] = M * state[:,2]

# ╔═╡ 091d6eae-ec41-4957-8955-09ec7647a574
state[:,4] = M * state[:,3]

# ╔═╡ fc9d1dad-596a-432f-bbaf-6cff95986dd0
state[:,5] = M * state[:,4]

# ╔═╡ 2818d860-77a3-4a53-8db3-a9d6cba8909a
state[:,10] = M^10 * state0

# ╔═╡ fb77bfcc-0d99-4ebd-aa4e-a96e5d190de9
state[:,20] = M^20 * state0

# ╔═╡ 9bc38bf4-7428-4190-aa07-42f03df542e3
state[:,30] = M^30 * state0

# ╔═╡ e19c2e7b-7587-4584-9093-3e8c8563cdc9
md"#
### Properties of Markov Matrix
* ##### What do you notice from the above computations?
   - ###### States converge;  
     - How can we measure the distance between each state, `norm`?  
     - Is the steady-state distribution dependent on the distribution of the initial state?  
     -  Is $\bf M^n x_n = x_n$ correct? What is your conclusion from this?
  
   - ###### All numbers in each state sum up to '$1$'. True or False?

* ##### How do you interpret the end state after 30 transitions?
```math
{\bf x_{30}} = \begin{bmatrix} 0.29 & 0.095 & 0.047 & 0.19 & 0.07 & 0.07 & 0.238 \end{bmatrix}'
```
"

# ╔═╡ 20e0521b-1943-4eef-85b2-e46d6fc1d9c0
bar([i for i in 1:7], state[:,30], legend = false, xlabel ="Pages", ylabel= "PageRank values", size = (600, 350))

# ╔═╡ a10cae47-2b16-421f-9f1c-cdd8a6eda5ad
md"#
##### Norm

* Norm is the length of a vector ${\bf v}$ and represented by $\| {\bf v} \|$
* There are different norm definitions and the three widely used ones in order are
  - ``L_1`` norm =  $\| {\bf v} \|_1 = |v_1| + |v_2| + \cdots + |v_n|$; `norm(v,1)` in _Julia_
  - ``L_2`` norm (≡ Euclidian norm) = $\| {\bf v} \|_2 = \sqrt{v_1^2 + v_2^2 + \cdots + v_n^2}$;  `norm(v,2)` in _Julia_
  - ``L_{\infty}`` norm (≡ Max norm) = $\| {\bf v} \|_\infty  = Max[{|v_1|, |v_2|, \cdots, |v_n|}]$; `norm(v,Inf)` in _Julia_

!!! note
	Throughout this course, mostly Euclidian Norm will be used and subscript '2' will be droped in $\| {\bf v} \|$.
"

# ╔═╡ 1798453f-54cc-45e8-b65d-9e5745dbfbd6
begin
	error_L1 = zeros(20); # distance between iterations error(i) = state(i)-state(i-1)
	error_L2 = zeros(20);
	error_Linf = zeros(20);
	state[:,1] = M * state0
	error_L1[1] = norm(state[:,1]-state0, 1) # L_1 norm
	error_L2[1] = norm(state[:,1]-state0, 2) # default L_2 norm 
	error_Linf[1] = norm(state[:,1]-state0, Inf) # L_inf norm
 	for i in 2:20
		state[:,i] = M * state[:,i-1]
		error_L1[i] = norm(state[:,i] - state[:,i-1], 1)
		error_L2[i] = norm(state[:,i] - state[:,i-1], 2)
		error_Linf[i] = norm(state[:,i] - state[:,i-1], Inf)
	end
end

# ╔═╡ 78e59b84-97e1-4042-af3a-065f992e1176
begin
	plot([1:20], error_L1, xlabel = L"Number \;of \;Transitions", title = L"Distance \;between \;the \;last \;two \;transitions", label = L"L_1 \;Norm", mark = :square, fg_legend = :false)
	plot!([1:20], error_L2, mark = :circle, label = L"L_2 \;Norm")
	plot!([1:20], error_Linf, mark = :diamond, label = L"L_{\infty} \;Norm")
end  	

# ╔═╡ 9a987b58-47e9-4191-8fb7-9225d27d2628
md"#
##### Role of Initial State
In Markov matrices, there are few properties that we need to state for the sake of understanding its potential and problems: For Markov Matrices,
- the sum of each column must be '1'; $\rightarrow [1 \;1 \cdots 1]\; {\bf M} =[1 \;1 \cdots 1]$   
- if entries postive,
  - called positive Markov matrices, they always converge to a unique steady-state; However,
- if not, that is, if there are zero entries, then
  - it may still converge to a single steady-state or converge to more than one steady-states dependent on the initial state $x_0$; 
* iterations maintain the sum of the entries of the initial guess, that is
$[1 \;1 \cdots 1]\; {\bf x_1} = [1 \;1 \cdots 1]\; {\bf M x_0} = [1 \;1 \cdots 1]\; {\bf x_0}$
"

# ╔═╡ 54cbf7b1-95d0-4027-b65f-a5ad5808e4b4
let
	state0 =[0, 0, 1, 1, 1, 0, 0]
	state30 = M^30 * state0
	nstate30 = state30 / sum(state30)
	bar([i for i in 1:7], nstate30, legend = false, xlabel ="Pages", ylabel= "PageRank values")
end

# ╔═╡ b6036a94-7e1f-40f4-a905-b9081fd25c8a
md"#
##### Is $\bf M^n x_n = x_n$ ?   What is your conclusion?

- Do you remember ${\bf A x}=\lambda {\bf x}$ ? `Eigenvalues` and `Eigenvectors`
-  $\bf M^n x_n = x_n$ implies that Markov matrix $\bf M$ has an eigenvalue at $\lambda = 1$ with its eigenvector $\bf x_n$
-  So, finding the eigenvector of $\bf M$ corresponding to eigenvalue $\lambda = 1$ will directly give the steady-state:
"

# ╔═╡ 66fe1bad-ae41-4e10-82ce-64b36d446049
# lambda = eigvals(M) # Eigenvalues of M

# ╔═╡ 7956a61e-f1c1-44b6-9583-1df552051af6
# eigv = eigvecs(M) # Eigenvectors of M in the order of eigenvalues

# ╔═╡ 5a4eb37f-82db-40f3-be2d-0412e473ccb1
# n_eigenvector = eigv[:,7] / sum(eigv[:,7]) # need to mormalize to the sum of the vector.

# ╔═╡ b9d3cf7e-942b-4cb3-bda2-c932dcc314a4
# norm((eigv[:,7] / sum(eigv[:,7]) - state[:,30]),Inf) # see the distance (norm) between the eigenvector for lambda =1 and the state we have reached after 30 iterations

# ╔═╡ 7c35704a-c6dc-429a-b28f-105764177636
md"""
!!! note \"Project Idea - 1\"
	Review the PageRank algorithm of Google and find a way to promote your web page.
"""

# ╔═╡ b16906ed-b4ab-446e-a0e8-d79418ef56ca
md"#
### 2. Covid-19 Survival Analysis[^2]

[^2]: [_A Markov Chain Model for Covid-19 Survival Analysis_] (https://web.cortland.edu/matresearch/MarkovChainCovid2020.pdf), Jorge Luis Romeu, July 17, 2020.

The problem was formulated with three states under two `infection` rate scenarios, namely 5% as suggested by CDC (Centers for Desease Control) and 10% for aggressive case: `Non infected`, `Infected` and `Hospitalized` with the following probabilities in Markov matrices:

```math
{\bf M_1^{CDC}} = \begin{bmatrix} 0.95 & 0.10 & 0.00 \\ 
						  0.05 & 0.70 & 0.30 \\ 
						  0.00 & 0.20 & 0.70  \end{bmatrix}
\qquad {\bf M_2^{Agg}} = \begin{bmatrix} 0.90 & 0.12 & 0.00 \\ 
						    0.10 & 0.70 & 0.20 \\ 
						    0.00 & 0.18 & 0.80  \end{bmatrix}

```
where 
*  $1^{st}$ column represents `Non infected` and their transitions to other states;
*  $2^{nd}$ column is for `Infected` and their transitions to other states;
*  $3^{rd}$ column is for `Hospitalized` and their transitions to other states.

!!! warning \"The goal of this study is to assess\"
	* the long-run (≡ steady-state) percent of cases in each of the states, 
	* the rates at which these states populated under two different infection rates.
"

# ╔═╡ e4a6e169-925f-490b-b03a-21f277ff0fa5
M_covCDC = [0.95 0.10 0.0 ;
	0.05 0.70 0.30
	0.0 0.20 0.70]

# ╔═╡ b0d2fd84-3307-4a6d-af91-32cfdaa375f0
M_covAgg = [0.90 0.12 0.0 ;
	0.10 0.70 0.20
	0.0 0.18 0.80]

# ╔═╡ ffe0fb93-50f4-4a1d-b73b-e24fb729d043
md"""# 
!!! note
	Largest eigenvalue of the Markov matrix is expected be '$1$' and its corresponiding eigenvector to be the state-state.

"""

# ╔═╡ 00653f98-5a3c-4baa-a0b1-405905dd1e69
# λ_CDC, v_CDC = eigen(M_covCDC) # just to give you an example of a variable name in greek letter

# ╔═╡ dc5833d4-b9e6-4ac0-999e-5c86428f6b8a
# lambda_covCDC, eigv_covCDC = eigen(M_covCDC)

# ╔═╡ 16f24a88-91f8-455c-b415-c33f27224fc0
# lambda_covAgg, eigv_covAgg = eigen(M_covAgg)

# ╔═╡ d29b41b0-f453-4c61-95ac-42695a07187a
md"
* As expected, $\lambda_{max} = 1.0$ and corresponding eigenvetors [-0.86, -0.43, -0.286] for the CDC case and [0.67, 0.55, 0.50] for the Aggressive case.
* Since the eigenvector is to represent the probabilities of being in these three states in the long-run, it needs to be normalized to make the sum of the vector unity. 
"

# ╔═╡ 3fc7529c-e101-480b-87d6-85400bbebd03
# ss_covidCDC = eigv_covCDC[:,3]/ sum(eigv_covCDC[:,3])

# ╔═╡ cc0f82bc-096c-444e-a078-37e91d019234
# ss_covidAgg = eigv_covAgg[:,3]/ sum(eigv_covAgg[:,3])

# ╔═╡ 3b210f36-33fb-4405-a9cf-9403d65cdce9
TwoColumn(
	md"""
##### CDC scenario (5%)

* 54.5% `Non infected`
* 27.3% `Infected`
*  $\color{red} 18.2\% \;\;Hospitalized$
""",
	md""" #####  Aggressive Scenario (10%)

* 38.7% `Non infected`
* 32.2% `Infected`
*  $\color{red} 29.0\% \;\;Hospitalized$
"""		
)


# ╔═╡ db20720c-98d2-44b1-a9a3-8acc04ca55b9
md"""#
##### More Realistic

* Define the Markov chain over five states:
  - non infected (in the general population) → 93% remain uninfected, 7% infected
  - infected (isolated at home) → 5% recovered, 80% remain isolated at home, 10% hopitalized, 5% in ICU
  - hospitalized (after becoming ill) → 15% recovered and sent to home for isolation, 80% remain hospitalized, 5% in ICU
  - in the ICU (or ventilators) → 5% recovered and stayed in hospital, 80% remain in ICU, 15% dead
  - dead (absorbing state)

* Based on the data avilable, set up the Markov matrix as
```math
{\bf M} = \begin{bmatrix} {\color{green} 0.93} & {\color{blue} 0.05} & {\color{orange} \cdot} & {\color{red} \cdot} & \cdot \\ 
						  {\color{green} 0.07} & {\color{blue} 0.80} & {\color{orange} 0.15} & {\color{red} \cdot} & \cdot \\ 
						 {\color{green} \cdot} & {\color{blue} 0.10} & {\color{orange} 0.80} & {\color{red} 0.05}  & \cdot \\ 
	   					 {\color{green} \cdot} & {\color{blue} 0.05} & {\color{orange} 0.05} & {\color{red} 0.80}  & \cdot \\ 
		  				 {\color{green} \cdot} & {\color{blue} \cdot} & {\color{orange} \cdot} & {\color{red} 0.15} & 1.0  \end{bmatrix}  \Leftarrow {\bf Markov \; \; Matrix}
```
where 
*   $\color{green} green$ column is for `non-infected`
*   $\color{blue} blue$ column is for `infected`
*   $\color{orange} orange$ column is for `hospitalized`
*   $\color{red} red$ column is for `ICU`
*   $black$ column is for `dead`

!!! warning \"Goal\"
	_Probability of Death_ and _Expected Time to Death_.

"""

# ╔═╡ 4778254b-f59f-4080-976b-44c6a8f68adc
md"""#
##### For the Markov model
* the unit time is a day, transitions refer to changes from one morning to the following;
* every transition at time T is independent corresponding to a transition from its current state to its next; 
* the data are closer to the cases in Italy or NYC at the height of their Covid crisis.

!!! danger \"Absorbing State\"
	Notice that, in the last column (dead state), there is a single entry with propability '1' to stay in the same state, that is, the final state, **no return**.
"""

# ╔═╡ 52a2d40f-069f-4e4b-9e3d-74d8f5c93632
M_cov = [0.93 0.05 0.0 0.0 0.0;
	0.07 0.80 0.15 0.0 0.0
	0.0 0.10 0.80 0.05 0.0
	0.0 0.05 0.05 0.80 0.0
	0.0 0.0 0.0 0.15 1.0]

# ╔═╡ aed82abb-a91e-4ddc-91d3-9da1f5730459
md"

##### What happens to $\bf x_n = M^n x_0$? 
##### Where does $\bf M^n$ converges to for $n→∞$?
"

# ╔═╡ e8f7eb00-8e18-4b31-8e4a-493cf81acb92
md"#
${\bf Brute \;force \;calculation}$
"

# ╔═╡ 58646f88-df1a-488c-a951-1f942714ef5d
M_cov^500 # each column converges to [0, 0, 0, 0, 1]

# ╔═╡ 00f6f985-8d07-4909-8e64-9db412ae816b
md"

${\bf Eigenvalue \;and \;eigenvector \;calculation}$

"

# ╔═╡ 4ae8ce86-13de-4c3d-9f9c-06460d907c23
lambda_cov, eigv_cov = eigen(M_cov)

# ╔═╡ 7a2e4158-cbff-429a-aaea-88a415f8ec3c
eigv_cov[:,5] # corresponds to lambda=1, so steady-state seems to be when everyone is dead?

# ╔═╡ f2fbd554-26fa-4f87-819f-0c7b14891764
md" 
${\bf In \;steady \;state, \;it \;converges \;to \;the \;aborbing \;state}$

!!! danger \" Everybody will be dead 🤔\"
"

# ╔═╡ ec0f0925-e565-47fe-814a-cb6bf8caaee3
md"""#

##### How can you proceed?

##### A brief overview for curious minds (not included) [^3]

Assume that we have an absorbing Markov chain with the following transition matrix in \"block\" form:

```math
{\bf M} = \begin{bmatrix} {\bf T} & {\bf 0}_{k \times l} \\ 
						  {\bf R} & {\bf I}_l  \end{bmatrix} 
```
where 
*  $\bf T$ is an $k \times k$ matrix with probabilities of moving from one transient state to another transient state.
*  $\bf R$ is an $l \times k$ matrix with probabilities of moving from a transient state to an absorbing state.
*  ${\bf 0}_{k×l}$ is an $k × l$ matrix of all $0$’s, as moving from an absorbing state to a transient state is impossible.
*  ${\bf I}_l$ is an $l×l$ identity matrix, as transitioning between absorbing states is impossible.

!!! note
	One can always cast the Markov matrix in a similar block form, when there are some absorbing states, by intechanging the order of columns and rows.
 
As the system transions, $M^2$, $M^3$, ..., $M^n$ need to be calculated:
```math
{\bf M^2} = \begin{bmatrix} T & 0_{k \times l} \\ 
						  R & I_l  \end{bmatrix} 
		  \begin{bmatrix} T & 0_{k \times l} \\ 
						  R & I_l  \end{bmatrix} = 
		  \begin{bmatrix} T^2 & 0_{k \times l} \\ 
						  RT+R & I_l  \end{bmatrix}
```
```math
{\bf M^3} = \begin{bmatrix} T & 0_{k \times l} \\ 
						  R & I_l  \end{bmatrix} 
		 \begin{bmatrix} T^2 & 0_{k \times l} \\ 
						 RT+R & I_l  \end{bmatrix} = 
		  \begin{bmatrix} T^3 & 0_{k \times l} \\ 
						  RT^2+RT+R & I_l  \end{bmatrix}
```
$\vdots$
```math
{\bf M^n} = \begin{bmatrix} T^n & 0_{k \times l} \\ 
						  R+RT+\cdots+RT^{n-1} & I_l  \end{bmatrix} =
		  \begin{bmatrix} T^n & 0_{k \times l} \\ 
						  R \sum_{i=0}^{n-1}T^i & I_l  \end{bmatrix}
```

For $n → ∞$, the series $\sum_{i=0}^{n-1}T^i → (I-T)^{-1}$, provided the column sums of $T$ are less than $1$.


[^3][Absorbing Markov Chains] (https://www.math.umd.edu/~immortal/MATH401/book/ch_absorbing_markov_chains.pdf), Allan Yashinski, July 21, 2021
"""

# ╔═╡ 2b5cd8bb-7df2-4e59-8956-26b1974d9f0f
# T = M_cov[1:4,1:4] # Block T, only the transient porton of M

# ╔═╡ 6a056c28-bb34-42dc-92c2-c100154685a4
# R = M_cov[5,1:4] # Block R, from transient to absorbing state

# ╔═╡ 2bc35e57-a5d4-484e-9dd9-ccaa7566eaf7
# ones(4)' * T # to check if the column sums are less than 1 => NOT

# ╔═╡ 330a0efe-c14e-4153-bd95-8b1fd9c27e66
# ones(4)' * T^5 # However, higher powers of T satisfy this criterion, which would be enough for the approximation

# ╔═╡ 88592d8b-6115-4258-bd3f-33e01101e8dc
# lambda_T = eigvals(T) # eigvals and eigvecs give e-values and e-vectors separately

# ╔═╡ 78dfd8bd-ba3e-47c8-878a-b735a0f5d787
md"""#
Therefore, the Markov matrix at steady-state approaches to
```math
\lim_{n→∞}{\bf M^n} = \lim_{n→∞} \begin{bmatrix} {\bf T}^n & {\bf 0}_{k \times l} \\ 
						  {\bf R} \sum_{i=0}^{n-1}{\bf T}^i & {\bf I}_l  \end{bmatrix} \Rightarrow
				{\bf M^{ss}} = \begin{bmatrix} {\bf 0}_{k \times k} & {\bf 0}_{k \times l} \\ 
						  {\bf R} ({\bf I-T})^{-1} & {\bf I}_l  \end{bmatrix}
```
where only surviving block is the one showing the transition probabilities from transient states to absorbing states ${\bf R} ({\bf I-T})^{-1}$.

* Remember $\bf R$ is composed of probabilities of moving from transient states to the absorbing state.
*  Define ${\bf F = (I-T)}^{-1}$ → Fundamental Matrix
"""

# ╔═╡ 4c3f565a-9938-44e6-9105-f4a949774ea0
# F = (I(4) - T)^-1 # or inv(I(4)-T) Fundamental Matrix

# ╔═╡ fdc5a903-61c4-411f-8726-be012cbd8cfc
# R' * F # as expected, in steady-state, it goes to the absorbing state

# ╔═╡ 424187c3-f6d3-4642-8d37-6266a2d9c597
md"""
##### ${\bf F = (I-T)}^{-1}$ → Average number of days in transient states

```math
{\bf F} = ({\bf I-T})^{-1} = \begin{bmatrix} 26.19 & 11.90 & 9.52 & 2.38 \\ 
						 16.67 & 16.67 & 13.33 & 3.33 \\ 
	   					 10.0 & 10.0 & 13.3 & 3.33 \\ 
		  				 6.67 & 6.67 & 6.67 & 6.67 \end{bmatrix} 
```

##### Interpretation
The average number of days a `non infected` person ($1^{st}$ column)
* stays `non infected` is 26.19 days;
* spends `infected (isolated)`, after being infected, is 16.67 days;
* spends in `hospital` is 10.0 days
* spends in `ICU`, before passing away, is 6.67 days.

!!! note \"Project Idea - 2\"
	Based on Istanbul's Covid data, analyze the situation during the inital and latest phases of the pandemic.
"""

# ╔═╡ 3ee12973-b0ad-409c-a451-bb765ad01cff
md"""
<center><b><p
style="color:black;font-size:40px;">END</p></b></center>
"""|>HTML

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
QuartzImageIO = "dca85d43-d64c-5e67-8c65-017450d5d020"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
FileIO = "~1.13.0"
HypertextLiteral = "~0.9.3"
ImageIO = "~0.6.1"
ImageShow = "~0.3.3"
LaTeXStrings = "~1.3.0"
Plots = "~1.25.8"
PlutoUI = "~0.7.34"
QuartzImageIO = "~0.7.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0-beta3"
manifest_format = "2.0"
project_hash = "8eb0f17925b0aa3f6d6713e45e82c1a7d70f7b80"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f9982ef575e19b0e5c7a98c6e75ee496c0f73a93"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.12.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Luxor", "Random"]
git-tree-sha1 = "5b7d2a8b53c68dfdbce545e957a3b5cc4da80b01"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ae13fcbc7ab8f16b0856729b050ef0c446aa3492"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.4+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "80ced645013a5dbdc52cf70329399c35ce007fae"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.13.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "4a740db447aae0fbeb3ee730de1afbb14ac798a1"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.63.1"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "aa22e1ee9e722f1da183eb33370df4c1aeb6c2cd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.63.1+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[deps.ImageIO]]
deps = ["FileIO", "JpegTurbo", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "464bdef044df52e6436f8c018bea2d48c40bb27b"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.1"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "d0ac64c9bee0aed6fdbb2bc0e5dfa9a3a78e3acc"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.3"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.81.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "25d5e6b4eb3558613ace1c67d6a871420bfca527"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.52.4+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "Random", "Requires", "Rsvg"]
git-tree-sha1 = "81a4fd2c618ba952feec85e4236f36c7a5660393"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.0.0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "648107615c15d4e09f7eca16307bc821c1f718d8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.13+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "eb4dbb8139f6125471aa3da98fb70f02dc58e49c"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.14"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a121dfbba67c94a5bec9dde613c3d0cbcf3a12b"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.3+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "6f1b25e8ea06279b5689263cc538f51331d7ca17"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.3"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "eb1432ec2b781f70ce2126c277d120554605669a"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.8"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8979e9802b4ac3d58c503a20f2824ad67f9074dd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.34"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.QuartzImageIO]]
deps = ["FileIO", "ImageCore", "Libdl"]
git-tree-sha1 = "16de3b880ffdfbc8fc6707383c00a2e076bb0221"
uuid = "dca85d43-d64c-5e67-8c65-017450d5d020"
version = "0.7.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "37c1631cb3cc36a535105e6d5557864c82cd8c2b"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "8d0c8e3d0ff211d9ff4a0c2307d876c99d10bdf1"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.2"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "a635a9333989a094bddc9f940c04c549cd66afcf"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
git-tree-sha1 = "d88665adc9bcf45903013af0982e2fd05ae3d0a6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "51383f2d367eb3b444c961d485c565e4c0cf4ba0"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.14"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "d21f2c564b21a202f4677c0fba5b5ee431058544"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.4"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "991d34bbff0d9125d93ba15887d6594e8e84b305"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.3"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "c23323cd30d60941f8c68419a70905d9bdd92808"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.6+1"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.41.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "16.2.1+1"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─5504aec1-ecb0-41af-ba19-aaa583870875
# ╟─cb5b4180-7e05-11ec-3b82-cd8631fc57ba
# ╟─98ddb325-2d12-44b5-90b6-61e7eb55bd68
# ╟─1c5063ab-e965-4c3b-a0d9-7cf2b272ad48
# ╟─b1eefcd2-3d91-42e5-91e8-edc2ed3a5aa8
# ╟─a9c98903-3f39-4d69-84cb-2e41f8cca9ac
# ╠═0c2bf16a-92b9-4021-a5f0-ac2334fb986a
# ╟─3de20f99-af1c-413a-b8f4-dc2d259ece3a
# ╟─8d0ad71b-34ca-407c-bd09-3fa191122c70
# ╟─2fdeb1e8-5811-4dcb-881a-5e857889f6ca
# ╟─9648cc3d-3e45-4dee-b245-1865b31f3c4c
# ╟─ae8bd2b8-f1a2-4ec4-a688-36be1d74b22f
# ╟─a01b7bc9-ed73-42a1-af62-40cad8a403a8
# ╟─d5551789-6389-4a4e-be19-2399ece4236b
# ╟─d553f6c0-364d-4b8c-ba9f-dec14261be06
# ╟─520539c0-479e-4168-8667-668ef2077a18
# ╟─fb2795d8-63e4-4d30-bb77-b1e30d59b185
# ╟─59abb2ae-9614-4ffe-bb2c-c2646629e509
# ╟─77cd7684-b0ee-4cb7-a0f7-be9a4cbb3b58
# ╠═3c0a921b-c8cc-4e8b-b0a6-3eb5d339fa63
# ╟─3a417947-eb23-4247-9e79-af925733aabf
# ╟─aa13c9ca-4b07-4a64-a073-65ea7e0e6c99
# ╠═af88ebfb-e6bf-4fa0-85c7-79fe09705509
# ╟─0d1fd69e-9290-43dd-b79d-e78a8aab65b0
# ╟─7a1eb229-da44-40e0-8365-640a5ce88569
# ╟─c72c74f8-d5e5-4ebb-a0e5-384fc00a13e6
# ╠═ae6fbc53-26d9-4980-b755-9d2278badfc3
# ╠═a9873638-7338-414e-8f30-054ba220114d
# ╠═2b9984b3-b38e-498b-9a05-3df4f56c525e
# ╟─8c39de20-0c8e-4d02-bcf6-b8f89dd83a8f
# ╠═19adef74-4e28-4aab-9f05-92bcfde1bf73
# ╠═e4df508d-9f85-41a1-8cae-45d1505784b9
# ╠═3bf2e096-bd06-431c-b771-a0fb5ebc1233
# ╠═148996bf-5bf0-425f-bc42-215ff2bce311
# ╠═9940c439-de80-4fc0-8c4d-b59ac2adb379
# ╠═c07dff77-c850-4f74-a5b6-18a1c7ecb176
# ╠═f70af9cd-6a95-4d1e-af12-2dd8d52399dc
# ╠═b198c118-34eb-478e-a2cd-c8e6c19aec93
# ╟─19e9c605-fb39-450a-a4a2-edf617c72614
# ╠═060cb524-7c1d-422d-82ea-7263d829a0cb
# ╠═856870ec-570a-4fe9-a602-128d8bbe2db0
# ╠═c7c0a6ba-060b-48c5-82cb-af8845fab924
# ╠═dce70b81-3fe7-4056-a54b-a8fb3992c80a
# ╠═9eb501af-996e-4300-aa87-3f1d32b08d0b
# ╠═2ce8dab0-14ea-46b3-914a-59968dcff4ec
# ╠═e10b126b-17ee-4f93-aaeb-a5f1a1b34cb1
# ╠═4f0deacb-cd05-4786-aec1-4f6bc635b787
# ╠═b49cf4b8-f690-4768-b27d-0104b0619317
# ╟─78f0d566-903a-4018-b3e4-b1748e60c10c
# ╠═a5d67212-6356-4caf-966e-14b0a851b00e
# ╟─f3838d6f-0b17-48fe-b90a-0053f7ce74dc
# ╠═dc5e390f-ece4-4e27-9b25-023a731cc633
# ╠═eec8c31c-5324-44a4-8e55-3fed81d9dbd8
# ╟─f130d717-bedc-4ebd-bba5-3908d54c07bc
# ╠═4fd22565-7443-4f10-baf3-a2881651a2be
# ╠═556f68f3-481b-4660-b5bd-f1a643676ee2
# ╠═05c341eb-3db3-42bd-ae08-05f8aa370cb7
# ╟─ba787e69-7f86-4f41-87f5-b20d9e8831c6
# ╠═144114a0-20f1-4fee-8d7b-331274442bfb
# ╠═8ead573c-e4a3-41e7-9d5e-8494f53ca6e4
# ╠═2efcc362-ebb1-41d7-a899-7854efa215ca
# ╠═f190b01d-9268-4c44-ae01-cc17f927704e
# ╠═45ced395-a8a2-465b-9552-186806b0e6e1
# ╠═2cf6c3c0-0406-49d8-b53b-56983d290188
# ╠═55fdee4a-3860-4a88-9790-bcfba7ee35fb
# ╟─2d3abfe1-8cda-49f8-b5b1-b8b602626d92
# ╠═b86955b4-9a9f-47c7-bec4-9069fbbd4061
# ╟─346bba70-2209-4d07-8c02-63a74e8c622d
# ╠═5ed395e8-20c8-4e34-8a15-7d51b1d9949a
# ╟─e022e5e5-186b-48f8-bd7d-4be9dc6610ab
# ╟─a55816f3-1c24-4e6f-b35f-2aba8f8e8194
# ╠═c7f02d62-d81c-4cf0-860c-79ea6b5fd7ab
# ╠═7f367404-7275-4e35-9242-ebec5ac0668d
# ╠═28ec3f99-0741-478d-b5e0-94b0baefd56c
# ╠═444147d7-b570-4685-b1b9-cbab58f0bd7b
# ╠═4e2ca663-4fa4-4d33-96b4-bc495c911871
# ╟─e36cbcee-5092-4d91-ad44-be63b695ce60
# ╠═612e0950-320c-4bbc-ae1a-db85307696fc
# ╠═7e0ce959-5a70-4311-9031-540bf2414dd6
# ╟─e3d39b29-c0ef-45b1-96a5-e26a1e8763c5
# ╟─1668cb38-6078-4a7f-8ade-96f6d42280b6
# ╠═d9636375-def7-4693-a2c3-91879d304b81
# ╠═9023f8f4-2084-4ef6-b9ca-a94e967320e5
# ╠═01c9e212-8cbc-4fb5-83d3-62dd0bfe48f7
# ╠═4c42ba85-442d-4ca8-9731-1bf71563e86e
# ╠═d9a74a15-8867-4b62-a6c3-943f6b6b6179
# ╟─75e91ef3-8893-48fc-a297-e54aa6b6c671
# ╟─1de74de8-36c5-467f-a749-4cefd0b2acdc
# ╟─877ef381-df6c-4a5b-bf99-88f8afba0995
# ╟─2d036e2e-6850-46d8-bbb5-21856403ecc8
# ╠═b5449b8e-3000-48dc-a788-1d357569a5a9
# ╟─7ad20af1-a7d6-4092-b982-fad27d6e51ea
# ╟─ba3404b3-956e-4ca8-93aa-070897bdaa9a
# ╟─2633b604-7476-48d0-8cdc-05645ea0ed57
# ╟─3e93d41f-e465-42c4-b18e-e6dc99a3d1ad
# ╠═d50ef757-c687-4695-a4f3-2740a646ccd8
# ╟─b802bd1c-c590-499c-990f-596159fea135
# ╠═0872e2b8-386a-40a4-b2cb-48f564c921d8
# ╟─a3611641-256e-49e8-9e2e-c78b9efc21ce
# ╠═541a573c-2e87-49dc-97e7-778a50364e52
# ╠═dd6f459f-898f-4370-9cc8-35e410a76cc7
# ╠═f6e62718-42b7-4e0b-b9ab-60fbf3bfa4a6
# ╟─7516b6a6-1f70-4bab-a320-ae16b028e6be
# ╠═d1eec44f-5373-4a5c-8013-46434a6679b2
# ╠═aacf8539-f733-4c1b-a7e6-46c6c81cf256
# ╠═091d6eae-ec41-4957-8955-09ec7647a574
# ╠═fc9d1dad-596a-432f-bbaf-6cff95986dd0
# ╠═2818d860-77a3-4a53-8db3-a9d6cba8909a
# ╠═fb77bfcc-0d99-4ebd-aa4e-a96e5d190de9
# ╠═9bc38bf4-7428-4190-aa07-42f03df542e3
# ╟─e19c2e7b-7587-4584-9093-3e8c8563cdc9
# ╠═20e0521b-1943-4eef-85b2-e46d6fc1d9c0
# ╟─a10cae47-2b16-421f-9f1c-cdd8a6eda5ad
# ╟─1798453f-54cc-45e8-b65d-9e5745dbfbd6
# ╟─78e59b84-97e1-4042-af3a-065f992e1176
# ╟─9a987b58-47e9-4191-8fb7-9225d27d2628
# ╟─54cbf7b1-95d0-4027-b65f-a5ad5808e4b4
# ╟─b6036a94-7e1f-40f4-a905-b9081fd25c8a
# ╠═66fe1bad-ae41-4e10-82ce-64b36d446049
# ╠═7956a61e-f1c1-44b6-9583-1df552051af6
# ╠═5a4eb37f-82db-40f3-be2d-0412e473ccb1
# ╠═b9d3cf7e-942b-4cb3-bda2-c932dcc314a4
# ╟─7c35704a-c6dc-429a-b28f-105764177636
# ╟─b16906ed-b4ab-446e-a0e8-d79418ef56ca
# ╟─e4a6e169-925f-490b-b03a-21f277ff0fa5
# ╟─b0d2fd84-3307-4a6d-af91-32cfdaa375f0
# ╟─ffe0fb93-50f4-4a1d-b73b-e24fb729d043
# ╠═00653f98-5a3c-4baa-a0b1-405905dd1e69
# ╠═dc5833d4-b9e6-4ac0-999e-5c86428f6b8a
# ╠═16f24a88-91f8-455c-b415-c33f27224fc0
# ╟─d29b41b0-f453-4c61-95ac-42695a07187a
# ╠═3fc7529c-e101-480b-87d6-85400bbebd03
# ╠═cc0f82bc-096c-444e-a078-37e91d019234
# ╟─3b210f36-33fb-4405-a9cf-9403d65cdce9
# ╟─db20720c-98d2-44b1-a9a3-8acc04ca55b9
# ╟─4778254b-f59f-4080-976b-44c6a8f68adc
# ╟─52a2d40f-069f-4e4b-9e3d-74d8f5c93632
# ╟─aed82abb-a91e-4ddc-91d3-9da1f5730459
# ╟─e8f7eb00-8e18-4b31-8e4a-493cf81acb92
# ╠═58646f88-df1a-488c-a951-1f942714ef5d
# ╟─00f6f985-8d07-4909-8e64-9db412ae816b
# ╠═4ae8ce86-13de-4c3d-9f9c-06460d907c23
# ╠═7a2e4158-cbff-429a-aaea-88a415f8ec3c
# ╟─f2fbd554-26fa-4f87-819f-0c7b14891764
# ╟─ec0f0925-e565-47fe-814a-cb6bf8caaee3
# ╠═2b5cd8bb-7df2-4e59-8956-26b1974d9f0f
# ╠═6a056c28-bb34-42dc-92c2-c100154685a4
# ╠═2bc35e57-a5d4-484e-9dd9-ccaa7566eaf7
# ╠═330a0efe-c14e-4153-bd95-8b1fd9c27e66
# ╠═88592d8b-6115-4258-bd3f-33e01101e8dc
# ╟─78dfd8bd-ba3e-47c8-878a-b735a0f5d787
# ╠═4c3f565a-9938-44e6-9105-f4a949774ea0
# ╠═fdc5a903-61c4-411f-8726-be012cbd8cfc
# ╟─424187c3-f6d3-4642-8d37-6266a2d9c597
# ╟─3ee12973-b0ad-409c-a451-bb765ad01cff
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
