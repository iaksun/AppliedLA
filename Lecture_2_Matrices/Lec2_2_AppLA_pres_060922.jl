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
	@static if Sys.isapple()
		using QuartzImageIO
    end
	using Plots
	using LaTeXStrings
end

# ╔═╡ 6f7bd689-a558-4287-b25a-15ab016e7b41
using DataFrames

# ╔═╡ 713f95f2-f406-4f3b-8d3c-c3c221f8b2b0
using Images,TestImages # Images and TestImages packages will be needed

# ╔═╡ 4442483a-9754-437b-aa90-69918fed6da7
using LinearAlgebra

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

# ╔═╡ 0c7b5d17-323f-4bc7-8495-c6507647a703
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

# ╔═╡ 0c2bf16a-92b9-4021-a5f0-ac2334fb986a
md"""# Lecture - 2: Matrices (Cont'd)

### $\rm \bf Content: \;Part \;1 \;- \;Matrices \;and \;Operations$

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

---
"""

# ╔═╡ 3c474013-48d1-44e5-bfad-6a1f9b542b3c
md"""#
> ##### 2.4. Matrix operations
>> ##### 2.4.1. Matrix transpose
>> ##### 2.4.2. Matrix-Scalar multiplication
>> ##### 2.4.3. Matrix addition/subtraction
>> ##### 2.4.4. Matrix-vector multiplication
>> ##### 2.4.5. Matrix-Matrix multiplication
>> ##### 2.4.6. Determinant
>> ##### 2.4.7. Inverse

### $\color{red} \rm \bf Content: \;Part \;2 \;- \;Applications$

> ##### $\color{red} \rm \bf 2.5. \;A \;Few \;Applications$
>> ##### $\color{red} \rm \bf 2.5.1. \;Markov \;processes$
>> ##### $\color{red} \rm \bf 2.5.2. \;Image \;and \;data \;compression$

---
"""

# ╔═╡ 371fc8fa-6866-4e62-93c3-58469f22a5d8
md"""# 2.5. A Few Applications

#### Examples and applications presented throughout this course 

#### will involve
##### $\quad \circ \;$ one or many uses of matrix operations,

##### $\quad \circ \;$ LA methods that extensively use matrix operations.
\

#### Just to showcase the use of the operations, two practical examples[^1], 
##### $\quad \circ \;$ Markov process
##### $\quad \circ \;$ Image compression

#### are selected. 

\

[^1]: Involve a few LA methods that will be introduced in due time.

---
"""

# ╔═╡ bdcf9a8d-2204-4d79-8319-e3b6df8c5446
md"""
## 2.5.1. Markov Process 

### What is Markov Process?

##### $\qquad - \;$ It is a stochastic model 
##### $\qquad - \;$ It describes a sequence of possible events 
##### $\qquad - \;$ The probability of each event depends only on the previous event

$\color{red} \large ''What \;happens \;next \;depends \;only \;on \;the \;state \;now''$
\

### Terminology

##### "_Markov chain_" is usually reserved for a process with a discrete set of times

##### Changes of state of the system are called "_transitions_"

##### Probabilities associated with state changes are called "_transition probabilities_"

---
"""

# ╔═╡ 065e786d-c6d6-400b-a47d-f0d194fce920
md"""
### Simple examples

#### Example 1: Weather forecast
##### Based on long time observations, we are confident for the following assumptions: 
##### $\qquad - \;$ we never have two Nice (N) days in a row, 
##### $\qquad - \;$ for N, it is equally likely to have Snow (S) or Rain (R) the next day, 
##### $\qquad - \;$ if it snows or rains, 
##### $\qquad \qquad \circ \;$ there is an even chance of having the same the next day, 
##### $\qquad - \;$ If there is change from snow or rain, 
##### $\qquad \qquad \circ \;$ only half of the time is this a change to a nice day. 

#### Form a Markov chain (≡ Transition matrix): 
$\large \begin{matrix} \qquad \qquad R\downarrow &  N\downarrow &  S\downarrow \end{matrix}$
$\large {\bf M} = \;\;\begin{matrix} R \\ N \\ S \end{matrix} \;\;\begin{bmatrix} 1/2 & 1/2 & 1/4 \\
						1/4 & 0 & 1/4 \\
						1/4 & 1/2 & 1/2 \end{bmatrix}$

##### $\qquad - \;$ Numbers show the transition probabilities
##### $\qquad - \;$ Each column adds up to 1

> The $ij^{th}$ entry of $M^n$ gives the probability that the Markov chain, starting in state sj, will be in state si after n steps.
---
"""

# ╔═╡ fe255021-3935-44dc-85e9-bedd6f1360eb
md"""#
### Example 1: Page Rank[^2] 
##### Birth of Google's PageRank algorithm:

###### Lawrence Page, Sergey Brin, Rajeev Motwani and Terry Winograd published [“The PageRank Citation Ranking: Bringing Order to the Web”](http://ilpubs.stanford.edu:8090/422/), in 1998, and it has been the bedrock of the now famous PageRank algorithm at the origin of Google. 

\

###### From a theoretical point of view, the PageRank algorithm relies on the simple but fundamental mathematical notion of **_Markov chains_**.

\

###### PageRank is a function that assigns a real number to each page in the Web that the higher the number, the more **important** it is.
[^2]: _Introduction to Markov chains: 
	Definitions, properties and PageRank example_, Joseph Rocca, Published in _Towards Data Science_ in Feb 25, 2019.

---
"""

# ╔═╡ 19cad43b-de3a-4922-a55a-56a192aca919
begin
	pgrank = load("PageRank-hi-res.png");
	pgrank[1:10:size(pgrank)[1],1:10:size(pgrank)[2]]
end

# ╔═╡ 3b117d55-f043-4deb-a5d3-66078ace53db
md"""
---"""

# ╔═╡ c4d7eeef-6528-4cb4-8fcd-887eb7f1f091
md"""#
### - Form the Markov matrix
"""

# ╔═╡ bcc8866b-5f3e-4a0e-a561-a06c80cc974a
markov_example = load("markov_fig.gif");

# ╔═╡ 5c9353c9-9926-4630-948e-dfb28060a66a
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

# ╔═╡ b929fc46-a0c5-41b5-aa12-f77f136ab3e0
M = [0.0 0.0 0.0 0.5 1.0 0.0 0.5;
	0.25 0.0 0.5 0.0 0.0 0.0 0.0
	0.0 0.5 0.0 0.0 0.0 0.0 0.0
	0.0 0.5 0.5 0.0 0.0 0.0 0.5
	0.25 0.0 0.0 0.0 0.0 0.0 0.0
	0.25 0.0 0.0 0.0 0.0 0.0 0.0
	0.25 0.0 0.0 0.5 0.0 1.0 0.0] # "Command + /" to toggle between commented and actived cells

# ╔═╡ f51d50a6-3253-4c41-9f1a-445d28582a4a
ones(7)' * M # Sum of all columns must be 1 as the total probability can not exceed 1

# ╔═╡ 84f64dbf-3cff-413a-88c9-ad89a372a7d2
md"""
---"""

# ╔═╡ ef2d3cb6-aa10-4abb-b4ea-e96768056ebb
md"""#
### - Define initial state

##### $\bullet \;\;$ Define an inital state: suppose surfer starts at Page-1, 
##### $\qquad \qquad {\bf x_0}=[1 \; 0 \; 0 \; 0 \; 0 \; 0 \; 0]'$
##### $\bullet \;\;$ Next state $\bf x_1 = M x_0$ is given as 

##### $\qquad \qquad {\bf x_1} = \begin{bmatrix} \cdot & \cdot & \cdot & 0.5 & 1.0 & \cdot & 0.5 \\ 0.25 & \cdot & 0.5 & \cdot & \cdot & \cdot & \cdot \\ \cdot & 0.5 & \cdot & \cdot & \cdot & \cdot & \cdot \\ \cdot & 0.5 & 0.5 & \cdot & \cdot & \cdot & 0.5 \\ 0.25 & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\ 0.25 & \cdot & \cdot & \cdot & \cdot & \cdot & \cdot \\ 0.25 & \cdot & \cdot & 0.5 & \cdot & 1.0 & \cdot \end{bmatrix} \begin{bmatrix} 1 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix} = \begin{bmatrix} \cdot \\ 0.25 \\ \cdot \\ \cdot \\ 0.25 \\ 0.25 \\ 0.25 \end{bmatrix}$
\

"""

# ╔═╡ 0a2fdc0e-99d7-42be-9995-f85b0376b81d
state0 = [1, 0, 0, 0, 0, 0, 0] # [1/7, 1/7, 1/7, 1/7, 1/7, 1/7, 1/7] 

# ╔═╡ ede06a6c-468e-4c26-9467-ab07a17717fd
state = zeros(7,50); # Initialize the state matrix

# ╔═╡ 7090909f-809b-4ef9-a86d-50ac512ab455
state[:,1] = M * state0

# ╔═╡ ac1831f6-d7e1-47ac-88ab-f4e3523fa07b
md"""
---"""

# ╔═╡ 906b0d37-934e-4aee-aa12-f49b56a62d4b
md"""#
### - Find the following states
##### $\qquad \qquad {\bf x_2 = M x_1} → {\bf x_3 = M x_2} → \cdots → {\bf x_n = M x_{n-1}}$

##### OR

##### $\qquad \qquad {\bf x_n = M^n x_0}$

"""

# ╔═╡ cf299aac-531d-41cb-ae79-ee5fcc0ff011
state[:,2] = M * state[:,1]

# ╔═╡ 81ee7e6b-0855-4a28-b6b9-f50e0b38e741
state[:,3] = M * state[:,2]

# ╔═╡ cf0a3a7a-613c-4174-ae2b-1133a604115c
state[:,4] = M * state[:,3]

# ╔═╡ 11bdc921-d39e-405a-93ee-002b986a2bef
state[:,5] = M * state[:,4]

# ╔═╡ 53017ff5-8e06-4e23-b027-ee49257aff6b
state[:,10] = M^10 * state0

# ╔═╡ cc17fd62-e5c2-4a0f-b8dd-506941951803
state[:,20] = M^20 * state0

# ╔═╡ 5314ec4c-d0ae-4290-b9d6-26eec26e104d
state[:,30] = M^30 * state0

# ╔═╡ 8de9608c-472d-40a0-8ab2-ba80463c74d8
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

# ╔═╡ 991d9d71-c85f-4fdb-9c9b-b13138c2a692
bar([i for i in 1:7], state[:,30], legend = false, xlabel ="Pages", ylabel= "PageRank values", size = (600, 350))

# ╔═╡ 58678b29-d37e-4d15-a5da-8a94632900c0
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

# ╔═╡ 4402e8ea-c9c6-46fa-8e54-43c94f954148
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

# ╔═╡ 1239b181-6331-4569-8e30-e8831e3a8ff5
begin
	plot([1:20], error_L1, xlabel = L"Number \;of \;Transitions", title = L"Distance \;between \;the \;last \;two \;transitions", label = L"L_1 \;Norm", mark = :square, fg_legend = :false)
	plot!([1:20], error_L2, mark = :circle, label = L"L_2 \;Norm")
	plot!([1:20], error_Linf, mark = :diamond, label = L"L_{\infty} \;Norm")
end  	

# ╔═╡ 1f0b8e56-eeb5-462b-a2e6-e7ae89665fbd
md"""
---"""

# ╔═╡ e64549f5-15af-4595-a901-c2016eebc80c
md"""#
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
"""

# ╔═╡ a078fb5c-2c7b-4893-ba84-72fa05f49e62
let
	state0 =[0, 0, 1, 1, 1, 0, 0]
	state30 = M^30 * state0
	nstate30 = state30 / sum(state30)
	bar([i for i in 1:7], nstate30, legend = false, xlabel ="Pages", ylabel= "PageRank values", title = "30 iterations; Initial state = $(state0[:,1])")
end

# ╔═╡ 6795cb2d-86f5-48d3-bad0-5f0dc50c550f
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

# ╔═╡ 82c94279-7723-400e-850b-0c47fe48ea39
gif(anim_states, "anim_states.gif", fps = 0.5)

# ╔═╡ 138ba645-cea3-4295-8cb4-f127255aaa3f
md"""#
#### Is $\bf M^n x_n = x_n$ ?   What is your conclusion?

##### $\bullet \;\;$ Do you remember ${\bf A x}=\lambda {\bf x}$ ? `Eigenvalues` and `Eigenvectors`
\

##### $\bullet \;\;$ $\bf M^n x_n = x_n$ implies that Markov matrix $\bf M$ has an eigenvalue at $\lambda = 1$ with its eigenvector $\bf x_n$
\

##### $\bullet \;\;$ So, finding the eigenvector of $\bf M$ corresponding to eigenvalue $\lambda = 1$ will directly give the steady-state:
"""

# ╔═╡ a3f0c93e-97d3-47b4-8e6c-5417ee77c3e0
# lambda = eigvals(M) # Eigenvalues of M

# ╔═╡ 608d6169-b6f5-4ce0-a814-d2e69c845e90
# eigv = eigvecs(M) # Eigenvectors of M in the order of eigenvalues

# ╔═╡ ed4eef8f-ad6b-42f0-b38d-4f5931a33719
# n_eigenvector = eigv[:,7] / sum(eigv[:,7]) # need to mormalize to the sum of the vector.

# ╔═╡ 6ec103a2-0737-4e58-9f03-39317ffd8b0a
# norm((eigv[:,7] / sum(eigv[:,7]) - state[:,30]),Inf) # see the distance (norm) between the eigenvector for lambda =1 and the state we have reached after 30 iterations

# ╔═╡ 688838c0-85e8-426f-bd50-8c953da83d44
md"""
---"""

# ╔═╡ 91149d9e-3c69-4f52-af82-654aaf8eba98
md"""
!!! note \"Project Idea - 1\"
	Review the PageRank algorithm of Google and find a way to promote your web page.
"""

# ╔═╡ fffd5112-314b-4c0f-90f4-15e5cc483b4c
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

# ╔═╡ 181512ad-360c-4f3f-8bde-41881f2d886f
M_covCDC = [0.95 0.10 0.0 ;
	0.05 0.70 0.30
	0.0 0.20 0.70]

# ╔═╡ 55d7449c-0b45-46a3-aeb0-c19b3af29cda
M_covAgg = [0.90 0.12 0.0 ;
	0.10 0.70 0.20
	0.0 0.18 0.80]

# ╔═╡ 20d53b4f-7c16-43e9-8818-de16765aa6a3
md"""
---"""

# ╔═╡ eeea9419-ee50-4335-b682-6e7cdb28abff
md"""# 
### ★ Eigenvalue - Eigenvector analysis
!!! note
	##### $\;\; - \;\;$ Largest eigenvalue of the Markov matrix is expected to be '$1$' 
	##### $\;\; - \;\;$ its corresponding eigenvector is the steady state

"""

# ╔═╡ 7ae0d9ab-c9e5-4d4c-8aaf-39df1548c2ca
# λ_CDC, v_CDC = eigen(M_covCDC) # just to give you an example of a variable name in greek letter

# ╔═╡ 19d90c1a-196d-495a-b487-63c73086639a
# lambda_covCDC, eigv_covCDC = eigen(M_covCDC)

# ╔═╡ cb054f29-a7d1-42bc-a904-6a4afd61b1d7
# lambda_covAgg, eigv_covAgg = eigen(M_covAgg)

# ╔═╡ 46b2064a-a563-404f-b9ed-5f935fd2baf3
md"""
#### $\quad \bullet \;\;$ As expected, $\lambda_{max} = 1.0$ and corresponding eigenvectors
##### $\qquad \;\;\; \rightarrow \;\; [-0.86, -0.43, -0.286]\;$ for the CDC case 
##### $\qquad \;\;\; \rightarrow \;\; [0.67, 0.55, 0.50]\;$ for the Aggressive case.

\

#### $\quad \bullet \;\;$ Eigenvectors represent the probabilities, so 
#### $\quad \quad$ they need to be normalized to make the sum of their 
#### $\quad \quad$ entries unity 
"""

# ╔═╡ 77e82a01-f253-4d4b-9555-5f0f0170e23e
# ss_covidCDC = eigv_covCDC[:,3]/ sum(eigv_covCDC[:,3])

# ╔═╡ c37b9b9c-4e85-45d8-909d-a95360e92b2d
# ss_covidAgg = eigv_covAgg[:,3]/ sum(eigv_covAgg[:,3])

# ╔═╡ 43fd2bdd-8fcf-4eba-a638-6a6f6ee7b720
md"""
---"""

# ╔═╡ 2b9be8d2-b389-4c8b-a7ef-70304fe7b45f
md"""#
#### $\qquad \qquad \qquad$ Steady state distributions"""

# ╔═╡ 075ba59d-02fc-4015-83f7-801ca7bb8fc9
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

# ╔═╡ 386a3d57-3188-4f52-9be6-59b3c0abc207
md"""
\

#### _The steady-state distribution_ represents 
##### $\qquad -\;$ the long-run percent of cases in each states
##### $\qquad -\;$ the rates at which the Markov Chain enters the states
##### $\qquad \qquad \circ\;$ the average time between two successive visit to a state 
##### $\qquad \quad \quad \;\;$ = 1/ (long-run percent)
"""

# ╔═╡ 179cd26c-dbee-43e4-9964-aa20beecf8b5
md"""
---"""

# ╔═╡ 44ec39d6-e39b-4912-aa20-b07b2c3a41b2
df_covid = DataFrame(Infection_Rates = ["Efficient (5%)", "Efficient (5%)", "Inefficient (10%)", "Inefficient (10%)"], 
    Long_run = ["Probabilities", "Times Between", "Probabilities", "Times Between"],
    Not_Infected = [0.545, 1.834, 0.387, 2.583],
    Infected_Home = [0.273, 3.667, 0.322, 3.099],
	Hospitalized = [0.182, 5.50, 0.290, 3.444])

# ╔═╡ abbc6066-6b4a-462f-aa57-7cfb3b7622b1
md"""
#### Observations
##### $\bf \qquad 1.\;$ For 10% infection rates, higher percent of patients hospitalized,
##### $\qquad \qquad \qquad \qquad$ 29% vs. 18.2%
##### ⇒ infection rate increase results in saturating the Health Care system
##### $\bf \qquad 2.\;$ For 5% infection rates, times between two successive visits
##### $\qquad \quad$ to the Hospital are longer: 5.5 days vs. 3.4 days

---
"""

# ╔═╡ 92139ad8-970b-4712-82e5-dfc8a4271c62
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

# ╔═╡ c8912b35-85c4-4fa9-bc1e-da54812b681b
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

# ╔═╡ 13630b66-ad86-4873-811f-2a4d82d630b6
md"""#
#### For the Markov model
##### $\qquad -\;$ the unit time is a day, transitions are from morning to the next
##### $\qquad -\;$ every transition is an independent trial 
##### $\qquad -\;$ the data are closer to the cases in Italy or NYC

!!! danger \"Absorbing State\"
	##### $\;\; -\;$ The last column (dead state) has a single entry with propability '1'
	##### $\;\; -\;$ It is the final state, _no return_
"""

# ╔═╡ fd5b6697-09a0-43f5-ba08-a9e8cd167802
M_cov = [0.93 0.05 0.0 0.0 0.0;
	0.07 0.80 0.15 0.0 0.0
	0.0 0.10 0.80 0.05 0.0
	0.0 0.05 0.05 0.80 0.0
	0.0 0.0 0.0 0.15 1.0]

# ╔═╡ ebeb4bbf-3192-417c-a853-d8f1f44551e1
md"""

##### What happens to $\bf x_n = M^n x_0$? 
##### Where does $\bf M^n$ converges to for $n→∞$?

---
"""

# ╔═╡ c65c827f-ba05-48d6-a868-8a8fbb1e089e
md"""#
$\Large {\bf Brute \;force \;calculation}$
"""

# ╔═╡ e2583179-509e-4f0a-a6ef-715eb0d9f28e
M_cov^500 # all columns converge to [0, 0, 0, 0, 1]

# ╔═╡ 792b3254-4d90-4b2c-a0b6-ed324ff87594
md"

$\Large {\bf Eigenvalue \;and \;eigenvector \;calculation}$

"

# ╔═╡ b3a1f41f-1b08-4de7-b44a-e3239c313336
lambda_cov, eigv_cov = eigen(M_cov)

# ╔═╡ 7a5bf0e8-ab35-4e13-81fd-1d0862178281
eigv_cov[:,5] # corresponds to lambda=1, so steady-state seems to be when everyone is dead?

# ╔═╡ cd4adf49-b052-4bf1-8c3f-9348da88666f
md""" 
$\Large {\bf In \;steady \;state, \;it \;converges \;to \;the \;aborbing \;state}$

!!! danger 
	#### Everybody will be dead 🤔

---
"""

# ╔═╡ b979ac94-fb8a-4575-8b5f-0328128a3ad0
md"""#

## ★ Working with absorbing states

#### This is a brief overview for curious minds (not included) [^3]

##### Transition matrix for a Markov chain with $l$ absorbing states
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

# ╔═╡ b763d610-f777-4d28-85b6-89f1e342796e
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

# ╔═╡ e5051924-1c30-48cf-8568-bfea56957a8e
T = M_cov[1:4,1:4] # Block T (4 x 4), only the transient porton of M

# ╔═╡ 96f3162a-4a1a-46b4-8ba2-fccc00ff41b4
R = M_cov[5,1:4] # Block R (1 x 4), from transient to absorbing state

# ╔═╡ d520c2bb-7b77-4fba-944b-6ebe44f3cb17
ones(4)' * T # to check if the column sums are less than 1 => NOT

# ╔═╡ ef115594-908d-4f7a-a199-108a0239cdc5
ones(4)' * T^5 # However, higher powers of T satisfy this criterion, which would be enough for the approximation

# ╔═╡ fe030af9-6868-4ef4-b858-49ed33d3a9db
lambda_T = eigvals(T) # eigvals and eigvecs give e-values and e-vectors separately

# ╔═╡ 77a0d2ff-ca16-4da6-ae52-acbb5f194262
md"""
---"""

# ╔═╡ a8d4331b-b2b2-4f20-8d80-75213829067b
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

# ╔═╡ 39a3e51e-8bc9-4a55-9bb4-460f750ae0d6
F = (I(4) - T)^-1 # or inv(I(4)-T) Fundamental Matrix

# ╔═╡ 12ec3ef3-491c-41c8-9e4c-e87445b71a7a
R' * F # as expected, in steady-state, it goes to the absorbing state

# ╔═╡ fa4945ec-f1f3-4ea1-8c06-0a98c673c7d0
ones(size(F,1))' * F

# ╔═╡ 5ce07a9d-6817-4be4-ac4a-74db4e821aa3
md"""
---"""

# ╔═╡ f8cef7e7-ba70-4220-933c-f0d91b1ec080
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

# ╔═╡ 456df6e3-b4cb-4a6b-9b7c-36998859d95a
M_cov^2 # Probability of dying in 2 days for Healthy is 0.0, for infected is 0.0075, for Hospitalized is 0.0075, for ICU is 0.27

# ╔═╡ b984d4e3-b240-45fb-89b4-6795454b4048
M_cov^8 # Probability of dying in 8 days for Healthy is 0.018, for infected is 0.118, for Hospitalized is 0.127, for ICU is 0.636

# ╔═╡ e4894761-fcbb-421f-b72f-b542a9ee5ac9
md"""
<center><b><p
style="color:black;font-size:30px;">End of Markov Process</p></b></center>
"""|>HTML

# ╔═╡ 263953a3-7af9-4b7e-ba44-8d6bbef83eb0
md"""
---"""

# ╔═╡ 3de20f99-af1c-413a-b8f4-dc2d259ece3a
md"## 2.5.2. Image and Data Compression

#### Images can be stored in a disk as 3D arrays (≡ Matrices) 
##### $\qquad -$ one dimension stores the color (RGB - Red Green Blue) 
##### $\qquad -$ the other two store the numbers of pixels along x and y
\

#### Example: 2D array of decimal numbers between 0 and 1 
##### $\qquad -$ Gray scale maps the color of a pixel between 0 and 1
"

# ╔═╡ 52f94555-b54b-4e87-894c-d147ee3525ed
img = rand(10,20); #Arrays of "plain numbers" are not displayed graphically, because they might represent something numerical rather than an image. 

# ╔═╡ 18f2a37a-dfb7-49aa-9788-b174b15f4e80
imgg=Gray.(img) #To indicate that this is worthy of graphical display, convert the element type to a color chosen from the Colors package. Gray indicates that this array should be interpreted as a grayscale image

# ╔═╡ 85a282f8-83c7-4cd9-9329-a3d6ebcfa77e
img == imgg # they don't take up any memory of their own, nor do they typically require any additional processing time. The Gray "wrapper" is just an interpretation of the values, one that helps clarify that this should be displayed as a grayscale image.

# ╔═╡ 165e212a-4037-455e-9b76-f605bd7fde37
img_den1 = rand(3,5)

# ╔═╡ 5859511e-55e8-4e77-b208-39d2c8151de2
imgg_den = Gray.(img_den1) # Gray.(rand(8,8))

# ╔═╡ 013b7ebc-4201-4d42-ae02-cacdc2d98908
img_gray = rand(Gray, 3, 4)

# ╔═╡ 238a92e6-7d7d-441c-9fbb-7d658981b5ea
md"""
---"""

# ╔═╡ 0ac852a2-446f-4756-b059-f30fe112a3cc
md"""#

### 1. Image Representation

#### The quality of an image depends on two factors,
##### $\qquad -$ the amount of Pixels Per inch (PPi)
##### $\qquad -$ the color depth 

\

##### $\color{red} \rm \bf colour \;depth:$ Number of bits used to represent the colors in each pixel


##### For RGB ($\color{red}Red$ $\color{green} Green$ $\color{blue} Blue$) representation, 8 bits used for each color; 

##### $\qquad -$ The color depth is 24 bits 
##### $\qquad -$ amounting to $2^{24}$ (≊16 Million) different colors for each pixel
##### $\qquad -$ The human eye can discriminate up to ten million colors
##### $\qquad -$ 24-bit is used by virtually every computer and phone display

"""

# ╔═╡ f7e8eec5-2867-4053-8767-91839f6a5c56
2^8 - 1

# ╔═╡ 9742c131-55ad-47da-b600-1a622b90a152
RGB{Float32}(200,200,0)/255 # have to normalize it by 255 as RGB assumes numbers between 0 and 1. However, if they are larger than 1, the respected color means to be saturated

# ╔═╡ 307a0345-2621-430a-802e-c4150f289436
csat = RGB{Float32}(8,2,0) # red and green are saturated, so dividing by two will not change.

# ╔═╡ b52f4f54-66a8-41c4-9afc-c72a25e30b23
[csat csat/2 csat/4 csat/16 csat/32 csat/64]

# ╔═╡ ebe4c9de-96fb-456a-973b-9222238bce7e
[RGB(i, j, 0) for i in 0:0.1:1, j in 0:0.1:1]

# ╔═╡ ce0e742a-1252-4a97-b70b-4601c7cc6cf3
md"""#
### 2. Size of an image - Low Resolution

#### Let us first construct an image with $8 \times 8$ pixel resolution:

"""

# ╔═╡ 28227637-f954-4fb9-a286-28dbcc33950e
imgc1 = [RGB(1.0,1.0,1.0) .* ones(1,8);
	RGB(1.0,1.0,1.0) RGB(1.0,0.0,.0) RGB(1.0,0.0,0.0) RGB(1.0,1.0,1.0).*ones(1,2) RGB(1.0,0.0,0.0).*ones(1,2) RGB(1.0,1.0,1.0); 
	RGB(1.0,1.0,1.0) .* ones(1,8);
	RGB(1.0,1.0,1.0).*ones(1,3) RGB(1.0,0.0,0.0) RGB(1.0,0.0,0.0) RGB(1.0,1.0,1.0).*ones(1,3);
	RGB(1.0,1.0,1.0) .* ones(1,8);
	RGB(1.0,1.0,1.0) RGB(1.0,0.0,0.0) RGB(1.0,1.0,1.0).*ones(1,4) RGB(1.0,0.0,0.0) RGB(1.0,1.0,1.0);
	RGB(1.0,1.0,1.0) RGB(1.0,1.0,1.0) RGB(1.0,0.0,0.0).*ones(1,4) RGB(1.0,1.0,1.0) RGB(1.0,1.0,1.0);
	RGB(1.0,1.0,1.0) .* ones(1,8)]

# ╔═╡ 757ca38f-5070-4c77-b792-d162b3254a12
md"""

##### RGB(1.0,1.0,1.0) ⇒ White Color; $\quad$ RGB(0.0,0.0,0.0) ⇒ Black Color.

  
* All indices in an image correspond to locations in the image:
  - don't need to worry about dimensions of the array corresponding to ''color channel'', 
  - guaranteed to get the entire pixel content when you access that location.


* However, to work with other packages, one needs to convert a $(m \times n)$ RGB image data to $(m \times n \times 3)$ numeric array with separate channels for the color components and vice versa.


* The functions `channelview` and `colorview` in _`Julia`_ are designed for this purpose.
"""

# ╔═╡ 0d69ae64-e358-495a-8f60-418f7f6e4e0d
img_CHW = channelview(imgc1); # 3 x 8 x 8 1st Color, 2nd Height, 3rd Width

# ╔═╡ 314fd69f-4a2b-49f3-9ae4-ccdaf7c47482
md"
* To change the order and put the color channel to the last position, use `permutedims` instruction:
"

# ╔═╡ 0947c623-7ea2-4ecc-a971-adbf5982fd0d
img_HWC = permutedims(img_CHW, (2, 3, 1)); # 8 x 8 x 3 1st H, 2nd W, 3rd Color

# ╔═╡ a75b0884-4fb1-4406-8b4c-b9ff4d1de813
md"
!!! notice
	In HWC ordering, the first 8x8 matrix is for `Red Channel`, the second is for `Green Channel` and the third is for `Blue Channel`.
"

# ╔═╡ fcc74341-e5c6-498f-a183-37e0fa643953
img_CHW2 = permutedims(img_HWC, (3, 1, 2)); # 3 x 8 x 8 1st C, 2nd H, 3rd W

# ╔═╡ 398eb472-6a59-4a1c-9887-1fed74fd728c
img_rgb = colorview(RGB, img_CHW2) # 8 x 8

# ╔═╡ ac80f19d-f5ea-46ab-a774-1f8b6ae95c7d
md"""#
### Size of an image - Higher Resolution

Let us constract the same image with higher resolution (16 x 16):

"""

# ╔═╡ 43cf5958-d60b-4a60-9486-5f2d6ab2de01
imgc2 = [RGB(1.0,1.0,1.0).*ones(2,16); 
 		RGB(1.0,1.0,1.0).*ones(1,4) RGB(1.0,0.0,0.0).*ones(1,2) RGB(1.0,1.0,1.0).*ones(1,4) RGB(1.0,0.0,0.0).*ones(1,2) RGB(1.0,1.0,1.0).*ones(1,4); 
RGB(1.0,1.0,1.0).*ones(1,3) RGB(1.0,0.0,0.0).*ones(1,4) RGB(1.0,1.0,1.0).*ones(1,2) RGB(1.0,0.0,0.0).*ones(1,4) RGB(1.0,1.0,1.0).*ones(1,3);
RGB(1.0,1.0,1.0).*ones(1,4) RGB(1.0,0.0,0.0).*ones(1,2) RGB(1.0,1.0,1.0).*ones(1,4) RGB(1.0,0.0,0.0).*ones(1,2) RGB(1.0,1.0,1.0).*ones(1,4);
RGB(1.0,1.0,1.0).*ones(1,7) RGB(1.0,0.0,0.0).*ones(1,2) RGB(1.0,1.0,1.0).*ones(1,7);
RGB(1.0,1.0,1.0).*ones(1,7) RGB(1.0,0.0,0.0).*ones(1,2) RGB(1.0,1.0,1.0).*ones(1,7);
RGB(1.0,1.0,1.0).*ones(1,6) RGB(1.0,0.0,0.0).*ones(1,4) RGB(1.0,1.0,1.0).*ones(1,6);
RGB(1.0,1.0,1.0).*ones(1,6) RGB(1.0,0.0,0.0).*ones(1,4) RGB(1.0,1.0,1.0).*ones(1,6);
RGB(1.0,1.0,1.0).*ones(2,16);
RGB(1.0,1.0,1.0).*ones(1,3) RGB(1.0,0.0,0.0) RGB(1.0,1.0,1.0).*ones(1,8)  RGB(1.0,0.0,0.0) RGB(1.0,1.0,1.0).*ones(1,3);
RGB(1.0,1.0,1.0).*ones(1,4) RGB(1.0,0.0,0.0).*ones(1,8) RGB(1.0,1.0,1.0).*ones(1,4);
RGB(1.0,1.0,1.0).*ones(1,5) RGB(1.0,0.0,0.0).*ones(1,6) RGB(1.0,1.0,1.0).*ones(1,5);
RGB(1.0,1.0,1.0).*ones(2,16)];

# ╔═╡ 827ce586-aebb-401c-bf47-72a70f577f42
begin
p_image = plot(imgc1, xticks = 1:8, yticks = 1:8, xlim = (1,8), ylim = (1,8));
p_image2 = plot(imgc2, xticks = 0:2:16, yticks = 0:2:16, xlim = (1, 16), ylim = (1,16)); # not possible to introduce grid lines when it is image
plot(p_image, p_image2, layout= (1,2), aspect_ratio = 1)
end

# ╔═╡ 33968a86-9c0d-42c6-82d4-2be91e50602c
TwoColumn(
md"""

**8 pixels wide by 8 pixels tall** \
8 x 8 = 64 (total number of pixels used)

with 24 bits color depth \

64 x 24 = 1536 Bits OR 1536/8 = 192 Bytes
""",
	md"""
**16 pixels wide by 16 pixels tall** \
16 x 16 = 256 (total number of pixels used)

with 24 bits color depth \

256 x 24 = 6144 Bits OR 6144/8 = 768 Bytes

"""
)

# ╔═╡ 613c9159-422a-4557-b17d-805e4d122f35
md"# 
* **for a realistic image**, we have more pixels in both direction:\
  600 pixels for height and 800 pixels for width \
  600 x 800 x 24 = 11,520,000 Bits **OR** 11.52 Mbs (Megabits) **OR** 11.52/8= \
  **1.44 MB** (MegaBytes)
> **Size on Disk = Width x Height x Color Depth (bytes)**

* **For a typical video**, \
  1280 (W) x 720 (H) x 3 (C) = 2.76 MB/frame, \
  30 frames/second: then 1280 (W) x 720 (H) x 3 (C) x 30 Frames/second x 60 seconds/min = **4.98GB/min**
> **Size on Disk = Width x Height x Color Depth (bytes) x Frame/sec x Time**

**_Conclusion_**: Huge data to store, transfer and/or process. \


**_Remedy_**: Compress the data with no loss or with an acceptable level of loss. 

* There are many ways to compress an image data,
* **_Singular Values Decomposition (SVD)_** is a Linear Algebra Technique, and regardless of the field, it has become a key tool in data centeric applications.
"

# ╔═╡ f611385d-542a-47f9-ae76-24fe7f34cb49
md"""#
### Load Images (Internet)

Let's first load an actual image (from the internet or from own files or even from webcam) and play with it:

> Use the `Images.jl` package to load an image file in three steps.


**Step 1:** specify the URL (web address) to download from:


"""

# ╔═╡ 409914ae-eae9-44ef-ba01-29014d623438
url = "https://upload.wikimedia.org/wikipedia/commons/6/65/Blue_morpho_butterfly.jpg"

# ╔═╡ 913d846f-c3d1-411e-98a5-d5d5f40953af
md"""
**Step 2:** Use `download` function to download the image file to your computer. (Blue morpho butterfly.)
"""

# ╔═╡ f253176d-02b6-4c8b-aac7-28ecd5d1a59f
butterfly_filename = download(url) # download to a local file. The filename is returned

# ╔═╡ fcf562c2-571f-402d-b2b5-c642420dd37f
md"""
**Step 3:** Using the `Images.jl` package (loaded at the start of this section) **load** the file, which automatically converts it into usable data. We'll store the result in a variable.
"""

# ╔═╡ 170d6bc5-be4d-4979-a684-2aa807d86666
morpho_butterfly = load(butterfly_filename);

# ╔═╡ 3e84c0dd-1202-441e-b83f-87fe878ad1f7
begin
img_square = imresize(morpho_butterfly, (600, 600));
img_small = imresize(morpho_butterfly, ratio=1/4);
img_medium = imresize(morpho_butterfly, ratio=1/2);
mosaicview(morpho_butterfly, img_square, img_small, img_medium; nrow=1)
end

# ╔═╡ 45c0b433-2710-4be9-937e-aae9821fa6f3
img_vsmall1 = imresize(morpho_butterfly, ratio=1/10);

# ╔═╡ a31a45f8-549b-4ee5-8b59-fb6fcd5b0c3f
img_vsmall2 = morpho_butterfly[1:10:size(morpho_butterfly)[1], 1:10:size(morpho_butterfly)[2]];

# ╔═╡ 034ea1d5-99f5-4ed1-aa69-4c2d52a06a6f
mosaicview(imresize(img_vsmall1, (200,200)), imresize(img_vsmall2, (200,200)), nrow =1)

# ╔═╡ dc764f84-f184-4b3b-992c-ff49878d5d11
md"""#
### Load Images (Local)

If an image in your computer needs to be loaded, then use **load** comment again with the path of the file as its argument:
"""

# ╔═╡ f9cc757b-225c-4571-9e83-56540ef45653
butterfly = load("milkweed-rainbow-butterfly.jpeg") # loaded from the directory in my computer

# ╔═╡ 8546c7c6-beb0-48a8-aaf2-063643eb5a90
md"""#
### Load Images (webcam)

Note that there is a function `Camera_input()` written in _HTML_ at the end of this notebook, which is coppied from the [notebook](https://computationalthinking.mit.edu/Spring21/images/) by Prof. Alan Edelman, David P. Sanders & Charles E. Leiserson.
"""

# ╔═╡ 9814b4cd-e1d8-4abf-a7a0-8ac4fe84b6f8
md"""#

### More on Images: Indexing

* To examine a piece of an image in more detail, specify the location of the piece. 

* Image is a grid of pixels, a two-dimensional grid:
  - Computer needs to know which pixel or group of pixels refered to. 
  - Specifying coordinates is called **indexing**.

"""

# ╔═╡ 7109999d-ead6-4708-bd4e-03c4326acf98
butterfly_height, butterfly_width = size(butterfly) # (1,1) corresponds to the upper left corner, (1164,1) for the lower left corner. 1st number is the heigth and second one is for the width

# ╔═╡ 052883ee-3ad8-4881-9fc4-419b29c6d5a1
a_pixel = butterfly[600, 500] # Change the indeces to see the color from other parts

# ╔═╡ 5bb58608-ed31-4aad-9457-7e18e9e4ef93
@bind row_i Slider(1:size(butterfly)[1], show_value=true)

# ╔═╡ c681f722-72e0-4b58-b33b-80545d698522
@bind col_i Slider(1:size(butterfly)[2], show_value=true)

# ╔═╡ 684ddb18-178d-457b-911d-a556c0b123f0
butterfly[row_i, col_i]

# ╔═╡ 35936fc1-f024-4709-ada4-4e7987b650f2
butterfly[500:750, 1:butterfly_width]

# ╔═╡ ab3e3ba6-36d8-4c40-b415-5db1ab83fdb9
butterfly[550:650, :] # note that ':' means the whole colomn. [:,:] whole rows and columns

# ╔═╡ 893cbef4-dc64-44b5-8bdb-d8bddd0ae1ca
butterfly[550,:] # Pixels in a single row

# ╔═╡ 4826fae2-82f3-417b-be90-2c9741666f37
md"#
##### Indexing (Cont'd)

Let us add a range slider by which we can tune to the location of the picture we want:
"

# ╔═╡ 984031d6-80b4-4fe5-8f9f-9375290b1951
@bind range_rows RangeSlider(1:size(butterfly)[1])

# ╔═╡ 960e6ae6-042d-41af-9c7b-a7057013c3f2
@bind range_cols RangeSlider(1:size(butterfly)[2])

# ╔═╡ da605dae-4c51-4afd-b270-d3282fa06f35
butterfly[range_rows, range_cols]

# ╔═╡ 71ac7102-18cb-44ec-a0c1-e0101e3181a6
size(butterfly)

# ╔═╡ 0c525731-e5e4-4f75-80de-d30fcc03ebbc
imresize(butterfly[1:10:1164, 1:10:1552], (1164,1552))

# ╔═╡ d5d2a909-a172-4352-aafd-08d3c1cf56f4
md"#

## Examples on Compression

* **_For Gray Scale images_**, values for each pixel (between 0 and 1) represent the intensity of light emitted from the pixel.
* **_For Color images_**, there are three layers with the intensities for each color in the RGB spectrum.
* For the SVD application to a color or grayscale image, we must convert it to channelview and
  - if it is color image, SVD each color layer, and then recombine the decomposed layers to produce the whole decomposed true color image.
  -  if it is gray scale, then SVD it directly.

"

# ╔═╡ 3fb56e0c-d551-4754-8950-32451eb88fa9
md"#
### The Simple Example

For the sake of simplicity, let us start with the easiest image that one can understand how to compress intuitively: all black or white or all a constant gray scale g. 

So, for a white screen of $6 \times 6$ pixels (remember GRB(1,1,1) is white)

**Don't store** ${\bf A} = \begin{bmatrix} 1 & 1 & 1 & 1 & 1 & 1 \\
						 1 & 1 & 1 & 1 & 1 & 1 \\
	   					 1 & 1 & 1 & 1 & 1 & 1 \\
		  				1 & 1 & 1 & 1 & 1 & 1 \\
						1 & 1 & 1 & 1 & 1 & 1 \\
	  					1 & 1 & 1 & 1 & 1 & 1 \\
		 \end{bmatrix} \Rightarrow$ **store** 
   						${\bf A} = \begin{bmatrix} 1 \\ 1 \\ 1 \\ 1 \\ 1 \\ 1 \\
		 						\end{bmatrix} \begin{bmatrix} 1 & 1 & 1 & 1 & 1 & 1 \\
		 						\end{bmatrix}$

36 numbers become 12 numbers.

**OR** for a real grayscale picture of 600 pixels by 800 pixels, 480,000 numbers become 1,400.
"

# ╔═╡ 83b5ad21-ec8a-49c3-85b7-ed9d94dba742
[1:4;]

# ╔═╡ 11b57734-cf9e-450e-a7df-0639414a05a8
collect(1:4)

# ╔═╡ 24b3970f-e78b-4b55-8f43-5d4898fbc935
md"#

### More simple examples
Some flags are made out of stripes, like French, Italian and German flags:

**Don't store** ${\bf A} = \begin{bmatrix} a & a & c & c & e & e \\
						 a & a & c & c & e & e \\
	   					 a & a & c & c & e & e \\
		  				a & a & c & c & e & e \\
						a & a & c & c & e & e \\
	  					a & a & c & c & e & e \\
		 \end{bmatrix} \Rightarrow$ **store** 
   						${\bf A} = \begin{bmatrix} 1 \\ 1 \\ 1 \\ 1 \\ 1 \\ 1 \\
		 						\end{bmatrix} \begin{bmatrix} a & a & c & c & e & e \\
		 						\end{bmatrix}$

where 
* French flag has three vertical stripes of blue, white and red,
* Italian flag has three vertical strips of green, white and red,
* German flag has three horizontal strips of black, red, yellow.
"

# ╔═╡ 9dd09625-482b-44dc-a641-13a8150815f9
french = [RGB(0.0,0.0,1.0) .* ones(2,6);
		  RGB(1.0,1.0,1.0) .* ones(2,6);
		  RGB(1.0,0.0,0.0) .* ones(2,6)]'

# ╔═╡ 33fdfd65-0950-4cc2-9200-69b7dbd35efd
german = [RGB(0.0,0.0,0.0) .* ones(2,6);
		  RGB(1.0,0.0,0.0) .* ones(2,6);
		  RGB(1.0,1.0,0.0) .* ones(2,6)]

# ╔═╡ f630e152-98a7-48f8-a355-ea9ebe1502f0
md"#
### A realistic example

let us work with the gray scale image of the butterfly:
"

# ╔═╡ a7a46218-6ca9-4041-a9f1-7edc6ef5e458
gray_butterfly = Gray.(butterfly) # By elliminating the color, now it is a 2D array

# ╔═╡ bcaf90ce-6df3-4e39-ae30-280d5a3f2467
height_gbfly, width_gbfly = size(gray_butterfly)

# ╔═╡ 04054ed2-83a1-4ea3-a183-5787f61569dd
md"# 
##### How much memory is it required to store this image?

- Number of Pixels = $height_gbfly x $width_gbfly = $(height_gbfly * width_gbfly) 
- 1 Byte (8 Bits) for color (gray scale)
⇒ This image requires approaximately $(height_gbfly * width_gbfly / 1000000) MB in the memory

"

# ╔═╡ e38ac9e6-6fb7-426d-9b99-d51dacb8a106
nofpixel_skip_h, nofpixel_skip_w = 15, 15;

# ╔═╡ 271dfb86-a875-48c7-a14b-c6fbf8c1566e
butterfly_sliced = gray_butterfly[1:nofpixel_skip_h:height_gbfly,1:nofpixel_skip_w:width_gbfly] # Slice as you wish

# ╔═╡ 83af63ef-6d6a-46ab-87bb-e8e957e3b9da
row_slbfly, col_slbfly = size(butterfly_sliced)

# ╔═╡ b979cadf-50a5-4192-a412-dbf8f005560d
md"
It is possible to filter down the image by selecting less number of pixels in both row and column directions, say choose **one in every $nofpixel_skip_h pixels along height** and **one in every $nofpixel_skip_w along width**, which result in 

 $row_slbfly x $col_slbfly x 1Byte = $(row_slbfly * col_slbfly) Bytes

and the image looks like as given below:
"

# ╔═╡ 733ecebc-19b2-4789-aacf-554544b78255
md"# 
### Application of SDV
"

# ╔═╡ 4c3705f5-814c-4919-9584-62d38db5ebe9
A_gb = channelview(gray_butterfly); # To work on the image, one needs to pass the picture through channelview in order to convert it to a matrix notation

# ╔═╡ fd5ed657-afae-43c0-827e-6390653e8f64
U,σ,V = svd(A_gb, full = true); # Calculates the necessary components of the SVD factorization, which are 'singular vectors` U and V, and a diagonal matrix composed of `singular values`.

# ╔═╡ 6b9fea12-3105-48ed-93b6-5e78182c1a4d
A_gb1 = σ[1] * U[:,1] * V[:,1]'; # Rank-1 approximation

# ╔═╡ 3231ec8a-2223-4b4a-bab8-44a450d87ac4
u_rank1, v_rank1 = [size(U[:,1]), size(V[:,1])]

# ╔═╡ c38cb55b-47c4-4228-b668-a13e25bc43b6
GB_rank1 = Gray.(A_gb1);

# ╔═╡ f6fa8f90-abfd-403a-9855-46d613223834
A_gb20 =  U[:,1:20] * Diagonal(σ[1:20]) * V[:,1:20]'; # Rank-20 approximation

# ╔═╡ 395fa074-6a6a-4e30-9ed9-2df1bd7ed2cd
u_rank20, v_rank20 = [size(U[:,1:20]), size(V[:,1:20])]

# ╔═╡ 012c5d56-78af-4aa5-948d-cf678765e56a
GB_rank20 = Gray.(A_gb20);

# ╔═╡ d3e6926e-3ed8-4a4a-a10d-9af52c1297c7
A_gb50 =  U[:,1:50] * Diagonal(σ[1:50]) * V[:,1:50]'; # Rank-50 approximation

# ╔═╡ b68be486-ff5c-422d-9328-9a3571feb70a
u_rank50, v_rank50 = [size(U[:,1:50]), size(V[:,1:50])]

# ╔═╡ 007088c5-51cc-4ed5-951d-b6acda52a0ad
GB_rank50 = Gray.(A_gb50);

# ╔═╡ ea6148bc-08d1-4dd0-a7a7-dc4f7a310d45
md"#
### Quality Check
###### Let us look at the quality of pictures for different rank approximations:

$$\begin{aligned}
&\begin{array}{ c  c  c c }
\text {\bf Rank-1}  & \qquad \qquad \text {\bf Rank-20 } & \qquad \qquad \text { \bf Rank-50 } & \qquad \qquad \text { \bf Original } \\
\end{array}
\end{aligned}$$
"

# ╔═╡ 78c521dd-36fd-4904-ba2c-faf9e617447f
[GB_rank1 GB_rank20 GB_rank50 gray_butterfly]

# ╔═╡ 654ddb3a-11c4-4033-994d-9a038979b677
md"

$$\begin{aligned}
& \text {\bf Memory Requirements (Bytes)}\\
& \begin{array}{| c | c | c |c |}
 \qquad \text { Rank-1 } \qquad  & \qquad \text { Rank-20 } \qquad & \qquad \text { Rank-50 } \qquad & \qquad \text { Original } \qquad \\
\hline \qquad 2717 \qquad & \qquad 54,340 \qquad & \qquad 135,850 \qquad & \qquad 1,806,528 \qquad \\
\hline
\end{array}
\end{aligned}$$
"

# ╔═╡ 1e46f093-982a-45cf-aa0a-25ddbfd3bd51
md"
Compare the results of the SVD and Slicing.
"

# ╔═╡ 5c292b05-5d5d-43ea-8ac2-9c6578d14d86
mosaicview(imresize(butterfly_sliced, (1164,1552)), GB_rank50, nrow = 1)

# ╔═╡ bd331c9f-9643-4439-89bc-2384e6106808
md"""
!!! note
	* Slicing is not a compression, it is a blind reduction of the data content of an image.  
    * Low-rank approximation is a legitimate compression technique where the most significant features are retained.
 
"""

# ╔═╡ 51a7aa40-413d-4aff-b8c3-93bafc8ff497
md"""#
### More Examples on Applications of SVD

Let us go back to the first image with $8 \times 8$ pixel resolution, with its grayscale format:

"""

# ╔═╡ 31c73f74-331e-482f-b15d-fa882475df4f
gr_imgc1 = Gray.(imgc1)

# ╔═╡ 6100cf65-4d8a-489d-bbce-ce930e90c769
gr = channelview(gr_imgc1)

# ╔═╡ debe7ffd-3911-4127-afd8-de29f964dc4e
Ugr,σgr,Vgr = svd(gr, full = false);

# ╔═╡ 7fa7137c-b3e5-4bcf-9d6e-a8e3ce76a76e
gr_rank4 = Ugr[:,1:4] * Diagonal(σgr[1:4]) * Vgr[:,1:4]';

# ╔═╡ 7f2e64c6-e88c-4753-b368-c1f6256e6675
gr_rank3 = Ugr[:,1:3] * Diagonal(σgr[1:3]) * Vgr[:,1:3]';

# ╔═╡ a69c62ab-4cb8-4066-a9ad-bfbbd628d07e
gr_rank2 = Ugr[:,1:2] * Diagonal(σgr[1:2]) * Vgr[:,1:2]';

# ╔═╡ ba2b95f5-c6f3-4f56-a9b1-cc748cc8f9f1
begin
gr_imageO = plot(gr_imgc1, xticks = 1:8, yticks = 1:8, xlim = (1,8), ylim = (1,8), title = L"Original");
gr_image4 = plot(Gray.(gr_rank4), xticks = 1:8, yticks = 1:8, xlim = (1, 8), ylim = (1,8), title = L"Rank-4");
gr_image3 = plot(Gray.(gr_rank3), xticks = 1:8, yticks = 1:8, xlim = (1, 8), ylim = (1,8), title = L"Rank-3");
gr_image2 = plot(Gray.(gr_rank2), xticks = 1:8, yticks = 1:8, xlim = (1, 8), ylim = (1,8), title = L"Rank-2");
plot(gr_image2, gr_image3, gr_image4, gr_imageO, layout= (2,2), aspect_ratio = 1)
end

# ╔═╡ b5ce196c-85a6-4355-87a5-f65c53f109f0
md"""#
##### Another Example on SVD:

Assume we have the following data set cast into a $(21 \times 21)$ matrix form as given below: 

"""

# ╔═╡ 35dd4722-49e9-4828-8d50-1feda8a454d3
x_vals = [-10:1:10;]

# ╔═╡ ee28d927-bbb5-4f05-9d1c-09aa4c3d16fa
y_vals = [-10:1:10;]

# ╔═╡ 529a32db-8f71-4b03-9826-f132ac28a4f6
z_vals = 2*x_vals*y_vals'; # OR z_vals = [2*x*y for x in -10:10, y in -5:5]

# ╔═╡ f64e1d5b-efe1-4019-8227-9c43ecd5b648
begin
x_d = range(-10,10,41) # OR -10:1:10
y_d = range(-10,10,41)
f(x_d,y_d) = 2 * x_d * y_d
plot(x_d, y_d, f, xlabel =L"x", ylabel = L"y", zlabel = L"2xy",st=:surface, camera = (30, 20))
end

# ╔═╡ ca9e9b27-a95c-4faf-930e-80b8163457dd
begin
	X_vals = [x_vals for x_vals in x_vals for y_vals in y_vals] # create mesh of size 21 x 21. These are x values of all the mesh points
	Y_vals = [y_vals for x_vals in x_vals for y_vals in y_vals] # create mesh of size 21 x 21. These are y values of all the mesh points
	Z_vals = 2*X_vals.*Y_vals
	scatter3d(X_vals, Y_vals, Z_vals,camera = (30, 20), xlabel =L"x", ylabel = L"y", zlabel = L"2xy", legend = false)
end

# ╔═╡ 6f08eaba-5562-4162-bc51-6132581df46d
Uz,σz,Vz = svd(z_vals, full = true); # Note that U and V are orthogonal matrices: U^T * U =V^T * V = I

# ╔═╡ e6f2debc-122c-4955-96bc-1261e9a5a964
z_rank1 = σz[1] * Uz[:,1] * Vz[:,1]'

# ╔═╡ 615af235-c8fa-4f57-b26d-6c9d6109f41f
norm(z_vals - z_rank1)

# ╔═╡ 7d24e4be-7f07-405d-8134-97d48c8f323b
md"""

!!! notice
	* The $(21 \times 21)$ matrix has been accurately represented by rank-1 ${\bf U}[:,1] {\bf σ}[1] {\bf V}[:,1]'$ matrix: $\bf (21 \times 21 = 441)$ vs $\bf (21 + 1 + 21 = 43)$
    * The norm of a $(M \times N)$ matrix is defined by $\sum_{i=1}^M{\sum_{j=1}^N {|a_{ij}|^2}}$. So, the sum of squared differences is exteremly close to zero ($2.9 \times 10^{-14}$).
 
"""


# ╔═╡ b2901287-b4c7-46b2-998b-1e1c74e95b56
md"#
##### Another example:

Let us apply the SVD to the simplest example of white screen of $6 \times 6$ pixels and see if it will result in a similar answer that we have suggested:

"

# ╔═╡ e3136a86-0bd5-43a6-b5c2-00efc3622502
white_screen = [1 1 1 1 1 1;
				1 1 1 1 1 1;
				1 1 1 1 1 1;
				1 1 1 1 1 1;
				1 1 1 1 1 1;
				1 1 1 1 1 1]

# ╔═╡ f30c0562-8819-4125-b0e0-8cb394c82b05
md"
**What can you say about this matrix:**

* rank-1; all columns are dependent to the first one,
* singular; the determinant is zero,
* represented by a 6-column vector of ones times a 6-row vector of ones,

**What do you expect from the SVD?**

* One dominant singular value,
* one left ($\bf u_1$) and one right ($\bf v_1$) 6-singular vectors
"

# ╔═╡ d138e35e-8e45-43e5-a231-9bb92af3ef0c
U1,σ1,V1 = svd(white_screen, full = true);

# ╔═╡ 8c130ce9-564d-4658-93b5-e1d93f9212fe
white_screen1 = σ1[1] * U1[:,1] * V1[:,1]';

# ╔═╡ 0504a8be-4e7b-4713-b7db-6f434eb9ab33
md"""#
## Brief Intro to factorization and SVD

[**_Factorization_**] (https://www.youtube.com/watch?v=or6C4yBk_SY) is one of the fundamental topics in Matrix representations in Linear Algebra and there are five fundamental and popular factorizations of matrices, which are given below[^1]:

*  $\bf PA = LU$ Factorization 
  - Requirement: $\bf A$ is invertible; $\bf P$ does all of the row exchanges
  - Applications: Elimination for solving Linear System of Equations (LSE)
*  $\bf A = QR$ Factorization - $\bf Q$ is orthogonal ⇒ ${\bf Q}^T \bf Q = I$
  - Requirement: $\bf A$ has independent columns.
  - Applications: Least Square solutions, e-value and e-vector computations
*  $\bf S = Q \Lambda Q^T$ Factorization - $\bf Q$ is orthogonal
  - Requirement: $\bf S$ is real and symmetric, ${\bf S}^T = {\bf S}$
  - Applications: 
*  $\bf A = X \Lambda X^{\rm -1}$ Factorization
  - Requirement: $\bf A$ is square and must have $n$ linearly independent e-vectors
  - Applications:
*  $\color{red} \bf A = U \Sigma V^T$ Factorization - $\bf U$ and $\bf V$ are orthogonal
  - Requirement: None
  - Applications: Many

[^1] [Matrix Factorization] (https://math.mit.edu/~gs/linearalgebra/lafe_Matrix.pdf) by Gilbert Strang
"""

# ╔═╡ c5d311f5-bf47-447d-bfe3-31b5e7f8851b
md"""#

- For **Markov Processes**, e-values and e-vectors played key roles as the Markov matrices are square matrices. Let us remember the equations:
${\bf A x} = \lambda {\bf x} \Rightarrow \bf {A X = X \Lambda}$ 
${\bf A} \begin{bmatrix} \vdots & \cdots & \vdots \\
									{\bf x}_1 & \cdots & {\bf x}_n \\
									\vdots & \cdots & \vdots \end{bmatrix} =
							\begin{bmatrix} \vdots & \cdots & \vdots \\
									{\bf x}_1 & \cdots & {\bf x}_n \\
									\vdots & \cdots & \vdots \end{bmatrix} \begin{bmatrix} \lambda_1 & 0 & 0 & \cdots \\
									0 & \lambda_2 & 0 & \cdots \\
									\vdots & \vdots & \ddots & \cdots \\
									0 & 0 & \cdots & \lambda_r \end{bmatrix}$ 
where $\bf X$ and $\bf \Lambda$ are matrices of e-vectors and e-values.
- Most data science applications, matrices are not square, they are rectangles of numbers.


- **Singular Value Decomposition**, although it is more than a century old, has become extremely popular in the last 20-30 years, due to
  - its applicability for general matrices and 
  - a data centeric world during this time period.

!!! note \"Mathematical background of SVD\"
	There are many videos and texts avilable on the internet, so those who are interseted in the details of the theory may refer to those resources.

Let us start with a brief and nice introduction of SVD as to where and how it is used in the following video by Steven L. Brunton from University of Waghington:
"""


# ╔═╡ 1af33d13-e9f9-4d97-9b49-85d2bde16ee7
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/gXbThCXjZFM" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 7e8625e2-c407-4b53-94e1-e527719114be
md"""#

!!! important \"What is SVD?\"
    **SVD is a factorization of rectangular matrices into its significant components:** \
    $\bf A = U \Sigma V^{\rm T}$ 
	where ${\bf U}$ and ${\bf V}$ are orthogonal matrices with **_left_** and **_right_** **_singular vectors_**, and $\bf \Sigma$ is a diagonal matrix of **_singular values_**.

Orthogonal matrices ⇒ $\bf U^{\rm T} U = I$ and $\bf V^{\rm T} V = I$

writing explicitely

${\bf A V = U \Sigma \Rightarrow  A} \begin{bmatrix} \vdots & \cdots & \vdots \\
									{\bf v}_1 & \cdots & {\bf v}_r \\
									\vdots & \cdots & \vdots \end{bmatrix} =
							\begin{bmatrix} \vdots & \cdots & \vdots \\
									{\bf u}_1 & \cdots & {\bf u}_r \\
									\vdots & \cdots & \vdots \end{bmatrix} \begin{bmatrix} \sigma_1 & 0 & 0 & \cdots \\
									0 & \sigma_2 & 0 & \cdots \\
									\vdots & \vdots & \ddots & \cdots \\
									0 & 0 & \cdots & \sigma_r \end{bmatrix}$ 

"""

# ╔═╡ f5ab9e64-a428-43e2-902a-3e250df09976
md"

**For geometric interpretation**, let us see how each component transforms a vector $\bf x$:

$\bf A x = (U \Sigma V^{\rm T}) x$ 

Note that 
*  $\bf U$ and $\bf V$ are orthogonal matrices of **singular vectors**,
  - do not change the length of the vector ($\|{\bf V}^T \bf x\| = \|\bf x\|$)
  - rotate the vector
*  $\bf \Sigma$ is a diagonal matrix of **singular values**,
  - scales the rotated vector.

"

# ╔═╡ c26b13c7-ef61-4c5f-9afd-27a095ffafe6
imresize(load("SVD_Geometric.png"), (300,300))

# ╔═╡ f5f3ecaf-d4e0-4f40-9452-fb131355babe
md"
**Example:** Let
${\bf A} = \begin{bmatrix} 5 & 3 & 0 \\
						   3 & 5 & 0 \end{bmatrix}$

Find the singular values and vectors of this matrix.

**Solution:**
* Singular values of $\bf A$ are the square root of the eigenvalues of ${\bf A}^T \bf A$;
* Right singular vectors ($\bf V$) are the eigenvectors of ${\bf A}^T \bf A$. 
  -  ${\bf A}^T \bf A$ is a **S**ymmetric matrix ⇒ e-vectors are orthonormal ⇒ $\bf S = {\color{red} Q} \Lambda {\color{red} Q^{\rm T}}$
  -  Columns of $\bf Q$ are the orthonormal e-vectors
$({\bf A}^T \bf A) = (U \Sigma V^{\rm T})^{\rm T} (U \Sigma V^{\rm T}) = (V \Sigma U^{\rm T} U \Sigma V^{\rm T}) = {\color{red} V} \Sigma^{\rm 2} {\color{red} V^{\rm T}}$

${\bf A^{\rm T} A} = \begin{bmatrix} 5 & 3 \\
						   3 & 5 \\
		 				   0 & 0 \end{bmatrix}
		 \begin{bmatrix} 5 & 3 & 0 \\
						   3 & 5 & 0 \end{bmatrix} =
		 \begin{bmatrix} 34 & 30 & 0 \\
						   30 & 34 & 0 \\
		 					0 & 0 & 0 \end{bmatrix} ⇒ 
		{\bf \Sigma} = \begin{bmatrix} 8 & 0 \\
						   0 & 2 \end{bmatrix}$

${\bf v}_1 = \begin{bmatrix} 1/\sqrt{2} \\ 1/\sqrt{2} \\ 0 \end{bmatrix},\;
{\bf v}_2 = \begin{bmatrix} 1/\sqrt{2} \\ -1/\sqrt{2} \\ 0 \end{bmatrix} \Rightarrow
{\bf V}^T = \begin{bmatrix} 1/\sqrt{2} & 1/\sqrt{2} & 0 \\
							1/\sqrt{2} & -1/\sqrt{2} & 0 \end{bmatrix}$ 

$\bf A V = \Sigma U \Rightarrow U = \begin{bmatrix} 1/\sqrt{2} & 1/\sqrt{2} \\
											1/\sqrt{2} & -1/\sqrt{2} \end{bmatrix}$
"

# ╔═╡ 496d2225-f029-4b5b-8be6-9004f62fa92f
example1 = [5 3 0; 3 5 0]

# ╔═╡ 31175b40-5d99-4585-a3c8-f05e30883886
u2, sig2, v2 = svd(example1, full = false);

# ╔═╡ 5eab635d-4e3d-4f88-808c-28e37c33a1ba
function camera_input(;max_size=150, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)

	const span = currentScript.parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end

# ╔═╡ 03130a6d-6690-47d8-8d69-8af82d4a9098
@bind webcam_data1 camera_input()

# ╔═╡ 0d1684f6-6fd1-4060-93e0-14e52c6152dd
function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ f7d8856d-7dee-46f4-b9e0-dd40487c6c6f
myface = process_raw_camera_data(webcam_data1)

# ╔═╡ f6694054-dc86-49b5-9314-61fa76ae47e1
[
	myface              myface[   :    , end:-1:1]
	myface[end:-1:1, :] myface[end:-1:1, end:-1:1]
]

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
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
QuartzImageIO = "dca85d43-d64c-5e67-8c65-017450d5d020"
TestImages = "5e47fb64-e119-507b-a336-dd2b206d9990"

[compat]
ColorVectorSpace = "~0.9.9"
Colors = "~0.12.8"
DataFrames = "~1.3.4"
FileIO = "~1.15.0"
HypertextLiteral = "~0.9.4"
ImageIO = "~0.6.6"
ImageShow = "~0.3.6"
Images = "~0.25.2"
LaTeXStrings = "~1.3.0"
Plots = "~1.32.0"
PlutoUI = "~0.7.40"
QuartzImageIO = "~0.7.4"
TestImages = "~1.7.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "e41a4576b90c69c5617f1f74f97c6911ce66fb53"

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
git-tree-sha1 = "78bee250c6826e1cf805a88b7f1e86025275d208"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.46.0"

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
git-tree-sha1 = "5158c2b41018c5f7eb1470d558127ac274eca0c9"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.1"

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
git-tree-sha1 = "94f5101b96d2d968ace56f7f2db19d0a5f592e28"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.15.0"

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
git-tree-sha1 = "cf0a9940f250dc3cb6cc6c6821b4bf8a4286cf9c"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.66.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "2d908286d120c584abbe7621756c341707096ba4"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.66.2+0"

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
git-tree-sha1 = "a6d30bdc378d340912f48abf01281aab68c0dec8"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.7.2"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "59ba44e0aa49b87a8c7a8920ec76f8afe87ed502"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.3.3"

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
git-tree-sha1 = "8b251ec0582187eff1ee5c0220501ef30a59d2f7"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.2"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "342f789fd041a55166764c351da1710db97ce0e0"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.6"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "124626988534986113cfd876e3093e4a03890f58"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.12+3"

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
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

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
git-tree-sha1 = "64f138f9453a018c8f3562e7bae54edc059af249"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.4"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "076bb0da51a8c8d1229936a1af7bdfacd65037e1"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.2"

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
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "41d162ae9c868218b1f3fe78cba878aa348c2d26"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.1.0+0"

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
git-tree-sha1 = "ae6676d5f576ccd21b6789c2cbe2ba24fcc8075d"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.5"

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
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

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
git-tree-sha1 = "f6cf8e7944e50901594838951729a1861e668cb8"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.2"

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
git-tree-sha1 = "3f9b0706d6051d8edf9959e2422666703080722a"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.32.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "a602d7b0babfca89005da04d89223b867b55319f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.40"

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
git-tree-sha1 = "dfec37b90740e3b9aa5dc2613892a3fc155c3b42"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.6"

[[deps.StaticArraysCore]]
git-tree-sha1 = "ec2bd695e905a3c755b33026954b119ea17f2d22"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.3.0"

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
deps = ["Adapt", "DataAPI", "StaticArraysCore", "Tables"]
git-tree-sha1 = "8c6ac65ec9ab781af05b08ff305ddc727c25f680"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.12"

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
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "70e6d2da9210371c927176cb7a56d41ef1260db7"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.1"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

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
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

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
# ╟─5504aec1-ecb0-41af-ba19-aaa583870875
# ╟─cb5b4180-7e05-11ec-3b82-cd8631fc57ba
# ╟─98ddb325-2d12-44b5-90b6-61e7eb55bd68
# ╟─1c5063ab-e965-4c3b-a0d9-7cf2b272ad48
# ╟─b1eefcd2-3d91-42e5-91e8-edc2ed3a5aa8
# ╟─0c7b5d17-323f-4bc7-8495-c6507647a703
# ╟─0c2bf16a-92b9-4021-a5f0-ac2334fb986a
# ╟─3c474013-48d1-44e5-bfad-6a1f9b542b3c
# ╟─371fc8fa-6866-4e62-93c3-58469f22a5d8
# ╠═bdcf9a8d-2204-4d79-8319-e3b6df8c5446
# ╠═065e786d-c6d6-400b-a47d-f0d194fce920
# ╟─fe255021-3935-44dc-85e9-bedd6f1360eb
# ╟─19cad43b-de3a-4922-a55a-56a192aca919
# ╟─3b117d55-f043-4deb-a5d3-66078ace53db
# ╟─c4d7eeef-6528-4cb4-8fcd-887eb7f1f091
# ╠═bcc8866b-5f3e-4a0e-a561-a06c80cc974a
# ╠═5c9353c9-9926-4630-948e-dfb28060a66a
# ╟─b929fc46-a0c5-41b5-aa12-f77f136ab3e0
# ╠═f51d50a6-3253-4c41-9f1a-445d28582a4a
# ╟─84f64dbf-3cff-413a-88c9-ad89a372a7d2
# ╟─ef2d3cb6-aa10-4abb-b4ea-e96768056ebb
# ╠═0a2fdc0e-99d7-42be-9995-f85b0376b81d
# ╠═ede06a6c-468e-4c26-9467-ab07a17717fd
# ╠═7090909f-809b-4ef9-a86d-50ac512ab455
# ╟─ac1831f6-d7e1-47ac-88ab-f4e3523fa07b
# ╟─906b0d37-934e-4aee-aa12-f49b56a62d4b
# ╠═cf299aac-531d-41cb-ae79-ee5fcc0ff011
# ╠═81ee7e6b-0855-4a28-b6b9-f50e0b38e741
# ╠═cf0a3a7a-613c-4174-ae2b-1133a604115c
# ╠═11bdc921-d39e-405a-93ee-002b986a2bef
# ╠═53017ff5-8e06-4e23-b027-ee49257aff6b
# ╠═cc17fd62-e5c2-4a0f-b8dd-506941951803
# ╠═5314ec4c-d0ae-4290-b9d6-26eec26e104d
# ╠═8de9608c-472d-40a0-8ab2-ba80463c74d8
# ╠═991d9d71-c85f-4fdb-9c9b-b13138c2a692
# ╟─58678b29-d37e-4d15-a5da-8a94632900c0
# ╟─4402e8ea-c9c6-46fa-8e54-43c94f954148
# ╟─1239b181-6331-4569-8e30-e8831e3a8ff5
# ╟─1f0b8e56-eeb5-462b-a2e6-e7ae89665fbd
# ╟─e64549f5-15af-4595-a901-c2016eebc80c
# ╟─a078fb5c-2c7b-4893-ba84-72fa05f49e62
# ╟─6795cb2d-86f5-48d3-bad0-5f0dc50c550f
# ╠═82c94279-7723-400e-850b-0c47fe48ea39
# ╟─138ba645-cea3-4295-8cb4-f127255aaa3f
# ╠═a3f0c93e-97d3-47b4-8e6c-5417ee77c3e0
# ╠═608d6169-b6f5-4ce0-a814-d2e69c845e90
# ╠═ed4eef8f-ad6b-42f0-b38d-4f5931a33719
# ╠═6ec103a2-0737-4e58-9f03-39317ffd8b0a
# ╟─688838c0-85e8-426f-bd50-8c953da83d44
# ╟─91149d9e-3c69-4f52-af82-654aaf8eba98
# ╟─fffd5112-314b-4c0f-90f4-15e5cc483b4c
# ╠═181512ad-360c-4f3f-8bde-41881f2d886f
# ╠═55d7449c-0b45-46a3-aeb0-c19b3af29cda
# ╟─20d53b4f-7c16-43e9-8818-de16765aa6a3
# ╟─eeea9419-ee50-4335-b682-6e7cdb28abff
# ╠═7ae0d9ab-c9e5-4d4c-8aaf-39df1548c2ca
# ╠═19d90c1a-196d-495a-b487-63c73086639a
# ╠═cb054f29-a7d1-42bc-a904-6a4afd61b1d7
# ╟─46b2064a-a563-404f-b9ed-5f935fd2baf3
# ╠═77e82a01-f253-4d4b-9555-5f0f0170e23e
# ╠═c37b9b9c-4e85-45d8-909d-a95360e92b2d
# ╟─43fd2bdd-8fcf-4eba-a638-6a6f6ee7b720
# ╟─2b9be8d2-b389-4c8b-a7ef-70304fe7b45f
# ╟─075ba59d-02fc-4015-83f7-801ca7bb8fc9
# ╟─386a3d57-3188-4f52-9be6-59b3c0abc207
# ╟─179cd26c-dbee-43e4-9964-aa20beecf8b5
# ╠═6f7bd689-a558-4287-b25a-15ab016e7b41
# ╟─44ec39d6-e39b-4912-aa20-b07b2c3a41b2
# ╟─abbc6066-6b4a-462f-aa57-7cfb3b7622b1
# ╟─92139ad8-970b-4712-82e5-dfc8a4271c62
# ╟─c8912b35-85c4-4fa9-bc1e-da54812b681b
# ╟─13630b66-ad86-4873-811f-2a4d82d630b6
# ╠═fd5b6697-09a0-43f5-ba08-a9e8cd167802
# ╟─ebeb4bbf-3192-417c-a853-d8f1f44551e1
# ╟─c65c827f-ba05-48d6-a868-8a8fbb1e089e
# ╠═e2583179-509e-4f0a-a6ef-715eb0d9f28e
# ╟─792b3254-4d90-4b2c-a0b6-ed324ff87594
# ╠═b3a1f41f-1b08-4de7-b44a-e3239c313336
# ╠═7a5bf0e8-ab35-4e13-81fd-1d0862178281
# ╟─cd4adf49-b052-4bf1-8c3f-9348da88666f
# ╟─b979ac94-fb8a-4575-8b5f-0328128a3ad0
# ╟─b763d610-f777-4d28-85b6-89f1e342796e
# ╠═e5051924-1c30-48cf-8568-bfea56957a8e
# ╠═96f3162a-4a1a-46b4-8ba2-fccc00ff41b4
# ╠═d520c2bb-7b77-4fba-944b-6ebe44f3cb17
# ╠═ef115594-908d-4f7a-a199-108a0239cdc5
# ╠═fe030af9-6868-4ef4-b858-49ed33d3a9db
# ╟─77a0d2ff-ca16-4da6-ae52-acbb5f194262
# ╟─a8d4331b-b2b2-4f20-8d80-75213829067b
# ╠═39a3e51e-8bc9-4a55-9bb4-460f750ae0d6
# ╠═12ec3ef3-491c-41c8-9e4c-e87445b71a7a
# ╠═fa4945ec-f1f3-4ea1-8c06-0a98c673c7d0
# ╟─5ce07a9d-6817-4be4-ac4a-74db4e821aa3
# ╟─f8cef7e7-ba70-4220-933c-f0d91b1ec080
# ╠═456df6e3-b4cb-4a6b-9b7c-36998859d95a
# ╠═b984d4e3-b240-45fb-89b4-6795454b4048
# ╟─e4894761-fcbb-421f-b72f-b542a9ee5ac9
# ╟─263953a3-7af9-4b7e-ba44-8d6bbef83eb0
# ╠═713f95f2-f406-4f3b-8d3c-c3c221f8b2b0
# ╟─3de20f99-af1c-413a-b8f4-dc2d259ece3a
# ╠═52f94555-b54b-4e87-894c-d147ee3525ed
# ╠═18f2a37a-dfb7-49aa-9788-b174b15f4e80
# ╠═85a282f8-83c7-4cd9-9329-a3d6ebcfa77e
# ╠═165e212a-4037-455e-9b76-f605bd7fde37
# ╠═5859511e-55e8-4e77-b208-39d2c8151de2
# ╠═013b7ebc-4201-4d42-ae02-cacdc2d98908
# ╟─238a92e6-7d7d-441c-9fbb-7d658981b5ea
# ╟─0ac852a2-446f-4756-b059-f30fe112a3cc
# ╠═f7e8eec5-2867-4053-8767-91839f6a5c56
# ╠═9742c131-55ad-47da-b600-1a622b90a152
# ╠═307a0345-2621-430a-802e-c4150f289436
# ╠═b52f4f54-66a8-41c4-9afc-c72a25e30b23
# ╠═ebe4c9de-96fb-456a-973b-9222238bce7e
# ╟─ce0e742a-1252-4a97-b70b-4601c7cc6cf3
# ╟─28227637-f954-4fb9-a286-28dbcc33950e
# ╠═757ca38f-5070-4c77-b792-d162b3254a12
# ╠═0d69ae64-e358-495a-8f60-418f7f6e4e0d
# ╟─314fd69f-4a2b-49f3-9ae4-ccdaf7c47482
# ╠═0947c623-7ea2-4ecc-a971-adbf5982fd0d
# ╟─a75b0884-4fb1-4406-8b4c-b9ff4d1de813
# ╠═fcc74341-e5c6-498f-a183-37e0fa643953
# ╠═398eb472-6a59-4a1c-9887-1fed74fd728c
# ╟─ac80f19d-f5ea-46ab-a774-1f8b6ae95c7d
# ╠═43cf5958-d60b-4a60-9486-5f2d6ab2de01
# ╠═827ce586-aebb-401c-bf47-72a70f577f42
# ╟─33968a86-9c0d-42c6-82d4-2be91e50602c
# ╟─613c9159-422a-4557-b17d-805e4d122f35
# ╟─f611385d-542a-47f9-ae76-24fe7f34cb49
# ╟─409914ae-eae9-44ef-ba01-29014d623438
# ╟─913d846f-c3d1-411e-98a5-d5d5f40953af
# ╠═f253176d-02b6-4c8b-aac7-28ecd5d1a59f
# ╟─fcf562c2-571f-402d-b2b5-c642420dd37f
# ╠═170d6bc5-be4d-4979-a684-2aa807d86666
# ╠═3e84c0dd-1202-441e-b83f-87fe878ad1f7
# ╠═45c0b433-2710-4be9-937e-aae9821fa6f3
# ╠═a31a45f8-549b-4ee5-8b59-fb6fcd5b0c3f
# ╠═034ea1d5-99f5-4ed1-aa69-4c2d52a06a6f
# ╟─dc764f84-f184-4b3b-992c-ff49878d5d11
# ╠═f9cc757b-225c-4571-9e83-56540ef45653
# ╟─8546c7c6-beb0-48a8-aaf2-063643eb5a90
# ╠═03130a6d-6690-47d8-8d69-8af82d4a9098
# ╠═f7d8856d-7dee-46f4-b9e0-dd40487c6c6f
# ╠═f6694054-dc86-49b5-9314-61fa76ae47e1
# ╟─9814b4cd-e1d8-4abf-a7a0-8ac4fe84b6f8
# ╠═7109999d-ead6-4708-bd4e-03c4326acf98
# ╠═052883ee-3ad8-4881-9fc4-419b29c6d5a1
# ╠═5bb58608-ed31-4aad-9457-7e18e9e4ef93
# ╠═c681f722-72e0-4b58-b33b-80545d698522
# ╠═684ddb18-178d-457b-911d-a556c0b123f0
# ╠═35936fc1-f024-4709-ada4-4e7987b650f2
# ╠═ab3e3ba6-36d8-4c40-b415-5db1ab83fdb9
# ╠═893cbef4-dc64-44b5-8bdb-d8bddd0ae1ca
# ╟─4826fae2-82f3-417b-be90-2c9741666f37
# ╠═984031d6-80b4-4fe5-8f9f-9375290b1951
# ╠═960e6ae6-042d-41af-9c7b-a7057013c3f2
# ╠═da605dae-4c51-4afd-b270-d3282fa06f35
# ╠═71ac7102-18cb-44ec-a0c1-e0101e3181a6
# ╠═0c525731-e5e4-4f75-80de-d30fcc03ebbc
# ╟─d5d2a909-a172-4352-aafd-08d3c1cf56f4
# ╟─3fb56e0c-d551-4754-8950-32451eb88fa9
# ╠═83b5ad21-ec8a-49c3-85b7-ed9d94dba742
# ╠═11b57734-cf9e-450e-a7df-0639414a05a8
# ╟─24b3970f-e78b-4b55-8f43-5d4898fbc935
# ╠═9dd09625-482b-44dc-a641-13a8150815f9
# ╠═33fdfd65-0950-4cc2-9200-69b7dbd35efd
# ╟─f630e152-98a7-48f8-a355-ea9ebe1502f0
# ╠═a7a46218-6ca9-4041-a9f1-7edc6ef5e458
# ╠═bcaf90ce-6df3-4e39-ae30-280d5a3f2467
# ╟─04054ed2-83a1-4ea3-a183-5787f61569dd
# ╠═e38ac9e6-6fb7-426d-9b99-d51dacb8a106
# ╠═83af63ef-6d6a-46ab-87bb-e8e957e3b9da
# ╟─b979cadf-50a5-4192-a412-dbf8f005560d
# ╠═271dfb86-a875-48c7-a14b-c6fbf8c1566e
# ╠═4442483a-9754-437b-aa90-69918fed6da7
# ╟─733ecebc-19b2-4789-aacf-554544b78255
# ╠═4c3705f5-814c-4919-9584-62d38db5ebe9
# ╠═fd5ed657-afae-43c0-827e-6390653e8f64
# ╠═6b9fea12-3105-48ed-93b6-5e78182c1a4d
# ╠═3231ec8a-2223-4b4a-bab8-44a450d87ac4
# ╠═c38cb55b-47c4-4228-b668-a13e25bc43b6
# ╠═f6fa8f90-abfd-403a-9855-46d613223834
# ╠═395fa074-6a6a-4e30-9ed9-2df1bd7ed2cd
# ╠═012c5d56-78af-4aa5-948d-cf678765e56a
# ╠═d3e6926e-3ed8-4a4a-a10d-9af52c1297c7
# ╠═b68be486-ff5c-422d-9328-9a3571feb70a
# ╠═007088c5-51cc-4ed5-951d-b6acda52a0ad
# ╟─ea6148bc-08d1-4dd0-a7a7-dc4f7a310d45
# ╠═78c521dd-36fd-4904-ba2c-faf9e617447f
# ╟─654ddb3a-11c4-4033-994d-9a038979b677
# ╟─1e46f093-982a-45cf-aa0a-25ddbfd3bd51
# ╠═5c292b05-5d5d-43ea-8ac2-9c6578d14d86
# ╟─bd331c9f-9643-4439-89bc-2384e6106808
# ╟─51a7aa40-413d-4aff-b8c3-93bafc8ff497
# ╠═31c73f74-331e-482f-b15d-fa882475df4f
# ╠═6100cf65-4d8a-489d-bbce-ce930e90c769
# ╠═debe7ffd-3911-4127-afd8-de29f964dc4e
# ╠═7fa7137c-b3e5-4bcf-9d6e-a8e3ce76a76e
# ╠═7f2e64c6-e88c-4753-b368-c1f6256e6675
# ╠═a69c62ab-4cb8-4066-a9ad-bfbbd628d07e
# ╟─ba2b95f5-c6f3-4f56-a9b1-cc748cc8f9f1
# ╟─b5ce196c-85a6-4355-87a5-f65c53f109f0
# ╠═35dd4722-49e9-4828-8d50-1feda8a454d3
# ╠═ee28d927-bbb5-4f05-9d1c-09aa4c3d16fa
# ╠═529a32db-8f71-4b03-9826-f132ac28a4f6
# ╠═f64e1d5b-efe1-4019-8227-9c43ecd5b648
# ╠═ca9e9b27-a95c-4faf-930e-80b8163457dd
# ╠═6f08eaba-5562-4162-bc51-6132581df46d
# ╠═e6f2debc-122c-4955-96bc-1261e9a5a964
# ╠═615af235-c8fa-4f57-b26d-6c9d6109f41f
# ╟─7d24e4be-7f07-405d-8134-97d48c8f323b
# ╟─b2901287-b4c7-46b2-998b-1e1c74e95b56
# ╟─e3136a86-0bd5-43a6-b5c2-00efc3622502
# ╟─f30c0562-8819-4125-b0e0-8cb394c82b05
# ╠═d138e35e-8e45-43e5-a231-9bb92af3ef0c
# ╠═8c130ce9-564d-4658-93b5-e1d93f9212fe
# ╟─0504a8be-4e7b-4713-b7db-6f434eb9ab33
# ╟─c5d311f5-bf47-447d-bfe3-31b5e7f8851b
# ╟─1af33d13-e9f9-4d97-9b49-85d2bde16ee7
# ╟─7e8625e2-c407-4b53-94e1-e527719114be
# ╟─f5ab9e64-a428-43e2-902a-3e250df09976
# ╠═c26b13c7-ef61-4c5f-9afd-27a095ffafe6
# ╟─f5f3ecaf-d4e0-4f40-9452-fb131355babe
# ╠═496d2225-f029-4b5b-8be6-9004f62fa92f
# ╠═31175b40-5d99-4585-a3c8-f05e30883886
# ╟─5eab635d-4e3d-4f88-808c-28e37c33a1ba
# ╟─0d1684f6-6fd1-4060-93e0-14e52c6152dd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
