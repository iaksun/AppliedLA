### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ e868136f-4c18-42db-9bbd-ef0c1466f1da
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
	using Plots
	using LaTeXStrings
	using LinearAlgebra
end

# ╔═╡ 1f3351f6-116b-4743-9ec8-d9854d8cfbf2
using Images,TestImages # Images and TestImages packages will be needed

# ╔═╡ 7fcf79e2-7157-4ec6-99c0-e5b03483afd4
using Shuffle

# ╔═╡ 3c7c7762-71be-4a81-b743-139be12bf2ab
begin
	using DataFrames
	using XLSX, CSV
end

# ╔═╡ 58c158d7-3627-4d08-a3b8-dc5a1370e369
using MLDatasets

# ╔═╡ fc72e1e1-c288-428b-8a29-d61bcdbdad4d
using DataStructures # To use counter

# ╔═╡ a538d63a-39d9-11ed-1a9d-41c88dfdf225
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 9255470e-7999-4286-a95a-9e2626bb12ec
struct TwoColumn{A, B}
	left::A
	right::B
end

# ╔═╡ 933adf04-0244-41c0-b34d-11b482ecea9f
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

# ╔═╡ cabbc51e-82b1-4c1d-b2d0-1c9c3b8fc5fa
html"<button onclick='present()'>present</button>"

# ╔═╡ 53de0150-3d9e-4262-9a20-29643bd25cfe
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

# ╔═╡ fae02d8e-2a2a-4cf5-8a03-7e37a1d5b5be
md"""# Lecture - 3: Clustering

### Content 

> ##### 3.1. Definition & Applications

> ##### 3.2. A Clustering  Objective


> ##### 3.3. The k-means Algorithm

---
"""

# ╔═╡ d49a44bd-fe3e-4f6b-a0d7-37f5062b1291
md"""# Clustering [^1]

### Simply put, 
#### $\qquad -\;$ clustering is to place observations that seem similar 
#### $\qquad \quad \;$ within the same cluster.

### Definition

#### $\qquad -\;$ Collecting data into groups or clusters 
#### $\qquad -\;$ Clusters are supposed to be close to each other,
#### $\qquad \quad \;$ in some sense of distance
\

#### Mathematical

#### $\qquad -\;$Group $N$ vectors (${\bf x}_1,\cdots,{\bf x}_N$) into $k$-groups or clusters,
#### $\qquad \quad$ with the vectors in each group close to each other.

\

[^1] [Introduction to Applied Linear Algebra: Vectors, Matrices, and Least Squares] (https://web.stanford.edu/~boyd/vmls/vmls.pdf), Stephen Boyd and Lieven Vandenberghe, Cambridge University Press, 2018. (You can download from the link as allowed by the Cambridge University Press)
"""

# ╔═╡ 061400c5-565a-4147-8812-26bf1a713fba
md"""#
### Applications

#### Widely used in many real-life applications like

#### $\quad -\;$ Topic Discovery: 
##### $\qquad \quad \circ \;$ Given documents with word histograms in $n$-vectors 
##### $\qquad \quad \circ \;$ Bring similar topics or genre or author  into $k$ groups

#### $\quad -\;$ Patient Clustering: 
##### $\qquad \quad \circ \;$ Given patients with their feature vectors 
##### $\qquad \quad \circ \;$ Compile them into $k$ groups of similar patients
  
#### $\quad -\;$ Costumer Market Segmentation: 
##### $\qquad \quad \circ \;$ Given costumers with the quantities of items purchased 
##### $\qquad \quad \circ \;$ Group the costumers into $k$ segments with similar patterns

#### $\quad -\;$ Student Clustering: 
##### $\qquad \quad \circ \;$ Given students with detailed grading records 
##### $\qquad \quad \circ \;$ Cluster them into $k$ groups based on their performance

#### $\quad -\;$ Many more ...

---
"""

# ╔═╡ 1a3750a2-222a-41ea-b97f-78417e1278f5
md"""
## Digression: Shuffeling, Sorting & Scatter plot
"""

# ╔═╡ d79b3cf5-f4d1-47b9-8fa3-3fcaf2f4da80
a = shuffle(1:60);

# ╔═╡ 41affc75-89a5-4977-a4b5-6c5bd4772300
sort(a, rev=false);

# ╔═╡ 7dd1ed1a-8ae7-4891-8164-eb8460223920
grades = vcat( rand(10:30, 10), rand(30:50,10), rand(50:80, 30), rand(80:100, 10));

# ╔═╡ 0d21455b-3165-4bf4-807e-19faedc28aa8
X_grades = hcat(a, grades);

# ╔═╡ 0a2fa725-7237-41b2-9ed7-51151a89b941
S_Xgrades = X_grades[sortperm(X_grades[:, 2], rev=false), :]; # sorted by the 2nd column, grades from high to low if rev=true, from low to high if rev=false.

# ╔═╡ 6c6a16ed-66bf-4c29-8b5f-4d2c50a5a56b
sortperm(X_grades[:, 2], rev=false)

# ╔═╡ c5e758c6-b474-4beb-9941-9f1d691d6079
begin
scatter(1:60, S_Xgrades[:,2], ma=0.3, size = (400,300)) # ma is for the visibility of points
plot!(legend = false, grid = true, xlims = (0,61), ylims = (0,100), xaxis = L"Student \;Number", yaxis = L"Grades")
end

# ╔═╡ a0f2dfdb-24a8-45b2-a15b-256060f7c786
md"""#
#### Draw $\;\;f(x,y) = sin(\sqrt{x^2+y^2)})/\sqrt{x^2+y^2)}\;\;\; for -10 ≤ x, y ≤ 10$
"""

# ╔═╡ 1cf2f46b-f8bc-4975-ba63-c623a314fe8f
# Review of 3D scatter plot: 
let # Remeber that all assignments in let ... end are kept local
x = y = -10:0.4:10
f(x,y) = sin(sqrt(x^2+y^2))/sqrt(x^2+y^2) # sin(r)/r for 0<θ<2π
X = [x for x in x for y in y] # create a mesh 
Y = [y for x in x for y in y] # create a mesh
scatter3d(X, Y, f.(X,Y), legend = false, size=(600,600)) # f.(X,Y) "." implies pointwise application
end

# ╔═╡ e5551c37-8f47-4feb-a2a0-e6a60e00d9a2
md"""# 
### Working with real data
##### ⇒ Student Math Performance from [UCI Machine Learning Repository] (https://archive.ics.uci.edu/ml/datasets/student+performance)

##### ⇒ Read the csv data to Data Frame
"""

# ╔═╡ ed0803f6-a56a-4458-a018-d8e5bf7c415a
df_studentdata = CSV.read("student-mat.csv", DataFrame)

# ╔═╡ e5922a31-2fdc-4da0-9ef6-0c294d73b8cf
# df_studentdata2 = DataFrame(CSV.File("student-mat.csv"))

# ╔═╡ 82235fda-8140-431c-b762-eda081ff6091
md"""
---"""

# ╔═╡ a5e9c73f-8a14-47db-adcd-0927a46d0494
md"""
### 1. Examine the data
#### Note the size, column names and their meanings
"""

# ╔═╡ d5aa1928-5bac-4ef2-8e83-10863d0845cf
size(df_studentdata)

# ╔═╡ fc63bc22-93df-42df-978c-1591422f7c81
names(df_studentdata)

# ╔═╡ a6837761-28ab-4ef3-a6e4-ace97b6a43c4
md"""#
#### Let us see what these names mean:

##### $\qquad \bf 1. \;\color{red} school:$ student's school 
##### $\qquad \quad$ binary: 'GP' - Gabriel Pereira or 'MS' - Mousinho da Silveira
##### $\qquad \bf 2. \;\color{red} sex:$ student's sex (binary: 'F' - female or 'M' - male)
##### $\qquad \bf 3. \;\color{red} age:$ student's age (numeric: from 15 to 22)
##### $\qquad \bf 4. \;\color{red} address:$ student's home address type 
##### $\qquad \quad$ binary: 'U' - urban or 'R' - rural
##### $\qquad \bf 5. \;\color{red} famsize:$ family size 
##### $\qquad \quad$  binary: 'LE3' - < or = to 3 or 'GT3' - greater than 3
##### $\qquad \quad$ $\qquad \vdots$
##### $\qquad \bf 31. \;\color{red} G1:$ first period grade 
##### $\qquad \quad \;\;$ numeric: from 0 to 20
##### $\qquad \bf 32. \;\color{red} G2:$ second period grade 
##### $\qquad \quad \;\;$ numeric: from 0 to 20
##### $\qquad \bf 33. \;\color{red} G3:$ final grade 
##### $\qquad \quad \;\;$ numeric: from 0 to 20, output target
---
"""

# ╔═╡ bce1fb56-1483-4b11-b9d3-6d9877a82a6c
md"""#
### 2. Study the columns of interest
#### Collect the columns of interest: Gradings G1, G2 and G3
"""

# ╔═╡ 1817f185-3472-41f7-bb47-4ad9b6cf0399
df_grades = df_studentdata[:,[:G1,:G2,:G3]]; # get the grades only and plot them on a 3D scatter plot. This is stil DataFrame.

# ╔═╡ f6ba7e78-1a4b-463f-914c-36235bf98dfb
M_grades = collect(Matrix(df_studentdata[:, [:G1,:G2,:G3]])); # If you put them into Matrix form OR 
# M_grades = Matrix(df_grades) OR
# hcat(df_grades[:,1], df_grades[:,2], df_grades[:,3])

# ╔═╡ 3fdf242c-0fa4-4309-a73b-159e8c6ed54f
md"""
#### Visualize, if possible, to make a sense out of the data
"""

# ╔═╡ 0701de7c-2206-4eb6-9d41-79e728f0978a
begin
scatter3d(df_grades[:,1], df_grades[:,2], df_grades[:,3], size = (500,500))
plot!(legend = false, grid = true, xlims = (0,20), ylims = (-1,20), zlims = (0,20), xaxis = L"1^{th} \;Grades", yaxis = L"2^{nd} \;Grades", zaxis = L"Final \;Grades")
end

# ╔═╡ 6b425a4f-dc3d-4f3d-b0a6-c87c05a18b0e
md"""
#### Try to interpret the results
##### $\qquad - \;$ Several students only have the 1st period grades
##### $\qquad - \;$ Some have only the 1st and 2nd period grades
##### $\qquad - \;$ Most have all the  grades and show close correlations
---
"""

# ╔═╡ f3f96732-b40e-4e84-b7d9-338e081001d8
md"""
### 3. What else?
#### Apply SVD to get a better sense of behaviours of students
"""

# ╔═╡ 597fbec4-9aed-4392-8173-8b8537424ab4
avg_x, avg_y, avg_z = (ones(size(M_grades)[1])' * M_grades) ./ size(M_grades)[1]

# ╔═╡ b4e91fd0-6bdd-4272-9810-96d4a3524577
U, σ, V = svd(M_grades, full = false); # Principle Component Analysis

# ╔═╡ 7df20338-5e02-4757-8985-c903a1e1b5db
begin
	scatter3d(df_grades[:,1], df_grades[:,2], df_grades[:,3], size = (500,500))
	plot!(legend = false, grid = true, xlims = (0,20), ylims = (-1,20), zlims = (0,20), xaxis = L"1^{th} \;Grades", yaxis = L"2^{nd} \;Grades", zaxis = L"Final \;Grades")
	xx = [0 avg_x+15*V[1,2]; 35*abs(V[1,1]) avg_x-40*V[1,2]]
	yy = [0 avg_y+15*V[2,2]; 35*abs(V[2,1]) avg_y-40*V[2,2]]
	zz = [0 avg_z+15*V[3,2]; 35*abs(V[3,1]) avg_z-40*V[3,2]]
# Vector V gives the normalized (Mag(V) =1) coordinates w.r.t. origin, hence avg + cons. * V
	plot!(xx, yy, zz, lw = 2, color = :red, xlims = (0,20), ylims = (-1,20), zlims = (0,20))
end

# ╔═╡ 76b104a0-a6f6-4786-b81f-d02c52f86121
-V[1,:], V[2,:] # Directions of PCs

# ╔═╡ 73317b75-ad8e-48d6-bee8-ea879429600f
md"""
#### ⇒ Explain how to plot the PCs
"""

# ╔═╡ 538e4b56-11e6-4abc-9bf2-2ee45716ecad
begin
	xxx = [0  0.5 0.8; 1 1 0]
	yyy = [0  0.5 0.8; 1 0 1]
	zzz = [0  0.5 0.8; 1 0 1]
	plot(xxx, yyy, zzz, lw = 2, color = [:red :green :blue], xlims = (0,1), ylims = (0,1), zlims = (0,1))
end

# ╔═╡ 66085b26-bde0-4a03-885c-5992ffca74de
md"""
>#### Strong correlation: $\large 1^{st}$, $\large 2^{nd}$ and Final Grades 
>#### Red Lines: ${\bf V}_1$ and ${\bf V}_2$ from SVD
---
"""

# ╔═╡ 727c2e74-30fb-4ae1-a6a7-f05fd49d5a68
md"""## K-means Clustering

#### It is an unsupervised machine learning method


### 1. Problem definition
##### $\quad \rightarrow \;$ For given $N$ vectors ${\bf x}_i$ ($for \;i=1,\dots,N$) in $\mathbb{R}^n$, 
##### $\quad \rightarrow \;$ assign each vector to a single cluster out of $k$ clusters

##### where $k$ (<<$N$) needs to be decided or optimized. 
\

##### In other words, you
##### $\quad \rightarrow \;$ have $N$ vectors ${\bf x}$
##### $\quad \rightarrow \;$ intend to place these vectors into $k$ clusters $G$
##### $\quad \rightarrow \;$ have a vector $\bf c$ with length $N$, 
$\large {\bf c} = \underbrace{\begin{bmatrix} \underbrace{2}_{{\bf x}_1\in G_2} & \underbrace{3}_{{\bf x}_2\in G_3} & 2 & 1 & \cdots & \underbrace{1}_{{\bf x}_N\in G_1} \end{bmatrix}}_{length \;is \;N}$
##### $\quad \quad \;\;$ holding the cluster number for each vector ${\bf x}_i$
---
"""

# ╔═╡ 369f121d-e97d-4bec-a8ce-5a111b240da4
md"""#
### 2. Solution steps 

##### ⇒ We will show the steps on a simple example, where
##### $\qquad -\;$ vectors are in 2-dimensional space (${\bf x}_i \in \mathbb{R}^2$)
##### $\qquad -\;$ the number of vectors is assumed to be 10 ($N$=10), and
##### $\qquad -\;$ the number of clusters is assumed to be 3 ($k$=3) 
##### to elucidate the terminology. 
\

##### $\quad a. \;$ Define an N-vector $\bf c$, where $c_i$ is the group number that 
##### $\quad \quad \;\;$the vector ${\bf x}_i$ is assigned to: 

${\Large \overset{Ex.}{\Rightarrow}} \;\;\large {\bf c} = \underbrace{\begin{bmatrix} \underbrace{2}_{{\bf x}_1\in G_2} & \underbrace{3}_{{\bf x}_2\in G_3} & 2 & 1 & 3 & 3 & 2 & 1 & 2 & \underbrace{1}_{{\bf x}_N\in G_1} \end{bmatrix}}_{length \;is \;10}$

##### $\quad b. \;$ Define cluster $G_j \;(for \;j=1,\dots,k)$ with the set of indices of
##### $\quad \quad \;\;$ $\bf x$ corresponding to group $j$;

$\large G_j =\{i; c_i =j\}\qquad for \;\;j=1:k$

${\Large \overset{Ex.}{\Rightarrow}} \;\;\large G_1 = \{4, 8, 10\},\; G_2 = \{1, 3, 7, 9\}, \;G_3 = \{2, 5, 6\}$

---
"""

# ╔═╡ 47f73e23-f852-477c-8064-804535577fef
md"""#
##### $\quad c. \;$ Define a _cluster representative_ ${\bf z}_i$ for each cluster;
##### $\qquad -\;$ Each representative is to be close to the vectors in its group.
##### $\qquad \quad\;$ That is, for all ${\bf x}_i$'s in Group $G_j$, $\| {\bf x}_i - {\bf z}_{G_j} \|$ to be small, 
\

##### $\quad d. \;$ Define an _objective function_ 
##### $\qquad -\;$ $\color{red} a \;single \;number$ to judge a choice of clustering 
##### $\qquad -\;$ along with a choice of the cluster representatives

$J^{clust} = (\| {\bf x}_1 - {\bf z}_{c_1}\|^2 + \dots + \| {\bf x}_N - {\bf z}_{c_N}\|^2)/N$

##### $\qquad \;\;$ which is the mean square distance from the vectors
##### $\qquad \;\;$ to their associated representatives.

!!! note \" Objective Function \"
	##### $\qquad -\;$  $J^{clust}$ depends on the cluster assignments ($\bf c$) and 
	##### $\qquad \;\;\;\;$ the group representatives ($\bf z$)
    ##### $\qquad -\;$ The smaller $J^{clust}$ is, the better the clustering

---
"""

# ╔═╡ 313c5c90-82a1-4027-acb0-e9cf6599288b
md"""#
!!! goal \"Goal is to find\"
    ##### $\quad -\;$ a choice of group assignments $c_1, c_2, \dots, c_N$, and 
    ##### $\quad -\;$ a choice of representatives ${\bf z}_1, {\bf z}_2, \dots, {\bf z}_N$ 
    ##### that minimize the objective $J^{clust}$.

"""

# ╔═╡ 8fafe901-1f05-4c98-8625-b05a3fe834f0
md"""
!!! fact
	##### It is a hard problem, because one needs to get both
	##### $\quad \qquad -\;$ the best clustering, and 
	##### $\quad \qquad -\;$ the best representatives. 
	##### However, it is possible to get
    ##### $\quad -\;$ the best clustering if the $\color{red} representatives \;are \;fixed$, and
	##### $\quad -\;$ the best representatives if the $\color{red} clustering \;is \;fixed$.

---
"""

# ╔═╡ c9c33d0e-97dd-4916-a677-d89a3292ba06
md"#
### 3. Fixed Representatives (fixed $\bf z$'s)
##### The group assignments $c_1, \dots, c_N$ are optimized to achieve the smallest value of $J^{clust}$:

##### $\qquad -\;$ $J^{clust}$ is the sum of $N$ terms
##### $\qquad -\;$ The choice of $c_i$ only affects the $i^{th}$ term in $J^{clust}$
##### $\qquad \quad \;$ ($c_i$: the group to which the vector ${\bf x}_i$ is assigned to)

$\large \|{\bf x}_i - {\bf z}_{c_i}\|^2 /N$.

##### $\qquad -\;$ Choose $c_i$ to be the value of $j$ that minimizes $\|{\bf x}_i - {\bf z}_j\|$

!!! easy
	##### Assign each data vector ${\bf x}_i$ to its nearest representative
	$\large \|{\bf x}_i - {\bf z}_{c_i}\|= {\min\limits_{j=1,\dots,k}} \|{\bf x}_i - {\bf z}_j\|$

$\large \Rightarrow J^{clust} = \left({\min\limits_{j=1,\dots,k}} \|{\bf x}_1 - {\bf z}_j\|^2 + \dots + {\min\limits_{j=1,\dots,k}}\|{\bf x}_N - {\bf z}_j\|^2 \right)/N$

!!! interpretation 
    ##### Mean of the squared distance from the data vectors to their closest representative
"

# ╔═╡ 378c6e08-043b-4f4a-8a80-d612b5733396
md"#
### 4. Fixed Assignment (fixed $c$'s)
##### The group representatives ${\bf z}_1, \dots, {\bf z}_k$ are optimized to achieve the smallest value of $J^{clust}$.

##### $\qquad -\;$ Rearrange $J^{clust}$ into $k$ sums

$\large J^{clust}=J_1 + \dots + J_k$
$\large J_j=\frac{1}{N}\sum_{i \in G_j}{\|{\bf x}_i - {\bf z}_j\|^2}$
##### $\qquad \quad$ each associated with one group.
\
$\qquad \qquad \large \bf \color{red} \Rightarrow Contributions \;from \;each \;group \;to \;J^{clust}$

##### $\qquad -\;$ The choice of ${\bf z}_j$ only affects the term $J_j$
##### $\qquad -\;$ Choose ${\bf z}_j$ to minimize $J_j$

!!! easy
	##### Choose ${\bf z}_j$ to be the average of the vectors ${\bf x}_i$ in its group:
	$\large {\bf z}_j = \frac{1}{|G_j|} \sum_{i \in G_j} {\bf x}_i$
	##### where $|G_j|$ is for the number of elements in the set $G_j$ 

---
"

# ╔═╡ c9c9be1f-ff3d-40d9-b4ac-aed52c9a8238
md"#
### 5. Implemenation (a simple example)
"

# ╔═╡ 794c13a7-c68f-4cd0-afdf-1c614920d48c
TwoColumn(
md"""
##### Consider 5 vectors ($N=5$) and 2 clusters ($k=2$),

$\large \left\{\begin{bmatrix} 0 \\ 0 \end{bmatrix}, \begin{bmatrix} 2 \\ 2 \end{bmatrix}, \begin{bmatrix} -1 \\ 0 \end{bmatrix}, \begin{bmatrix} 3 \\ 2 \end{bmatrix}, \begin{bmatrix} 0 \\ -1 \end{bmatrix}\right\}$

##### with the cluster assignment vector 

$\large {\bf c}=(1,2,1,2,1) \Rightarrow$

$\large {\bf x}_1, {\bf x}_3, {\bf x}_5 \rightarrow \color{red} G_1=\{1,3,5\}$
$\large {\bf x}_2, {\bf x}_4 \rightarrow \color{blue} G_2=\{2,4\}$

##### Now define the representative vectors of each group as

$\large {\bf z}=\left\{\begin{bmatrix} -1 \\ 1 \end{bmatrix}, \begin{bmatrix} 3 \\ 1 \end{bmatrix}\right\}$
---
""",
scatter([0 -1 0; 3 2 2; -1 3 3], [0 0 -1; 2 2 2; 1 1 1], xlims = (-3,4), ylims = (-2,3), legend =:false, frame = :origin, aspectratio = :equal, size = (300,300), color = [:red, :blue, :black], annotations = [(2.5,2.5,Plots.text(L"^{G_2}", color = :blue)), (-1,-1,Plots.text(L"^{G_1}", color = :red)), (-1,1.5,Plots.text(L"z_1", color = :black)), (3.5,1,Plots.text(L"z_2", color = :black))])

)

# ╔═╡ 5ba7294f-4cc1-46ed-b3b2-abc878a15c8e
md"""
##### ⇒ Input the vectors in the example
"""

# ╔═╡ 44793b30-25ed-4727-ac83-a08f5fde7232
begin
	x1 = [ [0,0], [2,2], [-1,0], [3, 2], [0, -1] ]
	z1 = [ [-1,1], [3,1] ]
	c1 = [1,2,1,2,1]
	(x1,z1,c1)
end

# ╔═╡ 37e3f8e8-c426-443a-b0ad-e9d060f33145
md"""#
##### ⇒ Define _Mean Square Distance_ as a function
"""

# ╔═╡ 9380710b-a8d7-4244-b857-8367b0cdac7e
begin
# Average = sum / length
	avg(x) = sum(x)/length(x);
# Objective function: Mean Square distance
	Jclust(x,reps,assignment) =
			avg( [norm(x[i]-reps[assignment[i]])^2 for i=1:length(x)] ) 
end

# ╔═╡ 3225f918-fdbd-4671-b754-b62c3383a885
md"""
##### ⇒ Find Mean Square Distance ($J^{clust}$) for the input 
"""

# ╔═╡ 6e06548d-3590-4d4e-acfc-773397c34b10
Jclust(x1,z1,c1) # Mean square distance

# ╔═╡ 13f4b3df-75de-4465-9ba1-12c6ab181c10
md"
##### ⇒Change the assignments and the representative vectors
"

# ╔═╡ ab929940-b9c6-4c27-9c8f-90f5a424a785
TwoColumn(
scatter([0 -1 0; 3 2 2; -1 3 3], [0 0 -1; 2 2 2; 1 1 1], xlims = (-3,4), ylims = (-2,3), legend =:false, frame = :origin, aspectratio = :equal, size = (300,300), color = [:red, :blue, :black], annotations = [(2.5,2.5,Plots.text(L"^{G_2}", color = :blue)), (-1,-1,Plots.text(L"^{G_1}", color = :red)), (-1,1.5,Plots.text(L"z_1", color = :black)), (3.5,1,Plots.text(L"z_2", color = :black))])
,
	scatter([0 -1 0; 3 2 2; 0 2.5 2.5], [0 0 -1; 2 2 2; 0 2 2], xlims = (-3,4), ylims = (-2,3), legend =:false, frame = :origin, aspectratio = :equal, size = (300,300), color = [:red, :blue, :black], ma = [1, 1, 0.5], annotations = [(2.5,2.5,Plots.text(L"^{G_2}", color = :blue)), (-1,-1,Plots.text(L"^{G_1}", color = :red)), (0.5,0.5,Plots.text(L"z_1", color = :black)), (2.5,1.5,Plots.text(L"z_2", color = :black))])
)

# ╔═╡ 4b164b8b-eb48-450c-a983-d03dedf7246f
begin
	c2 = [1,2,1,2,1];
	z2 = [ [0,0], [2.5,2] ]
	Jclust(x1,z2,c2)
end

# ╔═╡ 9cf3e0fc-cbae-4ac3-9c3f-a44828d8efbe
md"""#
##### ⇒ Watch the following video
"""

# ╔═╡ 2a325ef8-3160-42b8-9f6b-349b85fce208
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/QXOkPvFM6NU" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 6de2fe01-c34e-48d0-afc2-7fcc8757bacb
md"""
---"""

# ╔═╡ c805412a-8c52-4b48-8bc3-13a8e9a87cf9
md"#
## K-Means Algorithm - Application

#### ⇒ Study the K-Means function to understand the algorithm

!!! julia \"K-Means function\"
	##### function kmeans(X, k; maxiters = 100, tol = 1e-5)
	##### $\quad -\;$ The code is at the end of the notebook
	##### $\quad -\;$ Input: Array X, and the number of clusters $k$ 
	##### $\quad -\;$ Output: A tuple with two elements 
	##### $\qquad \circ \;$ `assignment:` An array of N integers between 1 and $k$, 
	##### $\qquad \circ \;$ `reps:` An array of $k$ n-vectors for representatives
"

# ╔═╡ aab01ea0-72d5-4fd3-8501-9df8bd3e1c78
md"""#
### Example: Fabricated random data
#### $\quad \;$ 1. Create random 300 2-vectors with 3 clusters
#### $\qquad \;$ ⇒ $N=300$, $n=2$, $k=3$ 

"""

# ╔═╡ 29375506-6fc8-40dc-97a4-4fb175f01fea
X = vcat( [ 0.3*randn(2) for i = 1:100 ],
[ [1,1] + 0.3*randn(2) for i = 1:100 ],
[ [1,-1] + 0.3*randn(2) for i = 1:100 ] )

# ╔═╡ 67ab11d7-345a-4646-96dd-451aa6c350af
begin
	X_1 = [ 0.3*randn(2) for i = 1:100 ]
	X_2 = [[1,1] + 0.3*randn(2) for i = 1:100 ]
	X_3 = [[1,-1] + 0.3*randn(2) for i = 1:100 ]
	XXX = [X_1; X_2; X_3]
end

# ╔═╡ a8858ace-af05-4884-b469-5820ffe287d9
md"""
---"""

# ╔═╡ 7feecea7-d2bc-4cd8-8651-f25e3eb070b1
md"""#
#### $\quad \;$ 2. Scatter plot the data
#### $\qquad \;$ ⇒ Observe visually that there are in fact three clusters
"""

# ╔═╡ 848ccf56-47ed-4cb2-a2c8-eec907c3d03d
begin
scatter([x[1] for x in X], [x[2] for x in X])
plot!(legend = false, grid = false, size = (500,300), xlims = (-1.5,2.5), ylims = (-2,2))
end

# ╔═╡ 0d5ba33e-bcfe-44da-bbb1-9695efc0ee52
md""" 
#### $\quad \;$ 3. Run the function for the given $\bf X$ and $k=3$
"""

# ╔═╡ 2a0db704-54a5-47fd-a101-dcad00de6b52
md"""
---"""

# ╔═╡ 437c1e3f-3eaf-46a3-a50f-b447c0c89522
md"""#
#### $\quad \;$ 4. _Group the input data_ for each cluster and _Plot_
"""

# ╔═╡ 5cd4e671-e712-4414-a42d-47a32b26f7c9
typeof(X), size(X) # Remember what you have as the input

# ╔═╡ 748dad45-6b5a-4b42-be6d-0b0d0c48d988
md"""
---"""

# ╔═╡ 3a8d39e7-df46-4db2-805b-e2c35ea32adc
md"""#
### Overview of Algorithm

#### Input: 
#### $\quad -\;$ Data to be clustered $\large {\bf X} = [{\bf x}_1 \cdots \;{\bf x}_N]'$, and 
#### $\quad -\;$ The estimated number of clusters $k$. 
\

#### Intial Computations: 
#### $\quad -\;$ Find the length of the vector ${\bf X}$ (which is $N$), and 
#### $\quad -\;$ the length of its members ${\bf x}_i$ (which is $n$) 
\

#### Initilize:
#### $\quad -\;$ Random assignment of ${\bf x}_i$ to one of the clusters,
#### $\quad \quad \;$ that is, form the vector $\bf c$
#### $\quad -\;$  $J_{previous}=\infty$

---
"""

# ╔═╡ 9563fbd9-b80d-403f-bbf8-794f13e45897
md"""#

#### $\color{red} Repeat \;until \;convergence$

#### $\quad -\;$ Fixed Assignment:
  
##### $\quad \quad \circ \;$ Calculate the representative location for each cluster
$\large {\bf z}_j = (1/|G_j|) \sum_{i \in G_j} {\bf x}_i \qquad for \;\;j=1,\dots, k$

#### $\quad -\;$ Fixed Representatives:

##### $\quad \quad \circ \;$ Minimize the distance between data and representatives

$\|{\bf x}_i - {\bf z}_{c_i}\|= {\min\limits_{j=1,\dots,k}} \|{\bf x}_i - {\bf z}_j\| \qquad for \;\;i=1,\dots,N$
##### $\quad \qquad $ ${\bf z}_{c_i}$: Group to which ${\bf x}_i$ is assigned
##### $\quad \qquad $ ${\bf z}_j$'s were fixed in the previous step

##### $\quad \quad \circ \;$ Save the distances and update the assignments of each data point

##### $\quad \quad \circ \;$ Calculate the objective function $J^{clust}$

$\large \left({\min\limits_{j=1,\dots,k}} \|{\bf x}_1 - {\bf z}_j\|^2 + \dots + {\min\limits_{j=1,\dots,k}}\|{\bf x}_N - {\bf z}_j\|^2 \right)/N$
#### $\color{red} End$

---
"""

# ╔═╡ a3ee3be1-e823-4b10-b187-b69288050d84
md"""#
### Disecting the code

#### Input: 
##### $\qquad - \;$ The data set $\{ {\bf X}(i);\; for \; i=1,\dots,N \}$ is ready 
##### $\qquad - \;$ the number of clusters $k$ is 3.
\

#### Intial Computations:
##### $\qquad - \;$ Find the length of the vector ${\bf X}$ (which is $N$) 
##### $\qquad - \;$ Find the length of its members ${\bf x}_i$ (which is $n$)

#### Initilize: 
##### $\qquad - \;$ Random "assignment" of each point to one of the clusters
##### $\qquad - \;$  $J_{previous}=\infty$, and "representatives" ${\bf z}_i =0 \;{\bf for} \;i=1,\dots,k$
##### $\qquad - \;$ "distance" array gives the distances between each data point 
##### $\qquad \quad \;\;$to its representative, and set to zero initially.

"""

# ╔═╡ 5fae2e7d-1743-4efa-877a-6c25e9336687
md"""
---"""

# ╔═╡ efdb96ed-51e6-49d9-8c8a-21cec30b57cb
md"""#
#### Repeat until convergence:

#### $\qquad 1.\;$ Form the groups $(G_j, j=1,\dots,k)$

$\large G_j =\{i; c_i =j\}\qquad for \;\;j=1:k$
"""

# ╔═╡ b438d4e7-a27f-4bbd-b373-16204206bf39
md"""
#### $\qquad 2. \;$ Update the group representatives
$\large {\bf z}_j = (1/|G_j|) \sum_{i \in G_j} {\bf x}_i$
"""

# ╔═╡ feb6d6b9-41ad-4639-b41b-1794925e78f8
md"""
---"""

# ╔═╡ fc1706c7-a04f-4a33-8127-b5c1ea4abd04
md"""#
#### $\qquad 3. \;$ Find the distances and update the assignments
$\large distance(i), assignment(i) \Leftarrow {\min\limits_{j=1,\dots,k}} \|{\bf x}_i - {\bf z}_j\|$
"""

# ╔═╡ 79a90c52-f73a-41b2-b6f0-9210143ba2e6
md"""
#### $\qquad 4. \;$ Update the objective function
$\large J^{clust} = \left({\min\limits_{j=1,\dots,k}} \|{\bf x}_1 - {\bf z}_j\|^2 + \dots + {\min\limits_{j=1,\dots,k}}\|{\bf x}_N - {\bf z}_j\|^2 \right)/N$
$\large J^{clust} = [norm(distance)]^2 /N$
"""

# ╔═╡ b3f1887d-9a56-49a3-b7a2-702b310c2354
md"""
!!! remember \"Remember "findmin( )" and "minimum( )" \"
	##### ``\; -\;`` "_findmin_(``\bf x`` )" returns the minimum element and its index of ``\bf x``
	
	##### ``\; -\;`` "_minimum_(``\bf x``)" just brings the minimum value of ``\bf x``
"""

# ╔═╡ df50cb77-57c6-4698-925f-b9e0a0b1b9b4
md"""
---"""

# ╔═╡ 5b1c53d6-edcb-4f49-9677-04a4a04c0126
md"""#
### Comments and Clarifications[^2]

##### $\quad - \;$ In step one, one or more groups can be empty
\

##### $\quad - \;$ If the group assignments stay the same in two successive iterations, 
##### $\qquad \circ \;$ the representatives in step 2 will also be the same 
##### $\qquad \circ \;$ The group assignments and representatives will never change
##### $\qquad \circ \;$ So, stop the algorithm
\
 
##### $\quad - \;$ $J^{clust}$ decreases in each step ⇒ the "k-means algorithm" converges 
##### $\qquad \circ \;$ However, depending on the initial choice of representatives or 
##### $\qquad \quad$ assignment, the algorithm can, and does, converge to different 
##### $\qquad \quad$ final partitions, with different objective values.
\
 
##### $\quad - \;$ The "k-means algorithm" cannot guarantee the minimum of $J^{clust}$
##### $\qquad \circ \;$ Common to run the k-means algorithm several times, 
##### $\qquad \quad$ with different initial representatives, and 
##### $\qquad \quad$ choose the one with the smallest final value of $J^{clust}$
\

##### $\quad - \;$ Common to run the "k-means algorithm" for different values of $k$
\

##### $\quad - \;$ Faster than the other algorithms like "Hierarchical Clustering" 
\

[^2] [Introduction to Applied Linear Algebra: Vectors, Matrices, and Least Squares] (https://web.stanford.edu/~boyd/vmls/vmls.pdf), Stephen Boyd and Lieven Vandenberghe, Cambridge University Press, 2018. (You can download from the link as allowed by the Cambridge University Press)

---
"""

# ╔═╡ ba7f3e21-59dd-4737-a962-56a6f7bb1f94
md"""#
### Example: Image classification

##### $\quad - \;$ Use the MNIST (Mixed National Institute of Standards) database 

##### $\quad \qquad \circ \;$ It is datset of handwritten digits 

##### $\quad \qquad \circ \;$ It contains $N$ = 60,000 grayscale images for training

##### $\quad \qquad \circ \;$ It contains $N$ = 10,000 grayscale images for testing

##### $\quad \qquad \circ \;$ Each image is of size 28 × 28, represented as 784-vectors

##### $\quad \qquad \circ \;$ The "MLDatasets" package includes the MNIST dataset

"""

# ╔═╡ 1cea791f-a644-4cd4-b32a-6e635bdc5c76
md"""
---"""

# ╔═╡ d7f633da-0d53-4438-b35a-59f158464b52
md"""#
### 1. Examine the dataset

##### $\quad - \;$ See if you can access to the data
"""

# ╔═╡ 1281cff2-fe2b-4c24-80ee-53b106fbc632
MLDatasets.MNIST.traindata(); # 60,000 numbers are chosen to be the training set

# ╔═╡ af5b4b85-97df-431e-b84f-6d52e78ca696
MNIST.testdata(); # 10,000 numbers are chosen to be the testing set

# ╔═╡ a7ced035-d86d-4e8a-8811-1c7a038497c3
MNIST.traindata(1);

# ╔═╡ 46356c92-6988-41b0-bd50-af671fdf7f19
md"""
##### $\quad - \;$ Visualize a few images 
"""

# ╔═╡ 5db9c526-72ae-431d-966e-f613d8276018
begin
	x_train, y_train = MNIST.traindata(); # Load trainin data
	x_test, y_test = MNIST.testdata(); # Load test data
	[(Gray.(x_train[:,:,1]'), Gray.(x_test[:,:,1]')); (y_train[1], y_test[1])] # Look at the first numbers
end

# ╔═╡ 48f7b726-666d-4b8a-a903-62f7e7c1a39d
MNIST.trainlabels()

# ╔═╡ 89993439-9f93-4d72-881d-555f350ed200
size(x_train), size(x_test) # 60K for training, 10K for testing

# ╔═╡ 4027edbc-c828-49eb-8201-2db570f8ba9e
images = [Gray.(x_train[:,:,i]') for i in 1:60000];

# ╔═╡ e48131f4-4eb1-432f-a636-53c84a0f7730
size(images[500]) # Size of a single image = 28 x 28 pixels

# ╔═╡ 562a4875-74d3-413d-9669-74fda54ea676
(reshape(images[101:110],2,5), reshape(y_train[101:110], 2,5))

# ╔═╡ d7baa76d-32e8-4fc6-a69f-445ceab798cf
rshaped_image=reshape(images[101],:) # 28x28 matrix is converted to an array of 784 Gray

# ╔═╡ 7a5410b4-6245-4fec-bfcc-c69968499d82
ch_image = channelview(rshaped_image); # Float32.(rshaped_image) will give the same floating point array

# ╔═╡ ace3f2e9-4f42-4e2a-a949-c8aef2d9f251
xxxx = Float32.(rshaped_image)

# ╔═╡ 9f5e6978-d7ed-428e-b926-b8eb27b72946
xxxx == ch_image

# ╔═╡ 99699060-bf6d-4d2b-a47f-750fa6f9792e
XX=Float32.(hcat(reshape.(images,:)...)); # 784 x 60000 

# ╔═╡ 912b2844-dc45-4d0c-a6ed-cc3fe9c85643
size(XX)

# ╔═╡ 6673ad27-d01a-42b5-b40e-12e3c6c299e3
md"""
---"""

# ╔═╡ 6daa33f9-f9be-4a1e-ae6c-9d1e76e39204
md"""#
### 2. Prepare the input data for the k-means algorithm

##### $\quad - \;$ Randomize the re-shaped data XX
"""

# ╔═╡ 3a9356af-3eb3-4499-8a6d-9e154d716f7b
XX_rand = XX[:,1:20000];

# ╔═╡ ae20ff53-d259-4b6a-aea5-33d7ef1afa0d
md"""
##### $\quad - \;$ Apply the k-means algorithm
"""

# ╔═╡ 3ada069c-006b-40bb-87ea-215f18241e2b
md"""
---"""

# ╔═╡ 741b8fcb-3fc1-4c00-920b-fcf06b2f1896
md"""
### 3. Post-process the output

##### $\quad - \;$ Reshape the 784-vectors to 28x28 matrices to visualize 
"""

# ╔═╡ 3ded746e-e045-45ed-b9b2-ab65f12aff80
size(XX_rand)[2]

# ╔═╡ 31681824-9fc8-444b-97e9-f6795fc5257e
# reshape(z_num_gray[1:k_num],2,5)

# ╔═╡ b8610d2b-b4f9-4c14-9744-a3ff8754f7e5
md"""
<center><b><p
style="color:black;font-size:40px;">END of Clustering</p></b></center>
"""|>HTML

# ╔═╡ 0ae0f401-90b4-4780-b5a5-ea67db93e780
"""
    kmeans(X, k; maxiters = 100, tol = 1e-5)
Applies the k-means algorithm for `k` clusters to the vectors stored in `X`.
The argument `X` is a one-dimensional array of N n-vectors or an `n` times `N` matrix.
`kmeans` returns a tuple with two elements: `assignment` is an array of N 
integers between 1 and k with the cluster assignment for the N data points.
`reps` is an array of k n-vectors with the k cluster representatives. 
"""
function kmeans(X, k; maxiters = 100, tol = 1e-3)
    if ndims(X) == 2
        X = [X[:,i] for i in 1:size(X,2)]
    end;
    N = length(X)
    n = length(X[1])
    distances = zeros(N)  
    reps = [zeros(n) for j=1:k]  
    assignment = [ rand(1:k) for i in 1:N ]
    Jprevious = Inf  
    for iter = 1:maxiters
        for j = 1:k
            group = [i for i=1:N if assignment[i] == j]             
            reps[j] = sum(X[group]) / length(group);
        end;
        for i = 1:N
            (distances[i], assignment[i]) = 
                findmin([norm(X[i] - reps[j]) for j = 1:k]) 
        end;
        J = norm(distances)^2 /  N
        println("Iteration ", iter, ": Jclust = ", J, ".")
        if iter > 1 && abs(J - Jprevious) < tol * J  
            return assignment, reps
        end
        Jprevious = J
    end
end

# ╔═╡ 3a9e1acd-ab31-46c6-bff6-37509d75f9be
begin
	k = 3; N1 = length(X) # Number of clusters and Number of points
	assignment, reps = kmeans(X, k) # kmeans returns a tuple with two elements
end

# ╔═╡ 30cda8f8-65e2-4722-80b5-0250f85f1477
assignment # gives the cluster number for each input in the given order of input

# ╔═╡ ba710d13-6e9d-4d6d-a6b7-9ddec2094348
grps = [[X[i] for i=1:N1 if assignment[i] == j] for j=1:k]

# ╔═╡ a08a76ff-a25f-46fb-b6cb-ad6b43ab0670
begin
scatter([c[1] for c in grps[1]], [c[2] for c in grps[1]] )
scatter!([c[1] for c in grps[2]], [c[2] for c in grps[2]])
scatter!([c[1] for c in grps[3]], [c[2] for c in grps[3]])
plot!(legend = false, grid = false, size = (500,300), xlims = (-1.5,2.5), ylims = (-2,2))
end

# ╔═╡ 1c933492-8a13-4ed2-adbc-c87eac069c35
begin
    N, n = length(X), length(X[1]) # N n-vectors
	distances = zeros(N)  # Initilize distance to zero
#    reps1 = [zeros(n) for j=1:k]  # initilize repesentative locations by k n-vectors
    assignment1 = [ rand(1:k) for i in 1:N ] # initilize N dimensional c vector with random integers between 1 and k, that is, assign one of three groups randomly
	Jprevious = Inf  # Set the objective function to infinity, as a minimum is searched for
end

# ╔═╡ 1317dfa6-2058-431b-95c6-e151d16f7996
group = [[i for i=1:N if assignment1[i] == j] for j = 1:k]  

# ╔═╡ e95f1323-5748-43b3-a748-cdc7a023f370
typeof(group)

# ╔═╡ 48bd5efa-aaef-468d-9e59-1c9b9f594b63
reps1 = [sum(X[group[j]]) / length(group[j]) for j=1:k]

# ╔═╡ 8be283bb-e670-41c3-bf2c-0cacb91a8b68
begin
	for i in 1:N
	(distances[i], assignment1[i]) = findmin([norm(X[i] - reps1[j]) for j = 1:k])
	end;
	J = norm(distances)^2 /  N
end

# ╔═╡ 05ac6863-147f-4b9c-b0f3-015b1fa75490
begin
	k_num = 12 # Number of clusters
	c_numbers, z_numbers = kmeans(XX_rand, k_num) # kmeans returns a tuple with two elements
end

# ╔═╡ 7777ac6d-8914-4208-bf33-ef2c254230de
reps_num = [reshape(z_numbers[i],28,28) for i=1:k_num]; # Form k_num (28x28) matrices

# ╔═╡ ec2afc86-25ae-41ed-8cb1-1242c59e11db
[Gray.(reps_num[i]) for i =1:k_num]

# ╔═╡ c86fbf7d-fae1-4012-a0ed-cd92f374525b
group_MNIST = [[i for i=1:size(XX_rand)[2] if c_numbers[i] == j] for j = 1:k_num]  

# ╔═╡ 0049b62c-e264-4703-89b1-ed31ff4393a2
group_MNIST[1][1:3]

# ╔═╡ 74a3f21e-5618-4c08-8e29-bc262b21c544
ccc = [y_train[group_MNIST[i]] for i = 1:k_num]; # c = counter([1,2,3,3,4,4,4,6])

# ╔═╡ 8cbcdc45-4adf-4bb0-9813-f76a71cd77fd
ccc1 = [counter(ccc[i]) for i = 1:k_num];

# ╔═╡ c6b7a35c-10d5-4985-970b-68a51888d51c
keysandvalues = [[collect(keys(ccc1[i])) collect(values(ccc1[i]))] for i = 1:k_num];

# ╔═╡ 0fa105bc-e0f5-48c1-935c-b91c0483a7d3
keysandvalues[1][8,1];

# ╔═╡ 6dc5694c-2e2f-462e-82fd-82be687042c9
maxindex = [findmax(keysandvalues[i][:,2]) for i = 1:k_num];

# ╔═╡ a78e79d5-70c6-4152-ade6-910225f17848
index = [maxindex[i][2] for i = 1:k_num]

# ╔═╡ a433ab43-7699-4748-ac4b-580e0d2ef62c
labelsforgroups = [keysandvalues[i][index[i],1] for i = 1:k_num]

# ╔═╡ 6de850c1-1580-466b-a185-a354d9b3e753
z_num_gray = hcat([Gray.(reps_num[i]) for i=1:k_num]...)

# ╔═╡ b3cf3da7-53e6-4496-b23e-387740a33243
size(z_num_gray)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
MLDatasets = "eb30cadb-4394-5ae3-aed4-317e484a6458"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Shuffle = "bf21e494-c40e-4daa-abfb-de5ec0aad010"
TestImages = "5e47fb64-e119-507b-a336-dd2b206d9990"
XLSX = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"

[compat]
CSV = "~0.10.4"
ColorVectorSpace = "~0.9.9"
Colors = "~0.12.8"
DataFrames = "~1.3.6"
DataStructures = "~0.18.13"
FileIO = "~1.15.0"
HypertextLiteral = "~0.9.4"
ImageIO = "~0.6.6"
ImageShow = "~0.3.6"
Images = "~0.25.2"
LaTeXStrings = "~1.3.0"
MLDatasets = "~0.5.16"
Plots = "~1.33.0"
PlutoUI = "~0.7.40"
Shuffle = "~0.1.1"
TestImages = "~1.7.0"
XLSX = "~0.8.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "7d004685bea6a6d4e1c908a24ad67dfca06c5dee"

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

[[deps.BinDeps]]
deps = ["Libdl", "Pkg", "SHA", "URIParser", "Unicode"]
git-tree-sha1 = "1289b57e8cf019aede076edab0587eb9644175bd"
uuid = "9e28174c-4ba2-5203-b857-d8d62c4213ee"
version = "1.0.2"

[[deps.BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[deps.BufferedStreams]]
git-tree-sha1 = "bb065b14d7f941b8617bc323063dbe79f55d16ea"
uuid = "e1450e63-4bb3-523b-b2a4-4ffa8c0fd77d"
version = "1.1.0"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "873fb188a4b9d76549b81465b1f75c82aaf59238"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.4"

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
git-tree-sha1 = "dc4405cee4b2fe9e1108caec2d760b7ea758eca2"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.5"

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
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "5856d3031cdb1f3b2b6340dfdc66b6d9a149a374"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.2.0"

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
git-tree-sha1 = "1106fa7e1256b402a86a8e7b15c00c85036fef49"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.11.0"

[[deps.DataDeps]]
deps = ["HTTP", "Libdl", "Reexport", "SHA", "p7zip_jll"]
git-tree-sha1 = "bc0a264d3e7b3eeb0b6fc9f6481f970697f29805"
uuid = "124859b0-ceae-595e-8997-d05f6a7a8dfe"
version = "0.7.10"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "db2a9cb664fcea7836da4b414c3278d71dd602d2"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.6"

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

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

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

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

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
git-tree-sha1 = "0eb5ef6f270fb70c2d83ee3593f56d02ed6fc7ff"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.68.0+0"

[[deps.GZip]]
deps = ["Libdl"]
git-tree-sha1 = "039be665faf0b8ae36e089cd694233f5dee3f7d6"
uuid = "92fee26a-97fe-5a0c-ad85-20a5f3185b63"
version = "0.5.1"

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

[[deps.Glob]]
git-tree-sha1 = "4df9f7e06108728ebf00a0a11edee4b29a482bb2"
uuid = "c27321d9-0574-5035-807b-f59d2c89b15c"
version = "1.3.0"

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
git-tree-sha1 = "d2b1968d27b23926df4a156745935950568e4659"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.7.3"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HDF5]]
deps = ["Compat", "HDF5_jll", "Libdl", "Mmap", "Random", "Requires"]
git-tree-sha1 = "899f041bf330ebeead3637073b2ca7477760edde"
uuid = "f67ccb44-e63f-5c2f-98bd-6dc0ccc4ba2f"
version = "0.16.11"

[[deps.HDF5_jll]]
deps = ["Artifacts", "JLLWrappers", "LibCURL_jll", "Libdl", "OpenSSL_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "4cc2bb72df6ff40b055295fdef6d92955f9dede8"
uuid = "0234f1f7-429e-5d53-9886-15a909be8d59"
version = "1.12.2+2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "4abede886fcba15cd5fd041fef776b230d004cee"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.4.0"

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

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "d19f9edd8c34760dca2de2b503f969d8700ed288"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.4"

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

[[deps.InternedStrings]]
deps = ["Random", "Test"]
git-tree-sha1 = "eb05b5625bc5d821b8075a77e4c421933e20c76b"
uuid = "7d512f48-7fb1-5a58-b986-67e6dc259f01"
version = "0.7.0"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "f67b55b6447d36733596aea445a9f119e83498b6"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.5"

[[deps.IntervalSets]]
deps = ["Dates", "Statistics"]
git-tree-sha1 = "ad841eddfb05f6d9be0bff1fa48dcae32f134a2d"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.6.2"

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
git-tree-sha1 = "6c38bbe47948f74d63434abed68bdfc8d2c46b99"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.23"

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

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "f1572de22c866dc92aea032bc89c2b137cbddd6a"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.10.0"

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
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

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

[[deps.MAT]]
deps = ["BufferedStreams", "CodecZlib", "HDF5", "SparseArrays"]
git-tree-sha1 = "971be550166fe3f604d28715302b58a3f7293160"
uuid = "23992714-dd62-5051-b70f-ba57cb901cac"
version = "0.10.3"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "41d162ae9c868218b1f3fe78cba878aa348c2d26"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.1.0+0"

[[deps.MLDatasets]]
deps = ["BinDeps", "CSV", "ColorTypes", "DataDeps", "DataFrames", "DelimitedFiles", "FileIO", "FixedPointNumbers", "GZip", "Glob", "HDF5", "JLD2", "JSON3", "MAT", "MLUtils", "Pickle", "Requires", "SparseArrays", "Tables"]
git-tree-sha1 = "862c3a31a5a6dfc68e78e2e1634dac1d3b0f654e"
uuid = "eb30cadb-4394-5ae3-aed4-317e484a6458"
version = "0.5.16"

[[deps.MLUtils]]
deps = ["ChainRulesCore", "DelimitedFiles", "Random", "ShowCases", "Statistics", "StatsBase"]
git-tree-sha1 = "c92a10a2492dffac0e152a19d5ffd99a5030349a"
uuid = "f1d291b0-491e-4a28-83b9-f70985020b54"
version = "0.2.1"

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
git-tree-sha1 = "6872f9594ff273da6d13c7c1a1545d5a8c7d0c1c"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.6"

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

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "fa44e6aa7dfb963746999ca8129c1ef2cf1c816b"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.1.1"

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

[[deps.Pickle]]
deps = ["DataStructures", "InternedStrings", "Serialization", "SparseArrays", "Strided", "StringEncodings", "ZipFile"]
git-tree-sha1 = "e6a34eb1dc0c498f0774bbfbbbeff2de101f4235"
uuid = "fbb45041-c46e-462f-888f-7c521cafbc2c"
version = "0.3.2"

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
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "6062b3b25ad3c58e817df0747fc51518b9110e5f"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.33.0"

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

[[deps.Quaternions]]
deps = ["DualNumbers", "LinearAlgebra", "Random"]
git-tree-sha1 = "4ab19353944c46d65a10a75289d426ef57b0a40c"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.5.7"

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
git-tree-sha1 = "3d52be96f2ff8a4591a9e2440036d4339ac9a2f7"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.3.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "130c68b3497094753bacf084ae59c9eeaefa2ee7"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.14"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.ShowCases]]
git-tree-sha1 = "7f534ad62ab2bd48591bdeac81994ea8c445e4a5"
uuid = "605ecd9f-84a6-4c9e-81e2-4798472b76a3"
version = "0.1.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Shuffle]]
deps = ["Random"]
git-tree-sha1 = "b812fb30d6d8b295b71dd5a4102d1ae7b60698e3"
uuid = "bf21e494-c40e-4daa-abfb-de5ec0aad010"
version = "0.1.1"

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

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

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
git-tree-sha1 = "2d4e51cfad63d2d34acde558027acbc66700349b"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.3"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

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

[[deps.Strided]]
deps = ["LinearAlgebra", "TupleTools"]
git-tree-sha1 = "a7a664c91104329c88222aa20264e1a05b6ad138"
uuid = "5e0ebb24-38b0-5f93-81fe-25c709ecae67"
version = "1.2.3"

[[deps.StringDistances]]
deps = ["Distances", "StatsAPI"]
git-tree-sha1 = "ceeef74797d961aee825aabf71446d6aba898acb"
uuid = "88034a9c-02f8-509d-84a9-84ec65e18404"
version = "0.11.2"

[[deps.StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "ca4bccb03acf9faaf4137a9abc1881ed1841aa70"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.10.0"

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
git-tree-sha1 = "7149a60b01bf58787a1b83dad93f90d4b9afbe5d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.8.1"

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

[[deps.TupleTools]]
git-tree-sha1 = "3c712976c47707ff893cf6ba4354aa14db1d8938"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.3.0"

[[deps.URIParser]]
deps = ["Unicode"]
git-tree-sha1 = "53a9f49546b8d2dd2e688d216421d050c9a31d0d"
uuid = "30578b45-9adc-5946-b283-645ec420af67"
version = "0.4.1"

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

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XLSX]]
deps = ["Artifacts", "Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "ccd1adf7d0b22f762e1058a8d73677e7bd2a7274"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.8.4"

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

[[deps.ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "ef4f23ffde3ee95114b461dc667ea4e6906874b2"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.10.0"

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
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

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
# ╟─e868136f-4c18-42db-9bbd-ef0c1466f1da
# ╟─1f3351f6-116b-4743-9ec8-d9854d8cfbf2
# ╟─a538d63a-39d9-11ed-1a9d-41c88dfdf225
# ╟─9255470e-7999-4286-a95a-9e2626bb12ec
# ╟─933adf04-0244-41c0-b34d-11b482ecea9f
# ╠═cabbc51e-82b1-4c1d-b2d0-1c9c3b8fc5fa
# ╟─53de0150-3d9e-4262-9a20-29643bd25cfe
# ╠═fae02d8e-2a2a-4cf5-8a03-7e37a1d5b5be
# ╟─d49a44bd-fe3e-4f6b-a0d7-37f5062b1291
# ╟─061400c5-565a-4147-8812-26bf1a713fba
# ╟─1a3750a2-222a-41ea-b97f-78417e1278f5
# ╠═7fcf79e2-7157-4ec6-99c0-e5b03483afd4
# ╠═d79b3cf5-f4d1-47b9-8fa3-3fcaf2f4da80
# ╠═41affc75-89a5-4977-a4b5-6c5bd4772300
# ╠═7dd1ed1a-8ae7-4891-8164-eb8460223920
# ╠═0d21455b-3165-4bf4-807e-19faedc28aa8
# ╠═0a2fa725-7237-41b2-9ed7-51151a89b941
# ╠═6c6a16ed-66bf-4c29-8b5f-4d2c50a5a56b
# ╠═c5e758c6-b474-4beb-9941-9f1d691d6079
# ╟─a0f2dfdb-24a8-45b2-a15b-256060f7c786
# ╠═1cf2f46b-f8bc-4975-ba63-c623a314fe8f
# ╟─e5551c37-8f47-4feb-a2a0-e6a60e00d9a2
# ╟─3c7c7762-71be-4a81-b743-139be12bf2ab
# ╠═ed0803f6-a56a-4458-a018-d8e5bf7c415a
# ╠═e5922a31-2fdc-4da0-9ef6-0c294d73b8cf
# ╟─82235fda-8140-431c-b762-eda081ff6091
# ╟─a5e9c73f-8a14-47db-adcd-0927a46d0494
# ╠═d5aa1928-5bac-4ef2-8e83-10863d0845cf
# ╠═fc63bc22-93df-42df-978c-1591422f7c81
# ╟─a6837761-28ab-4ef3-a6e4-ace97b6a43c4
# ╟─bce1fb56-1483-4b11-b9d3-6d9877a82a6c
# ╠═1817f185-3472-41f7-bb47-4ad9b6cf0399
# ╠═f6ba7e78-1a4b-463f-914c-36235bf98dfb
# ╟─3fdf242c-0fa4-4309-a73b-159e8c6ed54f
# ╟─0701de7c-2206-4eb6-9d41-79e728f0978a
# ╟─6b425a4f-dc3d-4f3d-b0a6-c87c05a18b0e
# ╟─f3f96732-b40e-4e84-b7d9-338e081001d8
# ╠═597fbec4-9aed-4392-8173-8b8537424ab4
# ╠═b4e91fd0-6bdd-4272-9810-96d4a3524577
# ╟─7df20338-5e02-4757-8985-c903a1e1b5db
# ╠═76b104a0-a6f6-4786-b81f-d02c52f86121
# ╟─73317b75-ad8e-48d6-bee8-ea879429600f
# ╟─538e4b56-11e6-4abc-9bf2-2ee45716ecad
# ╟─66085b26-bde0-4a03-885c-5992ffca74de
# ╠═727c2e74-30fb-4ae1-a6a7-f05fd49d5a68
# ╟─369f121d-e97d-4bec-a8ce-5a111b240da4
# ╟─47f73e23-f852-477c-8064-804535577fef
# ╟─313c5c90-82a1-4027-acb0-e9cf6599288b
# ╟─8fafe901-1f05-4c98-8625-b05a3fe834f0
# ╟─c9c33d0e-97dd-4916-a677-d89a3292ba06
# ╟─378c6e08-043b-4f4a-8a80-d612b5733396
# ╟─c9c9be1f-ff3d-40d9-b4ac-aed52c9a8238
# ╟─794c13a7-c68f-4cd0-afdf-1c614920d48c
# ╟─5ba7294f-4cc1-46ed-b3b2-abc878a15c8e
# ╠═44793b30-25ed-4727-ac83-a08f5fde7232
# ╟─37e3f8e8-c426-443a-b0ad-e9d060f33145
# ╠═9380710b-a8d7-4244-b857-8367b0cdac7e
# ╟─3225f918-fdbd-4671-b754-b62c3383a885
# ╠═6e06548d-3590-4d4e-acfc-773397c34b10
# ╟─13f4b3df-75de-4465-9ba1-12c6ab181c10
# ╟─ab929940-b9c6-4c27-9c8f-90f5a424a785
# ╠═4b164b8b-eb48-450c-a983-d03dedf7246f
# ╟─9cf3e0fc-cbae-4ac3-9c3f-a44828d8efbe
# ╟─2a325ef8-3160-42b8-9f6b-349b85fce208
# ╟─6de2fe01-c34e-48d0-afc2-7fcc8757bacb
# ╟─c805412a-8c52-4b48-8bc3-13a8e9a87cf9
# ╟─aab01ea0-72d5-4fd3-8501-9df8bd3e1c78
# ╠═29375506-6fc8-40dc-97a4-4fb175f01fea
# ╠═67ab11d7-345a-4646-96dd-451aa6c350af
# ╟─a8858ace-af05-4884-b469-5820ffe287d9
# ╟─7feecea7-d2bc-4cd8-8651-f25e3eb070b1
# ╟─848ccf56-47ed-4cb2-a2c8-eec907c3d03d
# ╟─0d5ba33e-bcfe-44da-bbb1-9695efc0ee52
# ╠═3a9e1acd-ab31-46c6-bff6-37509d75f9be
# ╟─2a0db704-54a5-47fd-a101-dcad00de6b52
# ╟─437c1e3f-3eaf-46a3-a50f-b447c0c89522
# ╠═5cd4e671-e712-4414-a42d-47a32b26f7c9
# ╠═30cda8f8-65e2-4722-80b5-0250f85f1477
# ╠═ba710d13-6e9d-4d6d-a6b7-9ddec2094348
# ╟─a08a76ff-a25f-46fb-b6cb-ad6b43ab0670
# ╟─748dad45-6b5a-4b42-be6d-0b0d0c48d988
# ╟─3a8d39e7-df46-4db2-805b-e2c35ea32adc
# ╟─9563fbd9-b80d-403f-bbf8-794f13e45897
# ╟─a3ee3be1-e823-4b10-b187-b69288050d84
# ╠═1c933492-8a13-4ed2-adbc-c87eac069c35
# ╟─5fae2e7d-1743-4efa-877a-6c25e9336687
# ╟─efdb96ed-51e6-49d9-8c8a-21cec30b57cb
# ╠═1317dfa6-2058-431b-95c6-e151d16f7996
# ╠═e95f1323-5748-43b3-a748-cdc7a023f370
# ╟─b438d4e7-a27f-4bbd-b373-16204206bf39
# ╠═48bd5efa-aaef-468d-9e59-1c9b9f594b63
# ╟─feb6d6b9-41ad-4639-b41b-1794925e78f8
# ╟─fc1706c7-a04f-4a33-8127-b5c1ea4abd04
# ╟─79a90c52-f73a-41b2-b6f0-9210143ba2e6
# ╟─b3f1887d-9a56-49a3-b7a2-702b310c2354
# ╠═8be283bb-e670-41c3-bf2c-0cacb91a8b68
# ╟─df50cb77-57c6-4698-925f-b9e0a0b1b9b4
# ╟─5b1c53d6-edcb-4f49-9677-04a4a04c0126
# ╟─ba7f3e21-59dd-4737-a962-56a6f7bb1f94
# ╠═58c158d7-3627-4d08-a3b8-dc5a1370e369
# ╟─1cea791f-a644-4cd4-b32a-6e635bdc5c76
# ╟─d7f633da-0d53-4438-b35a-59f158464b52
# ╠═1281cff2-fe2b-4c24-80ee-53b106fbc632
# ╠═af5b4b85-97df-431e-b84f-6d52e78ca696
# ╠═a7ced035-d86d-4e8a-8811-1c7a038497c3
# ╟─46356c92-6988-41b0-bd50-af671fdf7f19
# ╟─5db9c526-72ae-431d-966e-f613d8276018
# ╠═48f7b726-666d-4b8a-a903-62f7e7c1a39d
# ╠═89993439-9f93-4d72-881d-555f350ed200
# ╠═4027edbc-c828-49eb-8201-2db570f8ba9e
# ╠═e48131f4-4eb1-432f-a636-53c84a0f7730
# ╠═562a4875-74d3-413d-9669-74fda54ea676
# ╠═d7baa76d-32e8-4fc6-a69f-445ceab798cf
# ╠═7a5410b4-6245-4fec-bfcc-c69968499d82
# ╠═ace3f2e9-4f42-4e2a-a949-c8aef2d9f251
# ╠═9f5e6978-d7ed-428e-b926-b8eb27b72946
# ╠═99699060-bf6d-4d2b-a47f-750fa6f9792e
# ╠═912b2844-dc45-4d0c-a6ed-cc3fe9c85643
# ╟─6673ad27-d01a-42b5-b40e-12e3c6c299e3
# ╟─6daa33f9-f9be-4a1e-ae6c-9d1e76e39204
# ╠═3a9356af-3eb3-4499-8a6d-9e154d716f7b
# ╠═ae20ff53-d259-4b6a-aea5-33d7ef1afa0d
# ╠═05ac6863-147f-4b9c-b0f3-015b1fa75490
# ╟─3ada069c-006b-40bb-87ea-215f18241e2b
# ╟─741b8fcb-3fc1-4c00-920b-fcf06b2f1896
# ╠═7777ac6d-8914-4208-bf33-ef2c254230de
# ╠═ec2afc86-25ae-41ed-8cb1-1242c59e11db
# ╠═3ded746e-e045-45ed-b9b2-ab65f12aff80
# ╠═c86fbf7d-fae1-4012-a0ed-cd92f374525b
# ╠═0049b62c-e264-4703-89b1-ed31ff4393a2
# ╠═fc72e1e1-c288-428b-8a29-d61bcdbdad4d
# ╠═74a3f21e-5618-4c08-8e29-bc262b21c544
# ╠═8cbcdc45-4adf-4bb0-9813-f76a71cd77fd
# ╠═c6b7a35c-10d5-4985-970b-68a51888d51c
# ╠═0fa105bc-e0f5-48c1-935c-b91c0483a7d3
# ╠═6dc5694c-2e2f-462e-82fd-82be687042c9
# ╠═a78e79d5-70c6-4152-ade6-910225f17848
# ╠═a433ab43-7699-4748-ac4b-580e0d2ef62c
# ╠═6de850c1-1580-466b-a185-a354d9b3e753
# ╠═b3cf3da7-53e6-4496-b23e-387740a33243
# ╠═31681824-9fc8-444b-97e9-f6795fc5257e
# ╟─b8610d2b-b4f9-4c14-9744-a3ff8754f7e5
# ╟─0ae0f401-90b4-4780-b5a5-ea67db93e780
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
