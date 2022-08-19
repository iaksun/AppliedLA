### A Pluto.jl notebook ###
# v0.19.11

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

# ╔═╡ b5f2b6bf-899b-40f4-9d9f-20485f489870
using Images, TestImages, OffsetArrays

# ╔═╡ b5449b8e-3000-48dc-a788-1d357569a5a9
using QuartzImageIO # required to load a gif file

# ╔═╡ cab15114-3851-442c-8fb4-d03928dcb082
using DataFrames

# ╔═╡ 5504aec1-ecb0-41af-ba19-aaa583870875
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 337dc12b-49d1-4128-8459-33b04dd8ccce
# begin
# 	using Pkg
# 	Pkg.resolve()
# 	Pkg.update()
# end

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
md"""# Applied Linear Algebra for Everyone (Fall 2022)
**M. İrşadi Aksun**\
**Electrical and Electronics Engineering**\
**e-mail: iaksun@ku.edu.tr**

\

#### Recommended Materials:

#### 1. ``\;\;`` William Gilbert Strang from MIT, 
* **Lectures on _Linear Algebra_, all available on YouTube;**

* **book titled _Linear Algebra for Everyone_**

#### 2. ``\;\;`` Stephen P. Boyd from Stanford University, 

* **lectures on _Introduction to Applied Linear Algebra_ on YouTube;**

* **the course materials on the webpage:  https://stanford.edu/class/engr108;** 

* **textbook _Introduction to Applied Linear Algebra - Vectors, Matrices, and Least Squares_ available online.**

#### 3. ``\;\;`` Grant Sanderson from 3Blue1Brown, 

* **Linear Algebra lectures with exeptional visualizations on YouTube** 
---
"""

# ╔═╡ 4cdc2af4-872d-4672-87bb-330547d78bca
md"# Lecture - 2: Matrices

### Content 

> ##### 2.1. Brief review of matrices
>> ##### 2.1.1. Terminology
>> ##### 2.1.2. Matrices for linear equations

> ##### 2.2. Linear Equations
>> ##### 2.2.1. Linear & nonlinear equations
>> ##### 2.2.2. Solution by ellimination
>> ##### 2.2.3. No solution and many solutions
>> ##### 2.2.4. Unique solution

> ##### 2.3. Matrices in Julia
>> ##### 2.3.1. Creating matrices
>> ##### 2.3.2. Indexing
>> ##### 2.3.3. Slicing and submatrices
>> ##### 2.2.4. Special matrices

> ##### 2.4. Matrix operations
>> ##### 2.4.1. Matrix transpose
>> ##### 2.4.2. Matrix-Scalar multiplication
>> ##### 2.4.3. Matrix addition/subtraction
>> ##### 2.4.4. Matrix-vector multiplication
>> ##### 2.4.5. Matrix-Matrix multiplication
>> ##### 2.4.6. Determinant
>> ##### 2.4.7. Inverse

> ##### 2.5. A Few Applications
>> ##### 2.5.1. Markov processes

---
"

# ╔═╡ c393ee0a-5e50-4c00-ad52-ef5851f7d531
md"""# 2.1 Brief review of matrices

#### What is a matrix?

##### $\qquad \rightarrow$ Nothing to do with the movie of ``Matrix`` 😎 
##### $\qquad \rightarrow$ It is a rectangular formation of numbers 

\

#### Why do we need them?

##### $\qquad \rightarrow$ Remember your experience with the Microsoft Excel tables:
##### $\qquad \qquad -$ full of numbers with thousands of rows and columns, 
##### $\qquad \qquad -$ some simple manipulations can be performed easily:
##### $\qquad \qquad \qquad \bullet\;$  sorting a table
##### $\qquad \qquad \qquad \bullet\;$  summing up or averaging the numbers in a column
##### $\qquad \qquad \qquad \bullet\;$  simple manipulations on the numbers in the table

\

##### $\qquad \rightarrow$ Very difficult to implement more involved calculations 
##### $\qquad \qquad -$ The difficulty is in implementation and  efficiency


!!! matrix \" Matrix Format is used \"

	##### $\qquad -\;$ to store tables for easy manipulations
	##### $\qquad -\;$ to implement DS algorithms with ease and efficiency

---
"""

# ╔═╡ 044f12d3-35bf-4df0-9ef2-dde49db982f7
md"""

## 2.1.1. Terminology

#### A matrix is a rectangular array of numbers, as in

\

##### ${\bf A} = \begin{bmatrix} 1 & 0.1 & 3 & -2.5 \\ 2.5 & 1.5 & 0 & 1.7 \\ 3 & -4.2 & 1 & 3 \end{bmatrix} \qquad OR \qquad {\bf A} = \begin{pmatrix} 1 & 0.1 & 3 & -2.5 \\ 2.5 & 1.5 & 0 & 1.7 \\ 3 & -4.2 & 1 & 3 \end{pmatrix}$

##### $\qquad \rightarrow\;$ An important attribute of a matrix is its size or dimensions

##### $\qquad \rightarrow\;$ The matrix above has 3 rows and 4 columns, so its size is 3 × 4.


##### $\qquad \rightarrow\;$ $A_{ij}$ is the $(i,j)^{th}$ element of the matrix: $A_{23}=0$, $A_{32}=-4.2$ 


##### $\qquad \rightarrow\;$ A `square matrix` has equal number of rows and columns

##### $\qquad \rightarrow\;$ A `tall matrix` has more rows than columns (m × n, where m > n)
##### $\qquad \rightarrow\;$ A `wide matrix` has more columns than rows (m × n, where m < n).

---
"""

# ╔═╡ aa063ff2-1644-431e-b322-7135b4e9703f
md"""

## 2.1.2. Matrices for linear equations

#### In real life problems, we usually have 
##### $\qquad \rightarrow\;$ many unknowns (thousands, millions), and 
##### $\qquad \rightarrow\;$ generally more equations than unknowns


#### Therefore, they need to be cast into Matrix forms

##### $\qquad \rightarrow\;$ with $m$ rows and $n$ columns 
##### $\qquad \rightarrow\;$ to work on with comparative ease and computational efficiency

\

##### $\qquad \qquad \begin{bmatrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \vdots & \vdots & \cdots & \vdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{bmatrix} \begin{bmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = \begin{bmatrix} b_1 \\ b_2 \\ \vdots \\ b_m \end{bmatrix}$ 

\

##### $\qquad \qquad \qquad \qquad \qquad \bf A  x   =  b$

#### $\Rightarrow$ No one can solve such a huge system by hand, or even by computer if not come up with smart algorithms.  

#### $\Rightarrow$ Linear Algebra provides 
##### $\qquad \rightarrow$ tools to work with matrices and vectors
##### $\qquad \rightarrow$ smart algorithms for Big Data problems 

---
"""

# ╔═╡ 125b5322-fd07-4e4b-bb81-6b7c41e4c60e
md""" # 2.2. Linear Equations

##### $\color{red} \bf Linear \;equations \;lie \;at \;the \;heart \;of \;linear \;algebra$, and appear almost in every field.

\

##### Even as early as in junior high, we all have learned how to solve a few linear equations simulatanously.

##### Example:

>$x + 2 y = 3  \qquad \qquad   x_1 + 2 x_2 = 3$
>$4 x + 5 y = 6  \qquad \qquad    4 x_1 + 5 x_2 = 6$

##### $\qquad - \;\; x$ and $y$ are unknowns (or use $x_1, x_2$) 
##### $\qquad - \;\;$ individual equations are linear 


!!! notation
	##### $\qquad x_1$, $x_2$,...,$x_n$ are used for the sake of generality

##### The whole idea of Linear Equations and most part of Linear Algebra stem from the efforts of how to find 

##### $\qquad \color{red} \Rightarrow \bf \; a \;solution \;(or \;solutions) \;accurately \;and \;efficiently.$

---
"""

# ╔═╡ 54a9e4ab-f823-4e03-8083-f84ec2b8adba
md"""
##  2.2.1. Linear & nonlinear equations

>  $\bf \large Non \;Linear:$ $\large f_1(x_1, x_2) = 4 x_1 - 5 x_2 + 2 {\color{red} x_1 x_2} \qquad    g_1(x_1,x_2) = 20 {\color{red} \sqrt{x_1}} + 2 {\color{red} x_2^2} - 20$
>
>  $\bf \large Linear:$ $\large \; f_2(x_1, x_2) = 4 x_1 - 10 x_2 -10  \qquad \quad  g_2(x_1,x_2) = 10 x_1 + 5 x_2 + 5$
"""

# ╔═╡ c2a59e8e-bbe2-44c2-8922-6ac7ad4b942b
let
	x1=range(0,stop=5,length=100)
	x2=range(0,stop=5,length=100)
	#f(x,y) = x*y-x-y+1
	fnl(x1,x2) = 4x1 - 5x2 + 2 * x1 .* x2
	fl(x1,x2) = 4x1 - 10x2 .- 10
	gnl(x1,x2) = 20 * sqrt.(x1) + 2 * (x2.^2) .- 20
	gl(x1,x2) = 10x1 + 5x2 .+ 15
	fig1 = plot(x1,x2,fnl,st=:surface, xlabel = L"x_1", ylabel = L"x_2", zlabel = L"f(x_1,x_2)", color=cgrad(:jet), colorbar = false)
	plot!(x1,x2,fl,st=:surface, color=cgrad(:jet))
	fig2 = plot(x1,x2,gnl,st=:surface, color=cgrad(:jet), colorbar = false, xlabel = L"x_1", ylabel = L"x_2", zlabel = L"g(x_1,x_2)")
	plot!(x1,x2,gl,st=:surface, color=cgrad(:jet))
	plot(fig1,fig2, layout = (1,2))
end

# ╔═╡ 16c5d3e5-edbe-47cd-a5ab-b09ba4d27104
md"""## 2.2.2. Solution by ellimination

 $\large \qquad \quad \color{red} x_1 + 2 x_2 = 3 \qquad (1)$ $\;\;\qquad\large \color{blue} \qquad 4 x_1 + 5 x_2 = 6 \qquad (2)$

#### Ellimination: 
>  ##### $\color{red} 4 × (x_1 + 2 x_2 = 3) ⇒ 4 x_1 + 8 x_2 = 12 ⇒ 4 x_1 + 8 x_2 = 12$
>  ##### $\color{blue} 4 x_1 + 5 x_2 = 6\;\;\;\;\; ⇒ 4 x_1 + 5 x_2 = \;\;6 ⇒ \quad\;\;\;\; -3 x_2 = -6$

#### Back-substitution:
>  ##### $\color{red} 4 x_1 + 8 × 2 = 12 ⇒ x_1 = -1$
>  ##### $\color{blue} x_2 = -6/-3\;\;\; ⇒ x_2 = 2$

#### ⇒ The approach is know as _Gaussian ellimination_

"""

# ╔═╡ 8d0ad71b-34ca-407c-bd09-3fa191122c70
md"""# 
$\large \;\; \color{red} x_1 + 2 x_2 = 3 \qquad (1) \qquad\large \color{blue} \qquad 4 x_1 + 5 x_2 = 6 \qquad (2)$
"""

# ╔═╡ 2fdeb1e8-5811-4dcb-881a-5e857889f6ca
let # "Let ... end" allows the variables to be used only in the cell.
	#x =[-3:1:3;]; x = range(-3,3,7); x = collect(-3:1:3)
	x_1 = range(-3,3,7)
	x_21 = (3 .- x_1)/2;
	x_22 = (6 .- 4x_1)/5;
	plot(x_1, x_21, xlabel = L"x_1", label = L"x_1+ 2 x_2 =3", ylabel = L"x_2", frame = :origin, aspect_ratio = :equal, color = :red, l = 2)
	plot!(x_1, x_22, label = L"4x_1+5x_2=6", fg_legend = false, annotations = [(-1.3,1.7,Plots.text(L"^{(-1,2)}"))], color = :blue, l = 2)
	# `fg_legend = false` is to turn off the box around the legends
end

# ╔═╡ 9648cc3d-3e45-4dee-b245-1865b31f3c4c
md""" 
!!! julia
	**_range_** commend `range(-3.0, stop=3.0, length=7)` does not allocate but creates `start`, `stop` and `length`. `range` is refered to as ``lazy \;vector`` and used as `range(-3,3,7)` in this case.

	If needed to create an array according to the limits
	* `x =[-3:1:3;]` start=-3, step=1, stop=3, or
	* `x = collect(-3:1:3)` start=-3, step=1, stop=3
	can be used. Note the semicolon (`;`) in the first assignment, which refers to 	`vcat` (vertical concatenation) for the entries defined.

"""

# ╔═╡ 4fb5808d-c406-4586-98b2-42f1b2911bf8
range(-3,3,7)

# ╔═╡ d7cf6b88-4111-4f36-9cc9-ba4e7a4d7688
x_range = [-3:1:3]

# ╔═╡ 9205b10a-fcfb-4fa9-88d4-e7d4a8b3e5c3
collect(x_range)

# ╔═╡ 9a3f3a66-40f1-4eb3-ac3e-5c243a60642d
collect(range(-3,3,7))

# ╔═╡ 905e16f4-d98b-461c-8c91-c484f8529eb7
collect(-3.0:1.0:3.0)

# ╔═╡ 663d922d-7db3-4987-b68d-04e3b04dc436
md"""
---"""

# ╔═╡ 96f83cf6-2627-467e-95e7-f0f6a59a56c1
md"""## 2.2.3. No solution and many solutions

##### Original problem: Solve for $x_1$ and $x_2$

$\large x_1 + 2 x_2 = 3 \qquad \qquad \qquad 4 x_1 + 5 x_2 = 6$

##### Solution: $x_1=-1, x_2 = 2$
\

#### How do we have no solution or many solutions?

\

##### ⇒ Let us modify the second equation as follows:

$\large {\color{blue} x_1 + 2 x_2 = 3} \qquad \qquad \qquad {\color{red} x_1 + 2 x_2 = 3}$
$\large {\color{blue} 2 x_1 + 4 x_2 = 1} \qquad \qquad \qquad {\color{red} 2 x_1 + 4 x_2 = 6}$

##### What do you notice?

"""

# ╔═╡ 2dbbf1c4-991f-49f6-a72a-d08f3dcdf62f
html"""
<details>
    <summary> <b><big> 1. Left-hand sides ...</b></summary>	
    <br> 
    <p><b>  give the same information, so what? </b></p>
</details>
"""


# ╔═╡ 6e1ce086-658f-42bf-8dac-e7979a45247e
html"""
<details>
    <summary> <b><big> 2. Right-hand sides on the blue equations ...</summary>
	<br>
    <p><b> are not consistent. What does it mean? </b></p>
</details>
"""

# ╔═╡ c2d02cb9-970d-4474-9f82-25a6a941ebfe
html"""
<details>
    <summary><b><big> 3. Right-hand sides on the red equations ...</summary>
	<br>
    <p><b> are consistent. What does it mean? </b></p>
</details>
"""

# ╔═╡ 2adaf391-6411-4151-b386-5c5c9fa8f905
md"""#
##### Plot the equations
"""

# ╔═╡ ac643e46-3174-4ad3-b838-19b8769c86ae
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

# ╔═╡ c42dda51-2081-4e14-914e-490c21f736e6
md""" 
##### $\bullet \;{\color{blue} blue \;equations}$ give conflicting information
##### $\qquad {\color{blue} inconsistent, \;no \;solution}$ 
##### $\bullet \;{\color{red} red \;equations}$ give same information
##### $\qquad {\color{red} consistent, \;infinitely \;many \;solutions}$

---
"""

# ╔═╡ dcdb8afd-56c9-4a1d-84b1-536db820fe7a
md"""#
##### What happens after the ellimination step

${\color{blue} x_1 + 2 x_2 = 3} \qquad \qquad  {\color{red} x_1 + 2 x_2 = 3}$
${\color{blue} 2 x_1 + 4 x_2 = 1} \qquad \qquad  {\color{red} 2 x_1 + 4 x_2 = 6}$
$\Downarrow \qquad \qquad \qquad \qquad \Downarrow$

${\color{blue} x_1 + 2 x_2 = 3} \qquad \qquad  {\color{red} x_1 + 2 x_2 = 3}$
${\color{blue} 0 + 0 = -5} \qquad \qquad  {\color{red} 0 + 0 = 0}$

##### After ellimination,

##### ⇒ inconsistent equations result in contradiction,


##### ⇒ consistent but dependent equations result in $0 = 0.

---
"""

# ╔═╡ 3c8304eb-af5c-4bd9-a9e6-3af7196698a8
md"""## 2.2.4. Unique Solution

#### For uniqeness,

##### $\qquad \bullet$ the number of equations $\color{red} \bf =$ the number of unknowns


##### $\qquad \bullet$ equations must be $\color{red} \bf independent$

#### Example:

"""

# ╔═╡ 290c1af6-fa87-4a56-8322-b299e2ea4cd4
TwoColumn(
	md""" 

$\large x_1 - 2 x_2 + x_3 =0$ 
$\large \qquad 2 x_2 - 8 x_3 = 8$ 
$\large 5 x_1 \qquad -5 x_3 = 10$
""",
	md""" #####  Matrix representation ($\bf A x = b$)
\
 $\large \begin{bmatrix} 1 & -2 & 1 \\  0 & 2 & -8 \\ 5 & 0 & -5 \end{bmatrix} 
\begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = \begin{bmatrix} 0 \\ 8 \\ 10 \end{bmatrix}$ 

 $\large \Rightarrow \bf x = A^{-1} b$
"""		
)

# ╔═╡ fff0fef2-b182-4ff0-8191-022971fd4be3
md"""
##### ⇒ Apply ellimination and back substitution:
\
 $\large x_1 - 2 x_2 + x_3 =0 \qquad \qquad \;\; x_1 - 2 x_2 + x_3 =0 \qquad \qquad x_1 = 1$ 
 $\large \qquad 2 x_2 - 8 x_3 = 8  \qquad \qquad 0 x_1 + 2 x_2 -8 x_3 = 8 \qquad \qquad x_2 = 0 \color{red} \Uparrow_{(2)}$ 
 $\large 5 x_1 \qquad -5 x_3 = 10  \quad \qquad \;\;0 x_1 + 0 x_2 + x_3 = -1 \quad \qquad x_3 = -1 \color{red} \Uparrow_{(1)}$

"""

# ╔═╡ dc6984d0-ed8a-4f77-a8df-7c9ebc20dc00
md"""
##### ⇒ Use Julia:
"""

# ╔═╡ 76913eb1-31d1-459d-a13a-7dc1ae183b59
x_unique = let
	A = [1 -2 1; 0 2 -8; 5 0 -5] # Matrix A
	b = [0, 8, 10] # Column vector b
	A\b # Solution for the unknown vector x
#	x_32 = inv(A_33) * b_3 # Solution with inverse of A
end

# ╔═╡ b0dca955-16c4-4cd3-8090-02d577624ab6
md"
---"

# ╔═╡ c72c74f8-d5e5-4ebb-a0e5-384fc00a13e6
md"# 2.3. Matrices in Julia

## 2.3.1. Creating matrices from the entries
"

# ╔═╡ ae6fbc53-26d9-4980-b755-9d2278badfc3
A_34 = [0.0 1.0 -2.3 0.1;
1.3 4.0 -0.1 0.0;
4.1 -1.0 0.0 1.7];

# ╔═╡ a9873638-7338-414e-8f30-054ba220114d
A2_34 = [0.0 1.0 -2.3 0.1; 1.3 4.0 -0.1 0.0; 4.1 -1.0 0.0 1.7];

# ╔═╡ 2b9984b3-b38e-498b-9a05-3df4f56c525e
size(A_34) # Gives the dimension as a tuple; size(A_34,1) = 3

# ╔═╡ 356a6388-9778-4892-97ce-77ebff7429eb
A_77 = rand((0:4), 7, 7)

# ╔═╡ cc0a9986-b370-4243-9611-4dd21e246c6a
A_77[:,2]

# ╔═╡ 8c39de20-0c8e-4d02-bcf6-b8f89dd83a8f
md"""#
## 2.3.2. Indexing entries
##### $\qquad -\;$ Access the $(i,j)^{th}$ entry of a matrix A ⇒ A[i,j] 
##### $\qquad -\;$ Assign a new value to any entry ⇒ A[i,j] = "_value_"
##### $\qquad -\;$ Access an entry of a matrix using only one index:
##### $\qquad \qquad \circ\;$ matrices in Julia are stored in _column-major_ order,
##### $\qquad \qquad \circ\;$ a matrix can be considered as a one dimensional array, 
##### $\qquad \qquad \circ\;$ the $1^{st}$ column stacked on top of the $2^{nd}$, and so on. 
##### $\qquad \qquad \circ\;$ this is not standard mathematical notation.
"""

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
## 2.3.3. Slicing and Submatrices

##### $\qquad -\;$ Using column notation you can extract a submatrix
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
reshape(B,(2,3)); # The Julia function reshape(B,(k,l)) gives a new k × l matrix, with the entries taken in the column-major order from B(m,n). Must have mn = kl,

# ╔═╡ e10b126b-17ee-4f93-aaeb-a5f1a1b34cb1
reshape(A,(2,6));

# ╔═╡ 4f0deacb-cd05-4786-aec1-4f6bc635b787
rand(2,3); # rand(m,n) generates an mxn matrix of random numbers between -1 and 1

# ╔═╡ b49cf4b8-f690-4768-b27d-0104b0619317
rand((-3:3),2,3); #rand((k:step:l), m,n) generates an mxn matrix of random numbers between -k and l with step size 'step' (the default step size is 1)

# ╔═╡ d0f9a0c9-f58d-48fe-81b0-539c14134969
md"""#

## 2.3.4. Special Matrices

##### $\;\; -\;\;$ Zero matrix ($\bf 0$): A matrix with all entries are zero


##### $\;\; -\;\;$ Ones matrix ($\bf 1$): A matrix with all entries are ones


##### $\;\; -\;\;$ Identity matrix ($\bf I$): A matrix with diagonal entries 1, others 0


##### $\;\; -\;\;$ Diagonal matrix: A matrix with only diagonal entries


##### $\;\; -\;\;$ Triangular matrix:
##### $\qquad \circ \;$ Upper triangular: Entries in lower triangle are zero
##### $\qquad \circ \;$ Lower triangular: Entries in upper triangle are zero
"""

# ╔═╡ 1d01ecdd-6bed-46e7-acbe-684d9806fd40
zeros(2,3)

# ╔═╡ 421dea52-181f-453b-818d-2407f66a1f0b
ones(4,4)

# ╔═╡ a83552bd-f6bf-47f2-827b-8b17676c9e24
I(4) # Identity matrix

# ╔═╡ 63ac2822-a157-4090-a165-849c15f1217d
a_diag = rand((1:4),4) # rand(1,4) or rand(4,1) won't work as they generate matrices

# ╔═╡ 88b473fe-b7bf-4111-a30a-02a8d9c9e32c
Diagonal(a_diag) # diagonal matrix

# ╔═╡ 51d948b7-1b9d-449d-b885-c1235e0b3097
diagm(a_diag) # diagonal full matrix

# ╔═╡ 9f0c9b8f-301e-4d9f-b305-8a6ea39e84fd
LowerTriangular(ones(4,4))

# ╔═╡ fc73f681-c70b-41bd-af89-722ad033d55a
UpperTriangular(rand(3,3
))

# ╔═╡ 5c8b26f6-a5c3-4e15-a671-27d2b9b26205
 A_uptr = [1.0 2.0 3.0; 4.0 5.0 6.0; 7.0 8.0 9.0]

# ╔═╡ 3d2bd49e-aef4-4795-8ea5-b5975d011087
UpperTriangular(A_uptr)

# ╔═╡ d31061b4-93a9-4e35-90d2-2977c70e8d05
UnitLowerTriangular(A_uptr)

# ╔═╡ 115539ad-8b9c-4b38-8b23-b8064164ddc2
UnitUpperTriangular(A_uptr)

# ╔═╡ f3838d6f-0b17-48fe-b90a-0053f7ce74dc
md"""# 2.4. Matrix Operations

!!! note \"Matrix notations\"
	##### During this course, 
	##### $\qquad -\;$ bold capital letters like ${\bf A, B, X, Y,} ...$ are used for matrices
	##### $\qquad -\;$ bold small letters like ${\bf a, b, x, y,} ...$ are used for vectors
	##### $\qquad -\;$ small letters like $a, b, x, y, ...$ are used for real constants
	

#### $\bullet\;\;$ To work with matrices and arrays, one needs to know 
##### $\qquad \rightarrow$ the basic operations: add/subtract, multiply/divide, 
##### $\qquad \rightarrow$ some other operations that are useful in matrices.

\

#### $\bullet\;\;$ Here are the list of operations in matrix algebra:
##### $\qquad -$ scalar multiplication: $a \bf A$, $\alpha \bf x$, $c ({\bf x + y})$, $\beta ({\bf A + B})$, ...
##### $\qquad -$  addition, subtraction: $\bf A ± B$, $\bf x ± y$, ...
##### $\qquad -$  matrix-vector multiplication: $\bf A x$, $\bf y B$, ...
##### $\qquad -$ matrix-matrix multiplication $\bf A B$, $\bf B Y$, ...
##### $\qquad -$ determinant: $det({\bf A}) ≡ |{\bf A}|$, $|{\bf X}|$, ... $\color{red} \Leftarrow Square\;matrices$
##### $\qquad -$ transpose: ${\bf A}^T$, ${\bf x}^T$, ...
##### $\qquad -$ inverse: ${\bf A}^{-1}$, ${\bf X}^{-1}$, ... $\color{red} \Leftarrow Square\;matrices,\;\; det(A) \ne 0$

---
"""

# ╔═╡ ad2961bc-cf04-4206-a86f-1307416a3fe2
md"""
## 2.4.1. Matrix transpose


#### $\bullet\;\;$If $\bf A$ is an m × n matrix, its transpose ${\bf A}^T$ is the n × m matrix:

##### $\qquad \qquad \qquad \qquad ({\bf A}^T )_{ij} = {\bf A}_{ji}$ 

#### $\;\;\;$ For example,

##### $\;\;{\bf A} = \begin{bmatrix} a & b \\ c & d \end{bmatrix} \Rightarrow {\bf A}^T = \begin{bmatrix} a & c \\ b & d \end{bmatrix};\qquad {\bf Z} = \begin{bmatrix} a & b \\ c & d \\ e & f \end{bmatrix} \Rightarrow \bf Z' = \begin{bmatrix} a & c & e \\ b & d & f \end{bmatrix}$

\

##### $\qquad {\bf x} = \begin{bmatrix} a \\ b \\ c \end{bmatrix} \Rightarrow \bf x' = \begin{bmatrix} a & b & c \end{bmatrix}; \qquad {\bf y} = \begin{bmatrix} α & β & γ \end{bmatrix} \Rightarrow {\bf y'} = \begin{bmatrix} α \\ β \\ γ \end{bmatrix}$

\

#### $\bullet\;\;$ Transposing a matrix twice results in the original matrix.
"""

# ╔═╡ dc5e390f-ece4-4e27-9b25-023a731cc633
A_exT = rand(-3:3, 3,2)

# ╔═╡ eec8c31c-5324-44a4-8e55-3fed81d9dbd8
A_exT'# Transposing a matrix twice results in the original matrix

# ╔═╡ ba787e69-7f86-4f41-87f5-b20d9e8831c6
md"

## 2.4.2. Matrix-Scalar multiplication

#### Given a matrix $\bf A$ and a scalar $c$,

##### $\qquad \qquad c \begin{bmatrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \vdots & \vdots & \cdots & \vdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{bmatrix} = \begin{bmatrix} ca_{11} & ca_{12} & \cdots & ca_{1n} \\ ca_{21} & ca_{22} & \cdots & ca_{2n} \\ \vdots & \vdots & \cdots & \vdots \\ ca_{m1} & ca_{m2} & \cdots & ca_{mn} \end{bmatrix}$

\

!!! julia
	```math
	c {\bf A} = [c*{\bf A}[i,j] \;for \;i \;in \;1:m, \;j \;in \;1:n]
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

# ╔═╡ f130d717-bedc-4ebd-bba5-3908d54c07bc
md"""

## 2.4.3. Matrix addition/subtraction

#### $\bullet\;\;$ Two matrices of the same size can be added/subtracted


#### $\bullet\;\;$ The result is obtained by adding/subtracting the corresponding elements 

\

##### $\qquad \qquad {\bf A} = \begin{bmatrix} a_{11} & a_{12} \\ a_{21} & a_{22} \end{bmatrix};\qquad {\bf B} = \begin{bmatrix} b_{11} & b_{12} \\ b_{21} & b_{22} \end{bmatrix}$

\

##### $\qquad \qquad {\bf A} \pm {\bf B} = \begin{bmatrix} a_{11} \pm b_{11} & a_{12} \pm b_{12} \\ a_{21} \pm b_{21} & a_{22} \pm b_{22} \end{bmatrix}$

"""

# ╔═╡ 4fd22565-7443-4f10-baf3-a2881651a2be
A_exA = rand(-3:3, 3,2)

# ╔═╡ 556f68f3-481b-4660-b5bd-f1a643676ee2
B_exA = rand(-3:3, 3,2)

# ╔═╡ 05c341eb-3db3-42bd-ae08-05f8aa370cb7
A_exA + B_exA

# ╔═╡ d17f883e-0e3f-419d-a45d-0fdde93d280b
md"""
---"""

# ╔═╡ 2cf6c3c0-0406-49d8-b53b-56983d290188
md"""
## 2.4.4. Matrix-vector multiplication

>Here is a nice overview of **_Matrix-vector Multiplication_** by 3-Blue-1-Brown (Grant Sanderson) for your reference. I strongly recommend you to watch it and try to understand the intuitive picture of the concept rather than the mathematical details.

"""

# ╔═╡ 55fdee4a-3860-4a88-9790-bcfba7ee35fb
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/kYB8IZa5AuE" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 28d718bd-610a-4257-91dc-7148e3fe45df
md"""
!!! condition
	##### $\bullet \;$ For a given ($m,\color{red}n$) matrix $\bf A$, $\bf x$ must be a column vector of (${\color{red}n},1$)
	##### $\bullet \;$ Number of columns of $\bf A\;\; \equiv\;\; $ Number of elements of $\bf x$

---
"""

# ╔═╡ 2d3abfe1-8cda-49f8-b5b1-b8b602626d92
md"#
### Example: Rotation matrix 

\

``` math 
	\large {\bf R}_\theta = \begin{bmatrix} cos\theta & -sin\theta \\
 									 sin\theta & cos\theta \end{bmatrix}
```
\

#### rotates each point in the plane counterclockwise by angle $\theta$
"

# ╔═╡ 0f41e163-f847-4f57-9968-9a06f47aacd6
begin
	img_rot = load("Picture1.png")
	imresize(img_rot, size(img_rot).*2)
end

# ╔═╡ 346bba70-2209-4d07-8c02-63a74e8c622d
md"
##### Show that it actually rotates x- and y-axis counterclockwise by angle $\theta$

##### Can you write x-axis as ${\bf x}=[1, 0]$ and y-axis as ${\bf y}=[0, 1]$?
"

# ╔═╡ 5ed395e8-20c8-4e34-8a15-7d51b1d9949a
θ° = (@bind θ° Slider(0:5:360, show_value=true, default=30))

# ╔═╡ e022e5e5-186b-48f8-bd7d-4be9dc6610ab
begin
θ = θ° * π / 180 # change degree to radian
x₀ = [1, 0] # x axis
y₀ = [0, 1] # y axis
A_rot = [cos(θ) -sin(θ);
		sin(θ) cos(θ)]  # rotation matrix
x_rot = A_rot * x₀
y_rot = A_rot * y₀
	x_vals = [0 0 0 0; x₀[1] y₀[1] x_rot[1] y_rot[1] ]
	y_vals = [0 0 0 0; x₀[2] y₀[2] x_rot[2] y_rot[2] ]
# There are 4 vectors and all start at (0,0) -> 4 zeros for x, 4 zeros for y
# Each (0,0) connects to the other end of the vector. That is, first (0,0) -> (x₀[1],x₀[2]), second (0,0) -> (y₀[1], y₀[2]), ..
# After importing LaTeXStrings package, L stands for Latex in the following expressions
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

### 1. Multiplication by Rows

!!! julia 
	```math
	\large {\bf A x} =  [{\bf A}[i,:]' * {\bf x} \;for \;i \;in \;1:m]\;\;\; \leftarrow Row-Column \;Multiplication
	```

```math
\large \begin{bmatrix} {\color{green} a_{11}} & {\color{green} a_{12}} & {\color{green} \cdots} & {\color{green} a_{1n}} \\ {\color{blue} a_{21}} & {\color{blue} a_{22}} & {\color{blue} \cdots} & {\color{blue} a_{2n}} \\ \vdots & \vdots & \cdots & \vdots \\ {\color{red} a_{m1}} & {\color{red} a_{m2}} & {\color{red} \cdots} & {\color{red} a_{mn}} \end{bmatrix} \begin{bmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = \begin{bmatrix} {\color{green} a_{11} x_1 + a_{12} x_2 + \cdots + a_{1n} x_n} \\ {\color{blue} a_{21} x_1 + a_{22} x_2 + \cdots + a_{2n} x_n} \\ \vdots \\ {\color{red} a_{m1} x_1 + a_{m2} x_2 + \cdots + a_{mn} x_n} \end{bmatrix}
```
"""

# ╔═╡ c7f02d62-d81c-4cf0-860c-79ea6b5fd7ab
A2=rand((-2:2),2,3) # let us remember 

# ╔═╡ 7f367404-7275-4e35-9242-ebec5ac0668d
A2[1,:]; # Even though we choose a row, Julia still stores it as a column vector

# ╔═╡ 28ec3f99-0741-478d-b5e0-94b0baefd56c
x = rand((-2:2),size(A2,2)); # size(A2,2) gives the number of columns of A2

# ╔═╡ 444147d7-b570-4685-b1b9-cbab58f0bd7b
A2x_1 = [A2[i,:]' * x for i in 1:size(A2,1)]; # "'" is the transpose of A2[i,:], and size(A2,1) gives the number of rows of A2

# ╔═╡ 4e2ca663-4fa4-4d33-96b4-bc495c911871
A2 * x; # Notice that just writing A * x gives the right result, provided the two can be multiplied (number of columns of A = number of rows of x) 

# ╔═╡ 55f8c2bb-de75-46b6-9bbb-ef8bf7248af9
md"""
---"""

# ╔═╡ e36cbcee-5092-4d91-ad44-be63b695ce60
md"""#

### 2. Multiplication by Columns

!!! julia
	```math
	\large {\bf A x} =  sum({\bf A}[:,j]*{\bf x}[j] \rm \;\;\;for \;j \;in \;1:n)
	```

```math
\large \begin{bmatrix} {\color{green} a_{11}} & {\color{blue} a_{12}} & \cdots & {\color{red} a_{1n}} \\ {\color{green} a_{21}} & {\color{blue} a_{22}} & \cdots & {\color{red} a_{2n}} \\ {\color{green} \vdots} & {\color{blue} \vdots} & \cdots & {\color{red} \vdots} \\ {\color{green} a_{m1}} & {\color{blue} a_{m2}} & \cdots & {\color{red} a_{mn}} \end{bmatrix} \begin{bmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{bmatrix} = 
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
#### Solve 
 $\large \;\;x_1 - 2 x_2 + \;x_3 =1$ \
 $\large 2 x_1 - 4 x_2 + 2 x_3 = 2$ \
 $\large 5 x_1 \qquad \;\;\, -5 x_3 = 5$ 
 
 #### OR 
\
 $\large \;\;x_1 - 2 x_2 + \;x_3 =2$ \
 $\large 2 x_1 - 4 x_2 + 2 x_3 = 4$ \
 $\large 5 x_1 \qquad \;\;\, -5 x_3 = 0$ \
""",
	md"""
 #### In matrix form: 
  $\large \begin{bmatrix} 1 & -2 & 1 \\  2 & -4 & 2 \\ 5 & 0 & -5 \end{bmatrix} 
  \begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = \begin{bmatrix} 1 \\ 2 \\ 5 
  \end{bmatrix} \rightarrow \begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = ?$ 

#### OR 
\
 $\large \begin{bmatrix} 1 & -2 & 1 \\  2 & -4 & 2 \\ 5 & 0 & -5 \end{bmatrix} 
\begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = \begin{bmatrix} 2 \\ 4 \\ 0 \end{bmatrix} \rightarrow \begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} = ?$ 
"""		
)

# ╔═╡ 715b31c5-6c13-428a-8595-f8f661ba87ac
md"""
---"""

# ╔═╡ 1668cb38-6078-4a7f-8ade-96f6d42280b6
md"""
## 2.4.5. Matrix-Matrix multiplication



!!! condition
	 ##### $\bullet \;$ Number of columns in $\bf A \; \equiv \;\;$ Number of rows in $\bf B$
	 ##### $\bullet \;$ For given ($m,\color{red}n$) matrix $\bf A$ and (${\color{red}n},k$) matrix $\bf B$ 
	 ##### $\qquad \qquad \bf A B$ will be of ($m,k$) dimension

\

#### $\bullet \;\;$ Consider the columns of ${\bf B}$ as the vectors:
#### $\qquad \qquad \qquad {\bf B} = [b_1 \; b_2 \; \cdots \; b_k]$

\

#### $\qquad \qquad \qquad {\bf A B} =  [{\bf A} b_1 \; {\bf A} b_2 \; \cdots \; {\bf A} b_k]$ 


##### $\qquad \qquad \begin{bmatrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \vdots & \vdots & \cdots & \vdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{bmatrix} \begin{bmatrix} b_{11} & b_{12} & \cdots & b_{1k} \\ b_{21} & b_{22} & \cdots & b_{2k} \\ \vdots & \vdots & \cdots & \vdots \\ b_{n1} & b_{n2} & \cdots & b_{nk} \end{bmatrix}$

\

##### $\qquad \qquad {\bf AB}[i,j] = \; (i-th \;row \;of \;{\bf A}) \cdot \; (j-th \;column \;of \;{\bf B})$ 	
!!! julia
	```math
	\large {\bf A*B} = [ A[i,:] ⋅ B[:,j] \;\;for \;i \;in \;(1:m), \;j \;in \;(1:k)] 
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

# ╔═╡ b6005ec2-c856-4cfb-9de1-fd0d65b957a1
md"""
---"""

# ╔═╡ 75e91ef3-8893-48fc-a297-e54aa6b6c671
md"""

## 2.4.6. Determinant of a Matrix

>Here is a nice overview of **_Determinant_** by 3-Blue-1-Brown (Grant Sanderson) for your reference. I strongly recommend you to lisen to it and try to understand the intuitive picture of the concept rather than the mathematical details.

"""

# ╔═╡ 1de74de8-36c5-467f-a749-4cefd0b2acdc
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/Ip3X9LOh2dk" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 877ef381-df6c-4a5b-bf99-88f8afba0995
md"""#
### Properties
##### 1.  $\;det \;{\bf I}$ = $1$
##### 2. if two rows are interchanged, the determinant changes sign.
##### 3. If a row is multiplied by a number, the determinant is multiplied by the same number.
##### 4. Two equal rows => $det = 0$.
##### 5. if a multiple of a row is added to another row, the determinant does not change.
##### 6. Row of zeros leads to zero determinant.
##### 7. Determinant of upper triangular matrix:
##### $\qquad det \begin{bmatrix} d_1 & * & \cdots & * \\ 0 & d_2 & \cdots & * \\ \vdots & \vdots & \cdots & \vdots \\ 0 & 0 & \cdots & d_n \end{bmatrix} = d_1 d_2 \cdots d_n$

##### 9.  $\;det \;{\bf A} = 0\;$ when $\bf A$ is singular
##### 10.  $\;det \;{\bf A} = det \;{\bf A}^𝑇$ → (All the properties are also valid for the columns)
##### 12.  $\;det \;{\bf A\;B} = (det \;{\bf A}) (\;det \;{\bf B})$
##### $\qquad \rightarrow  \;det (\;{\bf A\;A}^{-1})=det \;{\bf I} \Rightarrow det \;{\bf A}^{-1}=1/det \;{\bf A}$
##### $\qquad \rightarrow  \;det \;{\bf A}^2 = (det \;{\bf A})^2$
##### 13. $\;$ It is easy to calculate the determinant for $2 \times 2$ matrices,
##### $\qquad \qquad {\bf A} = \begin{bmatrix} a & b \\ c & d \end{bmatrix} \Rightarrow det({\bf A}) = {ad - bc}$

---
"""

# ╔═╡ 3a8ef338-38a4-4954-862c-6ce50e80f2fe
md"""

## 2.4.7. Inverse of a Matrix

##### $- \;$ is needed in places of a divide for algebraic equations;
##### $\qquad \qquad \rightarrow 5 a = 15 \Rightarrow a = 5^{-1} \times 15 = 15 / 5 = 3$
##### $\qquad \qquad \rightarrow {\bf A x = b} \Rightarrow {\bf x} = {\bf A}^{-1} {\bf b}$

##### $- \;$ is denoted by ${\bf A}^{-1}$;


##### $- \;$ is defined only for square matrices, that is, $n \times n$ matrices;


##### $- \;$ is defined only for non-singular matrices ($det(\bf A) \ne 0$);


##### $- \;$ results in an identity matrix when multiplied by itself,
##### $\qquad \qquad {\bf A}{\bf A}^{-1} = {\bf A}^{-1}{\bf A} = {\bf I};$

##### $- \;$ is easy to find for $2 \times 2$ matrices,
##### $\qquad {\bf A} = \begin{bmatrix} a & b \\ c & d \end{bmatrix} \Rightarrow {\bf A}^{-1} = \frac{1}{ad - bc} \begin{bmatrix} d & -b \\ -c & a \end{bmatrix}.$
---
"""

# ╔═╡ 2d036e2e-6850-46d8-bbb5-21856403ecc8
md"""# 2.5. A Few Applications
\
`` \bullet \Large \bf  \;\; Markov \;\; Process``

`` 	\qquad - \large PageRank``

``  \qquad - \large Covid-19 \;\; Survival \;\; Analysis ``

\

`` \bullet \Large \bf \;\;Compression \;\;(Image, \;Data, \;etc.) ``

`` \qquad - \large A \;sample \;image \;and \;compression \;via \;SVD ``

\

 `` \bullet \Large \bf \;\;Regression ``

 `` \qquad - \large Linear \;and \;non-linear ``

---
"""

# ╔═╡ 7ad20af1-a7d6-4092-b982-fad27d6e51ea
md"## 2.5.1. Markov Processes 

### Example 1: Page Rank[^1] 
##### Birth of Google's PageRank algorithm:

###### Lawrence Page, Sergey Brin, Rajeev Motwani and Terry Winograd published [“The PageRank Citation Ranking: Bringing Order to the Web”](http://ilpubs.stanford.edu:8090/422/), in 1998, and it has been the bedrock of the now famous PageRank algorithm at the origin of Google. 

\

###### From a theoretical point of view, the PageRank algorithm relies on the simple but fundamental mathematical notion of **_Markov chains_**.

\

###### PageRank is a function that assigns a real number to each page in the Web that the higher the number, the more **important** it is.
[^1]: _Introduction to Markov chains: 
	Definitions, properties and PageRank example_, Joseph Rocca, Published in _Towards Data Science_ in Feb 25, 2019.
"

# ╔═╡ ba3404b3-956e-4ca8-93aa-070897bdaa9a
begin
	pgrank = load("PageRank-hi-res.png");
	pgrank[1:10:size(pgrank)[1],1:10:size(pgrank)[2]]
end

# ╔═╡ 55bbc51f-86ef-41ab-824c-0d5fe4241181
md"""
---"""

# ╔═╡ 2633b604-7476-48d0-8cdc-05645ea0ed57
md"#
### - Form the Markov matrix
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

# ╔═╡ 23a409b4-4299-4c12-a55a-adc438def7ea
md"""
---"""

# ╔═╡ a3611641-256e-49e8-9e2e-c78b9efc21ce
md"""#
### - Define initial state

##### $\bullet \;\;$ Define an inital state: suppose surfer starts at Page-1, 
##### $\qquad \qquad {\bf x_0}=[1 \; 0 \; 0 \; 0 \; 0 \; 0 \; 0]'$
##### $\bullet \;\;$ Next state $\bf x_1 = M x_0$ is given as 

##### $\qquad \qquad {\bf x_1} = \begin{bmatrix} \cdot & \cdot & \cdot & 0.5 & 1.0 & \cdot & 0.5 \\ 0.25 & \cdot & 0.5 & \cdot & \cdot & \cdot & \cdot \\ \cdot & 0.5 & \cdot & \cdot & \cdot & \cdot & \cdot \\ \cdot & 0.5 & 0.5 & \cdot & \cdot & \cdot & 0.5 \\ 0.25 & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\ 0.25 & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\ 0.25 & \cdot & \cdot & 0.5 & \cdot & 1.0 & \cdot \end{bmatrix} \begin{bmatrix} 1 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix} = \begin{bmatrix} \cdot \\ 0.25 \\ \cdot \\ \cdot \\ 0.25 \\ 0.25 \\ 0.25 \end{bmatrix}$
\

"""

# ╔═╡ 541a573c-2e87-49dc-97e7-778a50364e52
state0 = [1, 0, 0, 0, 0, 0, 0] # [1/7, 1/7, 1/7, 1/7, 1/7, 1/7, 1/7] 

# ╔═╡ dd6f459f-898f-4370-9cc8-35e410a76cc7
state = zeros(7,50); # Initialize the state matrix

# ╔═╡ f6e62718-42b7-4e0b-b9ab-60fbf3bfa4a6
state[:,1] = M * state0

# ╔═╡ abf983de-2f8b-42d8-b3ef-54d0eb5f0cde
md"""
---"""

# ╔═╡ 7516b6a6-1f70-4bab-a320-ae16b028e6be
md"""#
### - Find the following states
##### $\qquad \qquad {\bf x_2 = M x_1} → {\bf x_3 = M x_2} → \cdots → {\bf x_n = M x_{n-1}}$

##### OR

##### $\qquad \qquad {\bf x_n = M^n x_0}$

"""

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
md"""#
### - Properties of Markov Matrix
#### $\bullet \;\;$ What do you notice from the above computations?
##### $\qquad \circ\;\;$ States converge;  
##### $\qquad \qquad -\;\;$ How can we measure the distance between each state, `norm`?  
 ##### $\qquad \qquad -\;\;$ Steady-state distribution depends on the initial state? NO  
##### $\qquad \qquad -\;\;$ Is $\bf M^n x_n = x_n$ correct? What is your conclusion from this?
  
 ##### $\qquad \qquad -\;\;$ All numbers in each state sum up to '$1$'. True or False?

#### $\bullet \;\;$ How do you interpret the end state after 30 transitions?

##### $\qquad \qquad {\bf x_{30}} = \begin{bmatrix} 0.29 & 0.095 & 0.047 & 0.19 & 0.07 & 0.07 & 0.238 \end{bmatrix}'$

"""

# ╔═╡ 20e0521b-1943-4eef-85b2-e46d6fc1d9c0
bar([i for i in 1:7], state[:,30], legend = false, xlabel ="Pages", ylabel= "PageRank values", size = (600, 350))

# ╔═╡ a10cae47-2b16-421f-9f1c-cdd8a6eda5ad
md"""#
### - Convergence study (norms)

##### $\bullet \;\;$ Norm is the length of a vector ${\bf v}$ and represented by $\| {\bf v} \|$
##### $\bullet \;\;$ There are different norm definitions
##### $\qquad - \;\;$ ``L_1`` norm =  $\| {\bf v} \|_1 = |v_1| + |v_2| + \cdots + |v_n|$ 
##### $\qquad - \;\;$ ``L_2`` norm (≡ Euclidian norm) = $\| {\bf v} \|_2 = \sqrt{v_1^2 + v_2^2 + \cdots + v_n^2}$ 
##### $\qquad - \;\;$ ``L_{\infty}`` norm (≡ Max norm) = $\| {\bf v} \|_\infty  = Max[{|v_1|, |v_2|, \cdots, |v_n|}]$

!!! norm
	##### Throughout this course, mostly Euclidian Norm will be used and subscript '2' will be droped in $\| {\bf v} \|$.
"""

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

# ╔═╡ 2780a6fa-fc19-40be-93d1-8b092045a071
md"""
---"""

# ╔═╡ 9a987b58-47e9-4191-8fb7-9225d27d2628
md"#
### - Role of Initial State
##### In Markov matrices, there are few properties that we need to state for the sake of understanding its potential and problems: For Markov Matrices,
##### $\bullet \;\;$ the sum of each column must be '1'; $\rightarrow [1 \;1 \cdots 1]\; {\bf M} =[1 \;1 \cdots 1]$   
##### $\bullet \;\;$ if entries postive, called positive Markov matrices,
##### $\qquad - \;\;$ they always converge to a unique steady-state;
##### $\bullet \;\;$ if not, that is, if there are zero entries, then
##### $\qquad - \;\;$ it may still converge to a single steady-state or converge to more 
##### $\qquad \;\;\;\;$ than one steady-states dependent on the initial state $x_0$; 
##### $\bullet \;\;$ iterations maintain the sum of the entries of the initial guess, that is
##### $\qquad Sum({\bf x}_1) = [1 \;1 \cdots 1]\; {\bf x}_1 = \underbrace{[1 \;1 \cdots 1]\; {\bf M}}_{\color{red} [1 \;1 \cdots \; 1]} \;{\bf x}_0 = [1 \;1 \cdots 1]\; {\bf x_0} = Sum({\bf x}_0)$
"

# ╔═╡ 54cbf7b1-95d0-4027-b65f-a5ad5808e4b4
let
	state0 =[0, 0, 1, 1, 1, 0, 0]
	state30 = M^30 * state0
	nstate30 = state30 / sum(state30)
	bar([i for i in 1:7], nstate30, legend = false, xlabel ="Pages", ylabel= "PageRank values", title = "30 iterations; Initial state = $(state0[:,1])")
end

# ╔═╡ 81d40d17-e770-408a-8987-0ab17f40293d
begin
	nst_i = zeros(7,30)
	st_0 =rand(0:1:1, 7)
	nst_i[:,1] = round.(st_0/ sum(st_0); digits=2)# Float16.(st_0/ sum(st_0)) # normalized initial state
	for i = 2:30
		nst_i[:,i] = (M^(i-1) * nst_i[:,i-1])
	end	
	# barplt = bar([1:7], nstate30, legend = false, xlabel ="Pages", ylabel= "PageRank values")
	
	anim_states = @animate for i in 1:10
	plot!(bar([1:7], nst_i[:,i], legend = false, xlabel ="Pages", ylabel= "PageRank values"), title = "$(i-1); Initial state = $(nst_i[:,1])")
	end
	
end

# ╔═╡ f2c5a261-af9f-4f4a-b854-1dc36bd7ea44
gif(anim_states, "anim_states.gif", fps = 0.5)

# ╔═╡ b6036a94-7e1f-40f4-a905-b9081fd25c8a
md"""#
#### Is $\bf M^n x_n = x_n$ ?   What is your conclusion?

##### $\bullet \;\;$ Do you remember ${\bf A x}=\lambda {\bf x}$ ? `Eigenvalues` and `Eigenvectors`
\

##### $\bullet \;\;$ $\bf M^n x_n = x_n$ implies that Markov matrix $\bf M$ has an eigenvalue at $\lambda = 1$ with its eigenvector $\bf x_n$
\

##### $\bullet \;\;$ So, finding the eigenvector of $\bf M$ corresponding to eigenvalue $\lambda = 1$ will directly give the steady-state:
"""

# ╔═╡ 66fe1bad-ae41-4e10-82ce-64b36d446049
# lambda = eigvals(M) # Eigenvalues of M

# ╔═╡ 7956a61e-f1c1-44b6-9583-1df552051af6
# eigv = eigvecs(M) # Eigenvectors of M in the order of eigenvalues

# ╔═╡ 5a4eb37f-82db-40f3-be2d-0412e473ccb1
# n_eigenvector = eigv[:,7] / sum(eigv[:,7]) # need to mormalize to the sum of the vector.

# ╔═╡ b9d3cf7e-942b-4cb3-bda2-c932dcc314a4
# norm((eigv[:,7] / sum(eigv[:,7]) - state[:,30]),Inf) # see the distance (norm) between the eigenvector for lambda =1 and the state we have reached after 30 iterations

# ╔═╡ 725d0c60-a3fa-49ee-9c14-4b950f8b7d53
md"""
---"""

# ╔═╡ 7c35704a-c6dc-429a-b28f-105764177636
md"""
!!! note \"Project Idea - 1\"
	Review the PageRank algorithm of Google and find a way to promote your web page.
"""

# ╔═╡ b16906ed-b4ab-446e-a0e8-d79418ef56ca
md"""#
### Example 2: Covid-19 Survival Analysis[^2]

##### The problem was formulated under two infection scenarios:

##### $1. \;\;$ 5% as suggested by CDC (Centers for Desease Control) and 
##### $2. \;\;$ 10% for aggressive case 

##### with three states as `Non infected`, `Infected` and `Hospitalized` with the following probabilities in Markov matrices:
\

##### $\qquad {\bf M_1^{CDC}} = \begin{bmatrix} 0.95 & 0.10 & 0.00 \\ 0.05 & 0.70 & 0.30 \\ 0.00 & 0.20 & 0.70  \end{bmatrix} \qquad {\bf M_2^{Agg}} = \begin{bmatrix} 0.90 & 0.12 & 0.00 \\ 0.10 & 0.70 & 0.20 \\ 0.00 & 0.18 & 0.80  \end{bmatrix}$


##### where 
##### $\bullet \;\;$ $1^{st}$ column represents `Non infected` and their transitions to others;
##### $\bullet \;\;$ $2^{nd}$ column is for `Infected` and their transitions to others;
##### $\bullet \;\;$ $3^{rd}$ column is for `Hospitalized` and their transitions to other states.

!!! warning \"The goal of this study is to assess\"
	##### $\bullet \;\;$ the long-run percentages of cases in each of the states, 
	##### $\bullet \;\;$ the rates at which these states populated 

[^2]: [_A Markov Chain Model for Covid-19 Survival Analysis_] (https://web.cortland.edu/matresearch/MarkovChainCovid2020.pdf), Jorge Luis Romeu, July 17, 2020.
"""

# ╔═╡ e4a6e169-925f-490b-b03a-21f277ff0fa5
M_covCDC = [0.95 0.10 0.0 ;
	0.05 0.70 0.30
	0.0 0.20 0.70]

# ╔═╡ b0d2fd84-3307-4a6d-af91-32cfdaa375f0
M_covAgg = [0.90 0.12 0.0 ;
	0.10 0.70 0.20
	0.0 0.18 0.80]

# ╔═╡ b0a3be42-6aec-4c7d-8798-d62a23aeb01a
md"""
---"""

# ╔═╡ ffe0fb93-50f4-4a1d-b73b-e24fb729d043
md"""# 
### ★ Eigenvalue - Eigenvector analysis
!!! note
	##### $\;\; - \;\;$ Largest eigenvalue of the Markov matrix is expected to be '$1$' 
	##### $\;\; - \;\;$ its corresponding eigenvector is the steady state

"""

# ╔═╡ 00653f98-5a3c-4baa-a0b1-405905dd1e69
# λ_CDC, v_CDC = eigen(M_covCDC) # just to give you an example of a variable name in greek letter

# ╔═╡ dc5833d4-b9e6-4ac0-999e-5c86428f6b8a
# lambda_covCDC, eigv_covCDC = eigen(M_covCDC)

# ╔═╡ 16f24a88-91f8-455c-b415-c33f27224fc0
# lambda_covAgg, eigv_covAgg = eigen(M_covAgg)

# ╔═╡ d29b41b0-f453-4c61-95ac-42695a07187a
md"""
#### $\quad \bullet \;\;$ As expected, $\lambda_{max} = 1.0$ and corresponding eigenvectors
##### $\qquad \;\;\; \rightarrow \;\; [-0.86, -0.43, -0.286]\;$ for the CDC case 
##### $\qquad \;\;\; \rightarrow \;\; [0.67, 0.55, 0.50]\;$ for the Aggressive case.

\

#### $\quad \bullet \;\;$ Eigenvectors represent the probabilities, so 
#### $\quad \quad$ they need to be normalized to make the sum of their 
#### $\quad \quad$ entries unity 
"""

# ╔═╡ 3fc7529c-e101-480b-87d6-85400bbebd03
# ss_covidCDC = eigv_covCDC[:,3]/ sum(eigv_covCDC[:,3])

# ╔═╡ cc0f82bc-096c-444e-a078-37e91d019234
# ss_covidAgg = eigv_covAgg[:,3]/ sum(eigv_covAgg[:,3])

# ╔═╡ b2d01760-61a1-41b4-99dd-c719c1c6f679
md"""
---"""

# ╔═╡ 77868858-900b-43a5-8172-49832c339534
md"""#
#### $\qquad \qquad \qquad$ Steady state distributions"""

# ╔═╡ 3b210f36-33fb-4405-a9cf-9403d65cdce9
TwoColumn(
	md"""
#### CDC scenario (5%)

##### $\bullet \;\;$ 54.5% `Non infected`
##### $\bullet \;\;$ 27.3% `Infected`
##### $\bullet \;\;$ $\color{red} 18.2\% \;\;Hospitalized$
""",
	md""" ####  Aggressive Scenario (10%)

##### $\bullet \;\;$ 38.7% `Non infected`
##### $\bullet \;\;$ 32.2% `Infected`
##### $\bullet \;\;$ $\color{red} 29.0\% \;\;Hospitalized$
"""		
)

# ╔═╡ c6ca304b-81ab-48c6-93d7-738336e5adbe
md"""
\

#### _The steady-state distribution_ represents 
##### $\qquad -\;$ the long-run percent of cases in each states
##### $\qquad -\;$ the rates at which the Markov Chain enters the states
##### $\qquad \qquad \circ\;$ the average time between two successive visit to a state 
##### $\qquad \quad \quad \;\;$ = 1/ (long-run percent)
"""

# ╔═╡ 66eff877-5530-4da7-8062-68b70d545e37
md"""
---"""

# ╔═╡ c2069db6-5737-4fb9-8d85-564cffb48357
df_covid = DataFrame(Infection_Rates = ["Efficient (5%)", "Efficient (5%)", "Inefficient (10%)", "Inefficient (10%)"], 
    Long_run = ["Probabilities", "Times Between", "Probabilities", "Times Between"],
    Not_Infected = [0.545, 1.834, 0.387, 2.583],
    Infected_Home = [0.273, 3.667, 0.322, 3.099],
	Hospitalized = [0.182, 5.50, 0.290, 3.444])

# ╔═╡ c48af5a0-9595-4af1-aaa0-21c38720654b
md"""
#### Observations
##### $\bf \qquad 1.\;$ For 10% infection rates, higher percent of patients hospitalized,
##### $\qquad \qquad \qquad \qquad$ 29% vs. 18.2%
##### ⇒ infection rate increase results in saturating the Health Care system
##### $\bf \qquad 2.\;$ For 5% infection rates, times between two successive visits
##### $\qquad \quad$ to the Hospital are longer: 5.5 days vs. 3.4 days

---
"""

# ╔═╡ db20720c-98d2-44b1-a9a3-8acc04ca55b9
md"""#
### - More Realistic scenario

#### Define the probabilities over five states:
##### $\qquad \circ \;$ General population → 93% remain uninfected, 7% infected
##### $\qquad \circ \;$ infected (isolated at home) → 5% recovered, 80% remain isolated, 
##### $\qquad \quad$ 10% hopitalized, 5% in ICU
##### $\qquad \circ \;$ hospitalized (after becoming ill) → 15% recovered and sent for  
##### $\qquad \quad$ isolation, 80% remain hospitalized, 5% in ICU
##### $\qquad \circ \;$ in the ICU (or ventilators) → 5% recovered and stayed in hospital, 
##### $\qquad \quad$ 80% remain in ICU, 15% dead
##### $\qquad \circ \;$ dead (absorbing state)

---
"""

# ╔═╡ 62748722-ba68-4bb9-9d87-8d08158e56dd
md"""

#### Based on the data avilable, set up the Markov matrix as
\

```math
\large {\bf M} = \begin{bmatrix} {\color{green} 0.93} & {\color{blue} 0.05} & {\color{orange} \cdot} & {\color{red} \cdot} & \cdot \\ 
						  {\color{green} 0.07} & {\color{blue} 0.80} & {\color{orange} 0.15} & {\color{red} \cdot} & \cdot \\ 
						 {\color{green} \cdot} & {\color{blue} 0.10} & {\color{orange} 0.80} & {\color{red} 0.05}  & \cdot \\ 
	   					 {\color{green} \cdot} & {\color{blue} 0.05} & {\color{orange} 0.05} & {\color{red} 0.80}  & \cdot \\ 
		  				 {\color{green} \cdot} & {\color{blue} \cdot} & {\color{orange} \cdot} & {\color{red} 0.15} & 1.0  \end{bmatrix}  \Leftarrow {\bf Markov \; \; Matrix}
```
#### where 
##### $\qquad \bullet\;\;$  $\color{green} green$ column is for $\color{green} non-infected$
##### $\qquad \bullet\;\;$   $\color{blue} blue$ column is for $\color{blue} infected$
##### $\qquad \bullet\;\;$   $\color{orange} orange$ column is for $\color{orange} hospitalized$
##### $\qquad \bullet\;\;$   $\color{red} red$ column is for $\color{red} ICU$
##### $\qquad \bullet\;\;$   $\color{black} black$ column is for $\color{black} dead$

!!! warning \"Goal\"
	##### _Probability of Death_ and _Expected Time to Death_
---
"""

# ╔═╡ 4778254b-f59f-4080-976b-44c6a8f68adc
md"""#
#### For the Markov model
##### $\qquad -\;$ the unit time is a day, transitions are from morning to the next
##### $\qquad -\;$ every transition is an independent trial 
##### $\qquad -\;$ the data are closer to the cases in Italy or NYC

!!! danger \"Absorbing State\"
	##### $\;\; -\;$ The last column (dead state) has a single entry with propability '1'
	##### $\;\; -\;$ It is the final state, _no return_
"""

# ╔═╡ 52a2d40f-069f-4e4b-9e3d-74d8f5c93632
M_cov = [0.93 0.05 0.0 0.0 0.0;
	0.07 0.80 0.15 0.0 0.0
	0.0 0.10 0.80 0.05 0.0
	0.0 0.05 0.05 0.80 0.0
	0.0 0.0 0.0 0.15 1.0]

# ╔═╡ aed82abb-a91e-4ddc-91d3-9da1f5730459
md"""

##### What happens to $\bf x_n = M^n x_0$? 
##### Where does $\bf M^n$ converges to for $n→∞$?

---
"""

# ╔═╡ e8f7eb00-8e18-4b31-8e4a-493cf81acb92
md"""#
$\Large {\bf Brute \;force \;calculation}$
"""

# ╔═╡ 58646f88-df1a-488c-a951-1f942714ef5d
M_cov^500 # all columns converge to [0, 0, 0, 0, 1]

# ╔═╡ 00f6f985-8d07-4909-8e64-9db412ae816b
md"

$\Large {\bf Eigenvalue \;and \;eigenvector \;calculation}$

"

# ╔═╡ 4ae8ce86-13de-4c3d-9f9c-06460d907c23
lambda_cov, eigv_cov = eigen(M_cov)

# ╔═╡ 7a2e4158-cbff-429a-aaea-88a415f8ec3c
eigv_cov[:,5] # corresponds to lambda=1, so steady-state seems to be when everyone is dead?

# ╔═╡ f2fbd554-26fa-4f87-819f-0c7b14891764
md""" 
$\Large {\bf In \;steady \;state, \;it \;converges \;to \;the \;aborbing \;state}$

!!! danger 
	#### Everybody will be dead 🤔

---
"""

# ╔═╡ ec0f0925-e565-47fe-814a-cb6bf8caaee3
md"""#

## ★ Working with absorbing states

#### This is a brief overview for curious minds (not included) [^3]

##### Transition matrix for a Markov chain with $k$ absorbing states
\

```math
\large {\bf M} = \begin{bmatrix} {\bf T} & {\bf 0}_{k \times l} \\ 
						  {\bf R} & {\bf I}_l  \end{bmatrix} 
```
##### where 
##### $\; - \; \bf T$ is a $k \times k$ matrix with transition probabilities from one transient state to another
##### $\; - \; \bf R$ is an $l \times k$ matrix with transition probabilities from a transient state to an absorbing state
##### $\; - \; {\bf 0}_{k×l}$ is an $k × l$ matrix of all $0$’s, as moving from an absorbing state to a transient state is impossible.
##### $\; - \; {\bf I}_l$ is an $l×l$ identity matrix, as transitioning between absorbing states is impossible.

!!! note
	##### One can always cast the Markov matrix in a similar block form, by intechanging the order of columns and rows.
 

[^3][Absorbing Markov Chains] (https://www.math.umd.edu/~immortal/MATH401/book/ch_absorbing_markov_chains.pdf), Allan Yashinski, July 21, 2021

---
"""

# ╔═╡ bc7d0dc1-251d-4d0b-9813-f4a0fd311a18
md"""#
##### → $M^2$, $M^3$, ..., $M^n$ need to be calculated as the system transions 
```math
\large {\bf M}^2 = \begin{bmatrix} {\bf T} & {\bf 0}_{k \times l} \\ 
						  {\bf R} & {\bf I}_l  \end{bmatrix} 
		  \begin{bmatrix} {\bf T} & {\bf 0}_{k \times l} \\ 
						  {\bf R} & {\bf I}_l  \end{bmatrix} = 
		  \begin{bmatrix} {\bf T}^2 & {\bf 0}_{k \times l} \\ 
						  {\bf RT}+{\bf R} & {\bf I}_l  \end{bmatrix}
```
\

```math
\large {\bf M}^3 = \begin{bmatrix} {\bf T} & {\bf 0}_{k \times l} \\ 
						  {\bf R} & {\bf I}_l  \end{bmatrix} 
		 \begin{bmatrix} {\bf T}^2 & {\bf 0}_{k \times l} \\ 
						 {\bf RT}+{\bf R} & {\bf I}_l  \end{bmatrix} = 
		  \begin{bmatrix} {\bf T}^3 & {\bf 0}_{k \times l} \\ 
						  {\bf RT}^2+{\bf RT}+{\bf R} & {\bf I}_l  \end{bmatrix}
```
$\large \vdots$
```math
\large {\bf M^n} = \begin{bmatrix} {\bf T}^n & {\bf 0}_{k \times l} \\ 
						  {\bf R}+{\bf RT}+\cdots+{\bf RT}^{n-1} & {\bf I}_l  \end{bmatrix} =
		  \begin{bmatrix} {\bf T}^n & {\bf 0}_{k \times l} \\ 
						  {\bf R} \sum_{i=0}^{n-1}{\bf T}^i & {\bf I}_l  \end{bmatrix}
```

\


 $\large {\rm For} \;\;n → ∞ \;\;\;\; \sum_{i=0}^{n-1}{\bf T}^i → ({\bf I-T})^{-1}$, 
##### provided the column sums of $\bf T$ are less than $1$.
\

#### Let us try it on the covid data: 
"""

# ╔═╡ 2b5cd8bb-7df2-4e59-8956-26b1974d9f0f
T = M_cov[1:4,1:4] # Block T (4 x 4), only the transient porton of M

# ╔═╡ 6a056c28-bb34-42dc-92c2-c100154685a4
R = M_cov[5,1:4] # Block R (1 x 4), from transient to absorbing state

# ╔═╡ 2bc35e57-a5d4-484e-9dd9-ccaa7566eaf7
ones(4)' * T # to check if the column sums are less than 1 => NOT

# ╔═╡ 330a0efe-c14e-4153-bd95-8b1fd9c27e66
ones(4)' * T^5 # However, higher powers of T satisfy this criterion, which would be enough for the approximation

# ╔═╡ 88592d8b-6115-4258-bd3f-33e01101e8dc
lambda_T = eigvals(T) # eigvals and eigvecs give e-values and e-vectors separately

# ╔═╡ 18a1ec88-f203-46df-9d1d-50a6f10d4275
md"""
---"""

# ╔═╡ 78dfd8bd-ba3e-47c8-878a-b735a0f5d787
md"""#
#### Therefore, the Markov matrix at steady-state
\

```math
\large \lim_{n→∞}{\bf M^n} = \lim_{n→∞} \begin{bmatrix} {\bf T}^n & {\bf 0}_{k \times l} \\ 
						  {\bf R} \sum_{i=0}^{n-1}{\bf T}^i & {\bf I}_l  \end{bmatrix} \Rightarrow
				{\bf M^{ss}} = \begin{bmatrix} {\bf 0}_{k \times k} & {\bf 0}_{k \times l} \\ 
						  {\bf R} ({\bf I-T})^{-1} & {\bf I}_l  \end{bmatrix}
```
\

##### → only surviving block is the one showing the transition probabilities 
##### $\;\;\;$ from transient states to absorbing states: $\qquad {\bf R} ({\bf I-T})^{-1}$

##### $\qquad -\;\; \bf R$: probabilities from transient states to absorbing states
##### $\qquad -\;\;$ Define $\color{red} {\bf F = (I-T)}^{-1} → \rm \bf Fundamental \;Matrix$
##### $\qquad -\;\;$ $\color{red} (i, j)^{th} \rm \bf \;entry \;of \;F\;$ is the expected number of times the chain 
##### $\qquad \quad \;\;$ is in state $j$, given that the chain started in state $i$.
##### $\qquad -\;\;$ The expected number of steps before being absorbed 
##### $\qquad \qquad \qquad \qquad {\bf N} = [{\bf 1}^T {\bf F}] = [N_1 \;\;.\;.\;.\;\; N_i \;\;.\;.\;.\;\; N_{l-k}]$
##### $\qquad \quad \;\;$ where $N_i$ is the number of steps starting in transient state $i$ 

"""

# ╔═╡ 4c3f565a-9938-44e6-9105-f4a949774ea0
F = (I(4) - T)^-1 # or inv(I(4)-T) Fundamental Matrix

# ╔═╡ fdc5a903-61c4-411f-8726-be012cbd8cfc
R' * F # as expected, in steady-state, it goes to the absorbing state

# ╔═╡ f95d08df-20e4-42d4-9afb-8872b33ad1e6
ones(size(F,1))' * F

# ╔═╡ 897fbfd2-8282-42b3-93d1-f2d2303f621b
md"""
---"""

# ╔═╡ 424187c3-f6d3-4642-8d37-6266a2d9c597
md"""#

##### ${\bf F = (I-T)}^{-1}$ → Average number of days in transient states

```math
\large {\bf F} = ({\bf I-T})^{-1} = \begin{bmatrix} 26.19 & 11.90 & 9.52 & 2.38 \\ 
						 16.67 & 16.67 & 13.33 & 3.33 \\ 
	   					 10.0 & 10.0 & 13.3 & 3.33 \\ 
		  				 6.67 & 6.67 & 6.67 & 6.67 \end{bmatrix} 
```

#### Interpretation
##### The average number of days a _non infected_ person ($1^{st}$ column)
##### $\qquad -\;$ stays _non infected_ is 26.19 days;
##### $\qquad -\;$ spends _infected (isolated)_, after being infected, is 16.67 days;
##### $\qquad -\;$ spends in _hospital_ is 10.0 days
##### $\qquad -\;$ spends in _ICU_, before passing away, is 6.67 days.

\

##### ⇒ Average number of days it takes for a non infected person to pass away
$\large 26.19 + 16.66 + 10.00 + 6.66 = 59.52 \; \rm days$

"""

# ╔═╡ 53e5a89f-304a-436c-bb64-a60d429994d0
M_cov^2 # Probability of dyiing in 2 days for Healthy is 0.0, for infected is 0.0075, for Hospitalized is 0.0075, for ICU is 0.27

# ╔═╡ fa32b2ed-8c24-4b32-ad1e-41044b797533
M_cov^8 # Probability of dyiing in 8 days for Healthy is 0.018, for infected is 0.118, for Hospitalized is 0.127, for ICU is 0.636

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
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
OffsetArrays = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
QuartzImageIO = "dca85d43-d64c-5e67-8c65-017450d5d020"
TestImages = "5e47fb64-e119-507b-a336-dd2b206d9990"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
DataFrames = "~1.3.4"
FileIO = "~1.13.0"
HypertextLiteral = "~0.9.3"
ImageIO = "~0.6.1"
ImageShow = "~0.3.3"
Images = "~0.25.2"
LaTeXStrings = "~1.3.0"
OffsetArrays = "~1.12.7"
Plots = "~1.31.6"
PlutoUI = "~0.7.34"
QuartzImageIO = "~0.7.4"
TestImages = "~1.7.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "af22e4ad53cb4d7bdfed68be490d0638a0a6bd67"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "1dd4d9f5beebac0c03446918741b1a03dc5e5788"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.6"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "80ca332f6dcb2508adba68f22f551adb2d00a624"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.3"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "75479b7df4167267d75294d14b58244695beb2ac"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "9be8be1d8a6f44b96482c8af52238ea7987da3e3"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.45.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "daa21eb85147f72e41f6352a57fccea377e310a9"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.4"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

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

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

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

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.Extents]]
git-tree-sha1 = "5e1e4c53fa39afe63a7d356e30452249365fba99"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.1"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "ccd479984c7838684b3ac204b716c89955c76623"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+0"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "90630efff0894f8142308e334473eba54c433549"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.5.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

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

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "037a1ca47e8a5989cc07d19729567bb71bfabd0c"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.66.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "c8ab731c9127cd931c93221f65d6a1008dad7256"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.66.0+0"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "fb28b5dc239d0174d7297310ef7b84a11804dfab"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.0.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "a7a97895780dab1085a97769316aa348830dc991"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.3"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78e2c69783c9753a91cdae88a8d432be85a2ab5e"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "db5c7e27c0d46fd824d470a3c32a4fc6c935fa96"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.7.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "f0956f8d42a92816d2bf062f8a6a6a0ad7f9b937"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.2.1"

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
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageContrastAdjustment]]
deps = ["ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "0d75cafa80cf22026cea21a8e6cf965295003edc"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.10"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "b1798a4a6b9aafb530f8f0c4a7b2eb5501e2f2a3"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.16"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "15bd05c1c0d5dbb32a9a3d7e0ad2d50dd6167189"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.1"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "d9a03ffc2f6650bd4c831b285637929d99a4efb5"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.5"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f025b79883f361fa1bd80ad132773161d231fd9f"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.12+2"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

[[deps.ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "e7c68ab3df4a75511ba33fc5d8d9098007b579a8"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.2"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "Statistics"]
git-tree-sha1 = "0c703732335a75e683aec7fdfc6d5d1ebd7c596f"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.3"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "36832067ea220818d105d718527d6ed02385bf22"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.7.0"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "8717482f4a2108c9358e5c3ca903d3a6113badc9"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.5"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "03d1301b7ec885b266c0f816f338368c6c0b81bd"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.2"

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
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "23e651bbb8d00e9971015d0dd306b780edbdb6b9"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.3"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "57af5939800bce15980bddd2426912c4f83012d8"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.1"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

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

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "81b9477b49402b47fbe7f7ae0b252077f53e4a08"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.22"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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
git-tree-sha1 = "1a43be956d433b5d0321197150c2f94e16c0aaa0"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.16"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

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

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

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
git-tree-sha1 = "361c2b088575b07946508f135ac556751240091c"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.17"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "e595b205efd49508358f7dc670a940c790204629"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.0.0+0"

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
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "d9ab10da9de748859a7780338e1d6566993d1f25"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "2af69ff3c024d13bde52b34a2a7d6887d4e7b438"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.1"

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
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "0e353ed734b1747fc20cd4cba0edd9ac027eff6a"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.11"

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
git-tree-sha1 = "1ea784113a6aa054c5ebd95945fa5e52c2f378e7"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.7"

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
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

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
git-tree-sha1 = "e925a64b8585aa9f4e3047b8d2cdc3f0e79fd4e4"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.16"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

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
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "9888e59493658e476d3073f1ce24348bdc086660"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "79830c17fe30f234931767238c584b3a75b3329d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.31.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

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

[[deps.Quaternions]]
deps = ["DualNumbers", "LinearAlgebra", "Random"]
git-tree-sha1 = "b327e4db3f2202a4efafe7569fcbe409106a1f75"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.5.6"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "e7eac76a958f8664f2718508435d058168c7953d"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.3"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "22c5201127d7b243b9ee1de3b43c408879dff60f"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.3.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "3177100077c68060d63dd71aec209373c3ec339b"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

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

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "a6f404cc44d3d3b28c793ec0eb59af709d827e4e"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.2.1"

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
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "23368a3313d12a2326ad0035f0db0c0966f438ef"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "66fe9eb253f910fe8cf161953880cfdaef01cdf0"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.0.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StringDistances]]
deps = ["Distances", "StatsAPI"]
git-tree-sha1 = "ceeef74797d961aee825aabf71446d6aba898acb"
uuid = "88034a9c-02f8-509d-84a9-84ec65e18404"
version = "0.11.2"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "ec47fb6069c57f1cee2f67541bf8f23415146de7"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.11"

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
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

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

[[deps.TestImages]]
deps = ["AxisArrays", "ColorTypes", "FileIO", "ImageIO", "ImageMagick", "OffsetArrays", "Pkg", "StringDistances"]
git-tree-sha1 = "3cbfd92ae1688129914450ff962acfc9ced42520"
uuid = "5e47fb64-e119-507b-a336-dd2b206d9990"
version = "1.7.0"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

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
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

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
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

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
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

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
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╠═5504aec1-ecb0-41af-ba19-aaa583870875
# ╠═337dc12b-49d1-4128-8459-33b04dd8ccce
# ╠═cb5b4180-7e05-11ec-3b82-cd8631fc57ba
# ╠═98ddb325-2d12-44b5-90b6-61e7eb55bd68
# ╟─1c5063ab-e965-4c3b-a0d9-7cf2b272ad48
# ╠═b1eefcd2-3d91-42e5-91e8-edc2ed3a5aa8
# ╟─a9c98903-3f39-4d69-84cb-2e41f8cca9ac
# ╠═4cdc2af4-872d-4672-87bb-330547d78bca
# ╟─c393ee0a-5e50-4c00-ad52-ef5851f7d531
# ╟─044f12d3-35bf-4df0-9ef2-dde49db982f7
# ╟─aa063ff2-1644-431e-b322-7135b4e9703f
# ╟─125b5322-fd07-4e4b-bb81-6b7c41e4c60e
# ╟─54a9e4ab-f823-4e03-8083-f84ec2b8adba
# ╟─c2a59e8e-bbe2-44c2-8922-6ac7ad4b942b
# ╟─16c5d3e5-edbe-47cd-a5ab-b09ba4d27104
# ╟─8d0ad71b-34ca-407c-bd09-3fa191122c70
# ╟─2fdeb1e8-5811-4dcb-881a-5e857889f6ca
# ╟─9648cc3d-3e45-4dee-b245-1865b31f3c4c
# ╠═4fb5808d-c406-4586-98b2-42f1b2911bf8
# ╠═d7cf6b88-4111-4f36-9cc9-ba4e7a4d7688
# ╠═9205b10a-fcfb-4fa9-88d4-e7d4a8b3e5c3
# ╠═9a3f3a66-40f1-4eb3-ac3e-5c243a60642d
# ╠═905e16f4-d98b-461c-8c91-c484f8529eb7
# ╟─663d922d-7db3-4987-b68d-04e3b04dc436
# ╟─96f83cf6-2627-467e-95e7-f0f6a59a56c1
# ╟─2dbbf1c4-991f-49f6-a72a-d08f3dcdf62f
# ╟─6e1ce086-658f-42bf-8dac-e7979a45247e
# ╟─c2d02cb9-970d-4474-9f82-25a6a941ebfe
# ╟─2adaf391-6411-4151-b386-5c5c9fa8f905
# ╟─ac643e46-3174-4ad3-b838-19b8769c86ae
# ╟─c42dda51-2081-4e14-914e-490c21f736e6
# ╟─dcdb8afd-56c9-4a1d-84b1-536db820fe7a
# ╟─3c8304eb-af5c-4bd9-a9e6-3af7196698a8
# ╟─290c1af6-fa87-4a56-8322-b299e2ea4cd4
# ╟─fff0fef2-b182-4ff0-8191-022971fd4be3
# ╟─dc6984d0-ed8a-4f77-a8df-7c9ebc20dc00
# ╟─76913eb1-31d1-459d-a13a-7dc1ae183b59
# ╟─b0dca955-16c4-4cd3-8090-02d577624ab6
# ╠═c72c74f8-d5e5-4ebb-a0e5-384fc00a13e6
# ╠═ae6fbc53-26d9-4980-b755-9d2278badfc3
# ╠═a9873638-7338-414e-8f30-054ba220114d
# ╠═2b9984b3-b38e-498b-9a05-3df4f56c525e
# ╠═356a6388-9778-4892-97ce-77ebff7429eb
# ╠═cc0a9986-b370-4243-9611-4dd21e246c6a
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
# ╟─d0f9a0c9-f58d-48fe-81b0-539c14134969
# ╠═1d01ecdd-6bed-46e7-acbe-684d9806fd40
# ╠═421dea52-181f-453b-818d-2407f66a1f0b
# ╠═a83552bd-f6bf-47f2-827b-8b17676c9e24
# ╠═63ac2822-a157-4090-a165-849c15f1217d
# ╠═88b473fe-b7bf-4111-a30a-02a8d9c9e32c
# ╠═51d948b7-1b9d-449d-b885-c1235e0b3097
# ╠═9f0c9b8f-301e-4d9f-b305-8a6ea39e84fd
# ╠═fc73f681-c70b-41bd-af89-722ad033d55a
# ╠═5c8b26f6-a5c3-4e15-a671-27d2b9b26205
# ╠═3d2bd49e-aef4-4795-8ea5-b5975d011087
# ╠═d31061b4-93a9-4e35-90d2-2977c70e8d05
# ╠═115539ad-8b9c-4b38-8b23-b8064164ddc2
# ╟─f3838d6f-0b17-48fe-b90a-0053f7ce74dc
# ╟─ad2961bc-cf04-4206-a86f-1307416a3fe2
# ╠═dc5e390f-ece4-4e27-9b25-023a731cc633
# ╠═eec8c31c-5324-44a4-8e55-3fed81d9dbd8
# ╟─ba787e69-7f86-4f41-87f5-b20d9e8831c6
# ╠═144114a0-20f1-4fee-8d7b-331274442bfb
# ╠═8ead573c-e4a3-41e7-9d5e-8494f53ca6e4
# ╠═2efcc362-ebb1-41d7-a899-7854efa215ca
# ╠═f190b01d-9268-4c44-ae01-cc17f927704e
# ╠═45ced395-a8a2-465b-9552-186806b0e6e1
# ╟─f130d717-bedc-4ebd-bba5-3908d54c07bc
# ╠═4fd22565-7443-4f10-baf3-a2881651a2be
# ╠═556f68f3-481b-4660-b5bd-f1a643676ee2
# ╠═05c341eb-3db3-42bd-ae08-05f8aa370cb7
# ╟─d17f883e-0e3f-419d-a45d-0fdde93d280b
# ╟─2cf6c3c0-0406-49d8-b53b-56983d290188
# ╟─55fdee4a-3860-4a88-9790-bcfba7ee35fb
# ╟─28d718bd-610a-4257-91dc-7148e3fe45df
# ╟─2d3abfe1-8cda-49f8-b5b1-b8b602626d92
# ╟─b5f2b6bf-899b-40f4-9d9f-20485f489870
# ╟─0f41e163-f847-4f57-9968-9a06f47aacd6
# ╟─346bba70-2209-4d07-8c02-63a74e8c622d
# ╠═5ed395e8-20c8-4e34-8a15-7d51b1d9949a
# ╟─e022e5e5-186b-48f8-bd7d-4be9dc6610ab
# ╟─a55816f3-1c24-4e6f-b35f-2aba8f8e8194
# ╠═c7f02d62-d81c-4cf0-860c-79ea6b5fd7ab
# ╠═7f367404-7275-4e35-9242-ebec5ac0668d
# ╠═28ec3f99-0741-478d-b5e0-94b0baefd56c
# ╠═444147d7-b570-4685-b1b9-cbab58f0bd7b
# ╠═4e2ca663-4fa4-4d33-96b4-bc495c911871
# ╟─55f8c2bb-de75-46b6-9bbb-ef8bf7248af9
# ╟─e36cbcee-5092-4d91-ad44-be63b695ce60
# ╠═612e0950-320c-4bbc-ae1a-db85307696fc
# ╠═7e0ce959-5a70-4311-9031-540bf2414dd6
# ╟─e3d39b29-c0ef-45b1-96a5-e26a1e8763c5
# ╟─715b31c5-6c13-428a-8595-f8f661ba87ac
# ╟─1668cb38-6078-4a7f-8ade-96f6d42280b6
# ╠═d9636375-def7-4693-a2c3-91879d304b81
# ╠═9023f8f4-2084-4ef6-b9ca-a94e967320e5
# ╠═01c9e212-8cbc-4fb5-83d3-62dd0bfe48f7
# ╠═4c42ba85-442d-4ca8-9731-1bf71563e86e
# ╠═d9a74a15-8867-4b62-a6c3-943f6b6b6179
# ╟─b6005ec2-c856-4cfb-9de1-fd0d65b957a1
# ╟─75e91ef3-8893-48fc-a297-e54aa6b6c671
# ╟─1de74de8-36c5-467f-a749-4cefd0b2acdc
# ╟─877ef381-df6c-4a5b-bf99-88f8afba0995
# ╟─3a8ef338-38a4-4954-862c-6ce50e80f2fe
# ╟─2d036e2e-6850-46d8-bbb5-21856403ecc8
# ╠═b5449b8e-3000-48dc-a788-1d357569a5a9
# ╠═7ad20af1-a7d6-4092-b982-fad27d6e51ea
# ╟─ba3404b3-956e-4ca8-93aa-070897bdaa9a
# ╟─55bbc51f-86ef-41ab-824c-0d5fe4241181
# ╟─2633b604-7476-48d0-8cdc-05645ea0ed57
# ╟─3e93d41f-e465-42c4-b18e-e6dc99a3d1ad
# ╟─d50ef757-c687-4695-a4f3-2740a646ccd8
# ╟─b802bd1c-c590-499c-990f-596159fea135
# ╠═0872e2b8-386a-40a4-b2cb-48f564c921d8
# ╟─23a409b4-4299-4c12-a55a-adc438def7ea
# ╟─a3611641-256e-49e8-9e2e-c78b9efc21ce
# ╠═541a573c-2e87-49dc-97e7-778a50364e52
# ╠═dd6f459f-898f-4370-9cc8-35e410a76cc7
# ╠═f6e62718-42b7-4e0b-b9ab-60fbf3bfa4a6
# ╟─abf983de-2f8b-42d8-b3ef-54d0eb5f0cde
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
# ╠═1798453f-54cc-45e8-b65d-9e5745dbfbd6
# ╠═78e59b84-97e1-4042-af3a-065f992e1176
# ╟─2780a6fa-fc19-40be-93d1-8b092045a071
# ╟─9a987b58-47e9-4191-8fb7-9225d27d2628
# ╟─54cbf7b1-95d0-4027-b65f-a5ad5808e4b4
# ╟─81d40d17-e770-408a-8987-0ab17f40293d
# ╠═f2c5a261-af9f-4f4a-b854-1dc36bd7ea44
# ╟─b6036a94-7e1f-40f4-a905-b9081fd25c8a
# ╠═66fe1bad-ae41-4e10-82ce-64b36d446049
# ╠═7956a61e-f1c1-44b6-9583-1df552051af6
# ╠═5a4eb37f-82db-40f3-be2d-0412e473ccb1
# ╠═b9d3cf7e-942b-4cb3-bda2-c932dcc314a4
# ╟─725d0c60-a3fa-49ee-9c14-4b950f8b7d53
# ╟─7c35704a-c6dc-429a-b28f-105764177636
# ╟─b16906ed-b4ab-446e-a0e8-d79418ef56ca
# ╟─e4a6e169-925f-490b-b03a-21f277ff0fa5
# ╟─b0d2fd84-3307-4a6d-af91-32cfdaa375f0
# ╟─b0a3be42-6aec-4c7d-8798-d62a23aeb01a
# ╟─ffe0fb93-50f4-4a1d-b73b-e24fb729d043
# ╠═00653f98-5a3c-4baa-a0b1-405905dd1e69
# ╠═dc5833d4-b9e6-4ac0-999e-5c86428f6b8a
# ╠═16f24a88-91f8-455c-b415-c33f27224fc0
# ╟─d29b41b0-f453-4c61-95ac-42695a07187a
# ╠═3fc7529c-e101-480b-87d6-85400bbebd03
# ╠═cc0f82bc-096c-444e-a078-37e91d019234
# ╟─b2d01760-61a1-41b4-99dd-c719c1c6f679
# ╟─77868858-900b-43a5-8172-49832c339534
# ╟─3b210f36-33fb-4405-a9cf-9403d65cdce9
# ╟─c6ca304b-81ab-48c6-93d7-738336e5adbe
# ╟─66eff877-5530-4da7-8062-68b70d545e37
# ╠═cab15114-3851-442c-8fb4-d03928dcb082
# ╟─c2069db6-5737-4fb9-8d85-564cffb48357
# ╟─c48af5a0-9595-4af1-aaa0-21c38720654b
# ╟─db20720c-98d2-44b1-a9a3-8acc04ca55b9
# ╟─62748722-ba68-4bb9-9d87-8d08158e56dd
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
# ╟─bc7d0dc1-251d-4d0b-9813-f4a0fd311a18
# ╠═2b5cd8bb-7df2-4e59-8956-26b1974d9f0f
# ╠═6a056c28-bb34-42dc-92c2-c100154685a4
# ╠═2bc35e57-a5d4-484e-9dd9-ccaa7566eaf7
# ╠═330a0efe-c14e-4153-bd95-8b1fd9c27e66
# ╠═88592d8b-6115-4258-bd3f-33e01101e8dc
# ╟─18a1ec88-f203-46df-9d1d-50a6f10d4275
# ╟─78dfd8bd-ba3e-47c8-878a-b735a0f5d787
# ╠═4c3f565a-9938-44e6-9105-f4a949774ea0
# ╠═fdc5a903-61c4-411f-8726-be012cbd8cfc
# ╠═f95d08df-20e4-42d4-9afb-8872b33ad1e6
# ╟─897fbfd2-8282-42b3-93d1-f2d2303f621b
# ╟─424187c3-f6d3-4642-8d37-6266a2d9c597
# ╠═53e5a89f-304a-436c-bb64-a60d429994d0
# ╠═fa32b2ed-8c24-4b32-ad1e-41044b797533
# ╟─3ee12973-b0ad-409c-a451-bb765ad01cff
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
