### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ b4b7ed3f-43f4-479a-9913-519706c02a2f
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
	using Plots
	using LaTeXStrings
end

# ╔═╡ cec35ba2-6ec0-49a6-abbc-f4cc7ab68cb7
begin
	using DataFrames
	using XLSX
end

# ╔═╡ 0d6dda0d-ec3a-4a3a-ab1b-58f91084bc66
using SymPy

# ╔═╡ a272d501-5f4f-4f65-9f0d-8e7397935646
PlutoUI.TableOfContents(aside=true)

# ╔═╡ be0e4aa9-3c2c-4d71-914e-5c0c2a3797ca
md"""
#### Intializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ b129ba7c-953a-11ea-3379-17adae34924c
md"""# _Welcome to Applied Linear Algebra Course!_

# Lecture - 1

## _Introduction_

This course is meant to review some of the Linear Algebra topics that gained wide-spread use in Data Science and Machine Learning applications and to provide computational thinking for these topics with real life examples, albeit simple and tractible for students to follow and implement during the semester. Main goal is to give the students a good understanding of the basic ideas, as well as an appreciation for how they are used in many applications, including data fitting, classification, clustering, Markov model, Principle Component Analysis (PCA), machine learning, image processing like compression by Singular Value Decomposition (SVD) and Fourier Transform and its computation via Fast Fourier Transform.

!!! note 

	It is important to note that this course covers less mathematics than a typical course on applied linear algebra.

	This course and Math 107 cover complementary topics in applied linear algebra:

	- the course will be on a few linear algebra concepts, and many applications; However,
	- the focus of Math 107 is on concepts and basic theory of the algorithms.

"""


# ╔═╡ 0d7c9b1b-4799-4f6e-b0a4-def6c7408f78
md"Before we go into the topics and implementations of some Linear Algebra algortihms that will be covered during this course, it is important to state the rules and regulations of the on-line teaching 
"

# ╔═╡ 48c65f48-f31b-4d5d-acf5-bfa4c36f6a95
md"## _Disclaimer – On-Line Teaching_

1. The audio-visual recordings, presentations, readings, and any other works offered under the course materials aim to support remote and/or online learning. **They are only for the personal use of the students**.


2. **Further use of course materials other than the personal and educational purposes** as defined in this disclaimer, such as making copies, reproductions, replications, submission and sharing on different platforms including the digital ones or commercial usage **are strictly prohibited and illegal**.


3. **The persons violating the above-mentioned prohibitions can be subject to** the administrative, civil, and criminal sanctions under the Law on Higher Education Nr. 2547, the By-Law on Disciplinary Matters of Higher Education Students, the Law on Intellectual Property Nr. 5846, the Criminal Law Nr. 5237, the Law on Obligations Nr. 6098, and any other relevant legislation.


4. The academic expressions, views, and discussions in the course materials including the audio-visual recordings fall within the scope of the freedom of science and art.

"

# ╔═╡ 5af9b4df-93ac-468b-a23d-a47121cade0a
md"## _Julia Programing Language and Pluto Notebook_

We are going to use **Julia** on **Pluto** notebook that will facilitate interactive platform to implement matrix operations easily and visually:

**Pluto** is a programming environment for **Julia**, designed to be _interactive_ and _helpful_. It is somewhat similar to Jupyter Notebook, which can also be used for the implementation of matrix operations, though it is not interactive.

In the first lecture of Linear Algebra, I will go through the installation of Julia programing language and Pluto notebook environment, together with the basics of using Pluto. 

Note that the **Pluto** notebook is an interctive environment where it **changes while we work on it**."

# ╔═╡ 4d88b926-9543-11ea-293a-1379b1b5ae64
md"### Download Julia and Set up Pluto environment
Go to the offical **The Julia Programming Language** website _julialang.org_ and download _the current stable release_ that is suitable for your computer.

Once _Julia_ is downloaded and opened in REPL (Read–Eval–Print-Loop) environment,"


# ╔═╡ 90d44a05-15c2-4a4c-b665-0ded387a6a8d
# repl.png is in the same folder as Pluto_LA.jl, so no need for the complete path
repl = load("repl.png")

# ╔═╡ f48a0e46-ef4d-4b40-9702-4155ba681df2
md"you can type right square bracket ``]`` to switch to the **Package** platform, where you type **add Pluto** to install Pluto on your system. This step is done only once when you are installing Pluto package.

Then, type **back space** to get bact to the REPL environment, and type 
+ **import Pluto** and
+ **Pluto.run()**
to start Pluto Environment. Note that these two steps have to be implemented everytime when we use Pluto notebook, and they should be done on the REPL environment.
"

# ╔═╡ 998bf161-155e-47e6-9cd1-186e1c93690f
# If not in the same directory, the whole path has to be defined as 
# pluto_run = load("/Users/irsadiaksun/Dropbox/Pluto_Test/pluto_run.png")
pluto_run = load("pluto_run.png")

# ╔═╡ 8fab1792-a13c-470a-83eb-f8d67887e32e
md" Note that the **Pluto Notebook** will open in your default browser as shown below:"

# ╔═╡ 755b31d0-c2fb-4687-84c8-bc6cdf2cd34b
pluto_browser = load("pluto_browser.png")

# ╔═╡ dfe8d392-e180-459f-9633-316dfe99ea93
md"
With this interface, one can either open a **sample notebook** or **new notebook** or **open from file** in a local directory.

It is also possible to open one of the recent sessions again. For example, for this document I just clicked on ''Pluto_LA.jl'' from the list of **Recent sessions**."

# ╔═╡ 1e9b21e4-078e-4d3d-8dc2-908181f81267
md"### Intro to Pluto environment
Since Julia is a scripting language where one can type an operation and see the result, I will give a few simple arithmetic operations below and introduce what we mean by _interactive_ environment:"

# ╔═╡ 7d55c8f3-86a0-4769-8e99-4e3cc86f5399
a = 3

# ╔═╡ 3eb20ee8-3788-411c-bd97-78f898394dd1
md"Note that the result appears above the cell we have introduced the variable **a**, which is one of the features of Pluto that is different from other notebooks like Juypiter Notebook. Every instruction implemented by Pluto will appear above the cell and one can hide the code cell by clicking the ``eye`` sign on the left of the cell, which allows user to present a ``clean`` page with results only."

# ╔═╡ 0b83908b-1d88-4977-9c86-e3a92b3945f2
b = 3

# ╔═╡ 74d9ec92-8ac7-43cc-8b62-5b37746f61fa
c = a / b

# ╔═╡ 49d5cc44-655d-4fbd-95ca-909834a046a6
md"When we change the values of **a** or **b**, the value of **c** will be automatically updated, which is referred to as **_interactive_**. When you change a value in one cell, Pluto checks all the cells, find dependencies between cells and implement those cells to update the values. 

So let us do it a few times and observe how the value of **c** changes automatically."  

# ╔═╡ 15de3043-df23-43da-9ab4-ef2d37e1c469
d = b \ a

# ╔═╡ cd3b61e5-7882-47c3-82b2-cd5b425f3d5e
md"This is another way of writing the division in Julia; **a / b = b \ a**. Note that this is not a proper mathematical definition."

# ╔═╡ 4d970613-94f3-4918-964d-d62df499763a
md"Try assigning a new value for **a**, for example type **a = 5** and see what happens to the above expressions. 

Since the environment is interactive, Pluto can not allow multiple definitions for the same variable. So while writing the code on Pluto, one needs to be carefull not to assign new values to a variable. Note that this is not a Julia Programing requirement but it is of Pluto's interacvtive environment.

If you use Jupyter notebook, which is not interactive, you can assign new values for the same variable over and over again, making the presentation rather difficult to follow.

One downside of this _interactive_ platform is that sometimes it may evaluate a lot of cells just to give you the results of your latest input. As a remedy to this, Pluto team has recently introduced `Disable cell` option in the `Actions botton` seen on the right as a button with three dots on it."

# ╔═╡ c4dec3a3-6d20-4c09-85a8-f753cd3dc094
md"# Brief Review of Vectors and Matrices

## Vectors
Although most sophomore students have seen **vectors** in freshmen physics to show the direction of a quantity like _velocity_ in 2-Dimensional space as  
```math
{\bf v} = 3 {\it i} + 4 {\it j} \;\; meter/sec
```
where $i$ and $j$ are the unit vectors in $x$ and $y$ directions, hence $3 \, m/s$ and $4 \, m/s$ are the components of the velocity vector $\bf v$ in these directions, respectively.
"

# ╔═╡ d8a2533f-e241-4d1d-a939-8006b555daef
md" 

!!! note 

	We need to define such a vector in a programing language so that we can manipulate them and do some computations with them. In every programing language, they are defined by its components as an ordered array like 
	```math
	{\text v} = [3,4]
	```
	where ${\bf v}$ in this form is a column array in Julia.
"

# ╔═╡ ff2f7d91-2c71-4cf4-a8dc-75f18650088b
v1 = randn(Float64, 2) # A vector in R^2        

# ╔═╡ 6e305e2b-740b-4c92-9bcd-5a9b958f90a5
md" Note that `randn` generates a normally-distributed random number of type Float16, Float32, Float64 (default) or ComplexF64 with mean 0 and standard deviation 1. Since `Float64` is the defualt type, we usually use `randn(n)` to generate n dimenstional random vector.

Another random number generator is `rand`, generating a uniformly distributed random number between 0 and 1. You may wish to try `rand` in place of `randn` to see how the result will change.

Please note that there are more elaborate uses of both instructions, for which you  may refer to either `Live docs` sitting next to this notebook or web page help on Julia.
"

# ╔═╡ bba11c4b-87ca-448a-acd9-b718d2fc6ac8
v2 = randn(Float16,2) # Another vector in R^2        

# ╔═╡ 93625590-1e00-42f9-9ff0-a17d1eb2a286
md" Let us draw these two 2-vectors on a cartasian coordinate

$v_1 = [v_{11},v_{12}]$ is the blue vector, and

$v_2 = [v_{21},v_{22}]$ is the red vector:"

# ╔═╡ f6eef184-ae45-492e-8896-ae5e755a2b9e
begin

	x1_vals = [0 0 0.5 -0.5; v1[1] v2[1] v1[1]+0.5 v2[1]-0.5 ]
	y1_vals = [0 0 1.0 -1.0; v1[2] v2[2] v1[2]+1.0 v2[2]-1.0 ]

	# After importing LaTeXStrings package, L stands for Latex in the following expressions; L"v_1"
	plot(x1_vals, y1_vals, arrow = true, color = [:blue :red :blue :red],
     legend = :none, xlims = (-2, 2), ylims = (-2, 2),
	 annotations = [(v1[1], v1[2]-0.2, Plots.text(L"v_1", color="blue")),
		 			(v2[1], v2[2]-0.2, Plots.text(L"v_2", color="red")),
	 				(v1[1]+0.5, v1[2]+1.0-0.2, Plots.text(L"v_1", color="blue")),
	 				(v2[1]-0.5, v2[2]-1.0-0.2, Plots.text(L"v_2", color="red"))],
     xticks = -2:1:2, yticks = -2:1:2,
     framestyle = :origin)
end

# ╔═╡ 025a7287-b093-48a4-980c-f5174fc00f30
md" or in 3-Dimenstional space as 
```math
{\bf v} = 3 {\it i} + 4 {\it j} + 5 {\it k} \;\; meter/sec
```
where *i*, *j* and *k* are the unit vectors in *x*, *y* and *z* directions. 

As in the 2D case above, the velocity can be represented as a 3-element ordered array as follows:
```math
	{\text v} = [3,4,5]
```

Let us define two different 3D vectors and plot them as before:
" 

# ╔═╡ 4f0f0340-8cc2-4820-99a0-94b7e00b50ec
v3 = [-1, 1, 1] #randn(3) # A vector in R^3   

# ╔═╡ ca6394e7-c4d5-47e3-ab2a-c4df2d4a41c3
v4 = [1, 1, -1] #randn(3) # A vector in R^3  

# ╔═╡ 3479a317-d16f-4905-a0ec-1c9d6f342b2c
md" Let us draw these two 3-vectors on a cartasian coordinate system

$v_3 = [v_{31},v_{32},v_{33}]$ is the blue vector, and

$v_4 = [v_{41},v_{42},v_{43}]$ is the red vector:"

# ╔═╡ c9d0d206-08d7-40a9-a520-eae2c24bc477
begin
	
	x2_vals = [0 0 1 1; v3[1] v4[1] v3[1]+1 v4[1]+1]
	y2_vals = [0 0 1 -1; v3[2] v4[2] v3[2]+1 v4[2]-1]
	z2_vals = [0 0 1 -1; v3[3] v4[3] v3[3]+1 v4[3]-1]

	# After importing LaTeXStrings package, L stands for Latex in the following expressions; L"v_1"
	plot(x2_vals, y2_vals, z2_vals, lw = 2, color = [:blue :red :blue :red],    	
	legend = :none, xlims = (-2, 2), ylims = (-2, 2), zlims = (-2, 2),
	arrow = 2, 
     xticks = -2:1:2, yticks = -2:1:2, zticks = -2:1:2,
	 xlabel = L"x", ylabel = L"y", zlabel = L"z")
#     framestyle = :origin)
end

# ╔═╡ 0a2597c4-4b63-45b5-b170-a8af7d066ead
md"

!!! note 

	Could not insert **arrow** and **annotation** on the 3D plot. I will visit this problem again soon.
"

# ╔═╡ 4154d786-0a91-4c05-a159-5afc2b820fec
md"Note that in physics, quantities that have directional nature, like velocity, force, torque, etc., are represented by 3 numbers, at most, to define them uniquely with their components along *x*, *y* and *z* directions. However, for general problems in Linear Algebra, especially in ML applications, one encounters quantities that have much more than 3 defining components, usually represented by *n* dimensional vector (usually referred to as _array_) where *n* is the number of independent components to uniquely identify the quantity. 

What do we mean by a **_quantity with n independent components_**?

"

# ╔═╡ 4f30b1ac-195a-45dd-9cc8-aad4cbea0904
md" 
---
### A brief digression: Tables via DataFrame package

Consider that we are interested in house prices in a given city and collect data from real estate agencies in different neighborhoods with the intention of creating a database to analyze the house market in that city. For this problem, **_house_** is the quantity to be defined by independent components (referred to as properties' atributes or features) like, `location`, `sq meter`, `price`, `number of rooms`, `number of bedrooms`, `number of bathrooms`, `view`, `year built`, etc. Therefore, each house can be defined by many attributes that constitute the components of the array. 

To create/download/read a table, possibly with different types of entries, like numbers, strings etc., we need to import packages like `CSV` and `DataFrame`:

"

# ╔═╡ 74dab7c3-2ea3-4123-80df-6f4ec4e7e525
md" For example, the following data set is taken from the website
[kaggle.com] (https://www.kaggle.com/shivachandel/kc-house-data), which contains house sale prices for King County in USA, including Seattle. It includes homes sold between May 2014 and May 2015.

The dataset consisted of 21 variables and 21613 observations. Here are the variables (in ML terminology, they are referred to as `features`) that were used to uniquely identify individual houses:

- **id** : A notation for a house
- **date** : Date house was sold
- **price** : Price is prediction target
- **bedrooms** : Number of Bedrooms/House
- **bathrooms** : Number of bathrooms/bedrooms
- **sqft_living** : square footage of the home
- **sqft_lot** : square footage of the lot
- **floors** : Total floors (levels) in house
- **waterfront** :House which has a view to a waterfront
- **view** : Has been viewed
- **condition** :How good the condition is Overall
- **grade** : overall grade given to the housing unit, based on King County grading system
- **sqft_above** : Square footage of house apart from basement
- **sqft_basement** : Square footage of the basement
- **yr_built** : Built Year
- **yr_renovated** : Year when house was renovated
- **zipcode** : zip code
- **lat** : Latitude coordinate
- **long** : Longitude coordinate
- **sqft_living15** : Living room area in 2015(implies-- some renovations) This might or might not have affected the lotsize area
- **sqft_lot15** : lotSize area in 2015(implies-- some renovations) (the size of the land that your property is on)
"

# ╔═╡ c970ab26-9699-4d88-97bf-accd8705a4a0
df_house = DataFrame(XLSX.readtable("house_data.xlsx", "Sheet1")...);

# ╔═╡ 1c939645-80f1-4fe8-a497-62b7f22b833c
df_house_first = first(df_house,10)

# ╔═╡ cfb7c432-059b-4f25-8f03-33749c77f76a
df_house_slice = df_house[1:5,1:5]

# ╔═╡ bab3a996-d530-4346-9d7a-35c1f98bd4ff
md" 
**Slicing**: Here is the first five rows and columns of the data set: 
"

# ╔═╡ a74b56e5-3a2b-40e3-8e9b-ddf44ef3548c
names(df_house)

# ╔═╡ ee5d1450-fea6-4bf1-aaa4-905c1fe40ce8
df_house.price[1:5]

# ╔═╡ 9c8fbd1b-454a-4ee9-aaa8-8a2deddbb6d1
df_house.bedrooms[1:5]

# ╔═╡ 0e2b2370-85ad-4eb4-98b1-0452933634bf
size(df_house)

# ╔═╡ 7828f760-7344-4881-9d19-2fa3fe16781c
md" 

$\bf End \;of \;Digression$

---
"

# ╔═╡ d0657740-b31d-4efe-be23-dbfd356ac744
md" According to the vector termionology that we have introduced in 2D and 3D physics problems, *House* variable in this study consists of 21 independent parameters, like $x$, $y$ and $z$ components of the velocity in Physics. Therefore, each house is represented by an array of length 21. So, the vector in this case consists of 21 entries to uniquely identify a house out of 21613 houses in the data set. Each row of the table corresponds to a specific house and every one of them has 21 entries, as the vectors in 21 Dimensional space. 

"

# ╔═╡ 2cb76c55-488d-4b81-9ae3-dbec88f12deb
md"### Simple vector operations

#### Creating and adding two random vectors

Let us first create a random 5-vector (this is a notation to tell you that each vector consists of 5 elements and it is in 5 Dimensional space)

"

# ╔═╡ ec05fea5-62be-4e72-bf06-ce4d03720e0a
v5=randn(5) #vector in R^5 with each coordinate chosen randomly with mean 0 and standard deviation 1, using ``randn``

# ╔═╡ 5f6f9f8b-9b4a-4d80-b964-5e2c010e65fd
v6=rand(5) #vector in R^5 with each coordinate chosen randomly between 0 and 1, using ``rand``

# ╔═╡ 9e7ebf4c-e911-494d-ad0b-d60019992694
v5 + v6  # Adds the corresponding elements in each vector   

# ╔═╡ 7f0c9ebb-ddfc-4ef9-a4a4-48999fca4138
v5 - v6  # Subtract the corresponding elements of v6 from the elements of v5

# ╔═╡ 2f789cee-c839-4199-8495-93f21be66c3c
md" Vector addition is commutatlive, that is $v_5 + v_6 = v_6 + v_5$
"

# ╔═╡ 6fb72be7-d743-4509-88a5-b3a44f67634d
(v5+v6) == (v6+v5)

# ╔═╡ df0aae44-d5e4-4152-8707-9f339875ece1
(v5+v6) .== (v6+v5)

# ╔═╡ 615a31bb-9c90-488f-b32a-ebc25be60e73
md" We can also ''prove'' this using symbolic computation: "

# ╔═╡ 0a71cc8b-81f0-4d8e-80fa-e5a513ef0087
# Create a symbolic vector v
  v = [symbols("v$i") for i=1:5 ]

# ╔═╡ b7c7c68d-a57e-4b80-b06a-37ffedb74471
# Create a symbolic vector w
  w = [symbols("w$i") for i=1:5 ]

# ╔═╡ 8246858b-9574-4e7e-a876-865db8a23dcf
v+w    

# ╔═╡ 3cebd8ed-a4fc-47e6-972a-84d831cd301a
w+v

# ╔═╡ 6b7da470-d709-4843-9ade-7d7faeb3b4a0
v + w == w + v        

# ╔═╡ 9162c574-1b3d-4660-8369-2cc16f545f44
md"
---
#### Visualizing vector addition (in 2D)

 ${\bf u_1}=(x_1,y_1)$ is the blue vector, \
 ${\bf u_2}=(x_2,y_2)$ is the red vector, \
 the sum is the green vector, ${\bf u_1 + u_2} =(x_1+x_2, y_1+y_2)$.
"

# ╔═╡ 3cd4208b-4b1c-4d7c-afdb-e6d2addda3cb
begin
	x1=2; 
	y1=1;
	x2=1;
	y2=3;

	x_vals = [0 0 x1 x2 0 ; x1 x2 (x1+x2) (x1+x2) (x1+x2)]
	y_vals = [0 0 y1 y2 0 ; y1 y2 (y1+y2) (y1+y2) (y1+y2)]

	plot(x_vals, y_vals, arrow = true, color = [:blue :red :blue :red :green],
     legend = :none, xlims = (-5, 5), ylims = (-5, 5),
     annotations = [(x1+0.5, y1-0.3, "($x1, $y1)"),
                    (x2, y2+0.4, "($x2, $y2)"),
                    ((x1+x2+0.5), (y1+y2), "($(x1+x2), $(y1+y2))")],
     xticks = -5:1:5, yticks = -5:1:5,
	 xlabel = L"x", ylabel = L"y",
     framestyle = :zerolines) #try framestyle = :origin
end

# ╔═╡ 2647fcc9-9d4f-43a6-9712-210bcbf9be3f
md" 
 	${\bf u_1}$ =( $x1 , $y1 ),  
  
 	${\bf u_2}$ =( $x2 , $y2 ), 
  
 	${\bf u_1} + {\bf u_2}$ = ( $x1 + $x2 , $y1 + $y2  )

---
"

# ╔═╡ f7f08d7b-d8a2-4b13-82d5-9b56202a04fc
md" #### Scalar multiplication

For a given vector $\bf v$ = [$v_1, v_2, v_3, v_4, v_5$] and a scalar $c$, 

 $c \bf v$ = [$c v_1, c v_2, c v_3, c v_4, c v_5$].

That is, the scalar multiplies all the entries of the vector.
"

# ╔═╡ 258c4aec-c706-4a6d-a3dc-8dbf736cb04b
md"
Scalar multiplication distributes over vector addition: Here we subtract $c({\bf y +  z}) - (c{\bf y} + c{\bf z})$ for a random choice of $c$, $\bf y$ and $\bf z$.  Note that the expression should result in zero, but there might be tiny rounding errors!
"

# ╔═╡ cded91d4-baf0-46c2-a341-872202a8472c
md" 
**Vector substraction** is nothing but scalar multiplication of a vector and adding to another. For example, let us say we would like to subtract ${\bf u_3}=(x_3,y_3)$ from ${\bf u_4}=(x_4,y_4)$, then

${\bf u_3} + (-1) {\bf u_4}=(x_3,y_3) + (-1) (x_4,y_4) = (x_3-x_4,y_3-y_4)$

"

# ╔═╡ b750f433-babe-40ec-9587-7650c56870d3
md"
### Resources

* julialang.org (web page) [Download Julia](https://julialang.org)
* How to install Julia and Pluto (Youtube) [Intro to Pluto ](https://www.youtube.com/watch?v=OOjKEgbt8AI)
* Pluto - One year later (Youtube) [Pluto](https://www.youtube.com/watch?v=HiI4jgDyDhY)
"

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
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
XLSX = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
DataFrames = "~1.3.1"
FileIO = "~1.12.0"
HypertextLiteral = "~0.9.3"
ImageIO = "~0.6.0"
ImageShow = "~0.3.3"
LaTeXStrings = "~1.3.0"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
SymPy = "~1.1.2"
XLSX = "~0.7.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0-beta3"
manifest_format = "2.0"
project_hash = "dc161916012e6e51b9eb100361c78126691ef7bb"

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

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "926870acb6cbcf029396f2f2de030282b6bc1941"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.4"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "6b6f04f93710c71550ec7e16b650c1b9a612d0b6"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.16.0"

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

[[deps.CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[deps.CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.Crayons]]
git-tree-sha1 = "b618084b49e78985ffa8422f32b9838e397b9fc2"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.0"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "cfdfef912b7f93e4b848e80b9befdf9e331bc05a"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.1"

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
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

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
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "67551df041955cc6ee2ed098718c8fcd7fc7aebe"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.12.0"

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
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

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
deps = ["FileIO", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "816fc866edd8307a6e79a575e6585bfab8cef27f"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.0"

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

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "22df5b96feef82434b07327e2d3c770a9b21e023"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

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
git-tree-sha1 = "f755f36b19a5116bb580de457cda0c140153f283"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.6"

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
git-tree-sha1 = "6d105d40e30b635cfed9d52ec29cf456e27d38f8"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.12"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "92f91ba9e5941fc781fecf5494ac1da87bdac775"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.0"

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
git-tree-sha1 = "68604313ed59f0408313228ba09e79252e4b2da8"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.2"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "db7393a80d0e5bef70f2b518990835541917a544"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "5c0eb9099596090bb3215260ceca687b888a1575"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.30"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

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
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "71fd4022ecd0c6d20180e23ff1b3e05a143959c2"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.0"

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
git-tree-sha1 = "e08890d19787ec25029113e88c34ec20cac1c91e"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.0.0"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "2ae4fe21e97cd13efd857462c1869b73c9f61be3"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.2"

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

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "8f8d948ed59ae681551d184b93a256d0d5dd4eae"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.2"

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

[[deps.VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

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

[[deps.XLSX]]
deps = ["Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "96d05d01d6657583a22410e3ba416c75c72d6e1d"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.7.8"

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

[[deps.ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "3593e69e469d2111389a9bd06bac1f3d730ac6de"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.9.4"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

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
# ╠═a272d501-5f4f-4f65-9f0d-8e7397935646
# ╠═be0e4aa9-3c2c-4d71-914e-5c0c2a3797ca
# ╠═b4b7ed3f-43f4-479a-9913-519706c02a2f
# ╟─b129ba7c-953a-11ea-3379-17adae34924c
# ╠═0d7c9b1b-4799-4f6e-b0a4-def6c7408f78
# ╟─48c65f48-f31b-4d5d-acf5-bfa4c36f6a95
# ╟─5af9b4df-93ac-468b-a23d-a47121cade0a
# ╠═4d88b926-9543-11ea-293a-1379b1b5ae64
# ╟─90d44a05-15c2-4a4c-b665-0ded387a6a8d
# ╟─f48a0e46-ef4d-4b40-9702-4155ba681df2
# ╠═998bf161-155e-47e6-9cd1-186e1c93690f
# ╠═8fab1792-a13c-470a-83eb-f8d67887e32e
# ╠═755b31d0-c2fb-4687-84c8-bc6cdf2cd34b
# ╠═dfe8d392-e180-459f-9633-316dfe99ea93
# ╠═1e9b21e4-078e-4d3d-8dc2-908181f81267
# ╠═7d55c8f3-86a0-4769-8e99-4e3cc86f5399
# ╠═3eb20ee8-3788-411c-bd97-78f898394dd1
# ╠═0b83908b-1d88-4977-9c86-e3a92b3945f2
# ╠═74d9ec92-8ac7-43cc-8b62-5b37746f61fa
# ╠═49d5cc44-655d-4fbd-95ca-909834a046a6
# ╠═15de3043-df23-43da-9ab4-ef2d37e1c469
# ╠═cd3b61e5-7882-47c3-82b2-cd5b425f3d5e
# ╠═4d970613-94f3-4918-964d-d62df499763a
# ╠═c4dec3a3-6d20-4c09-85a8-f753cd3dc094
# ╠═d8a2533f-e241-4d1d-a939-8006b555daef
# ╟─ff2f7d91-2c71-4cf4-a8dc-75f18650088b
# ╟─6e305e2b-740b-4c92-9bcd-5a9b958f90a5
# ╠═bba11c4b-87ca-448a-acd9-b718d2fc6ac8
# ╟─93625590-1e00-42f9-9ff0-a17d1eb2a286
# ╠═f6eef184-ae45-492e-8896-ae5e755a2b9e
# ╟─025a7287-b093-48a4-980c-f5174fc00f30
# ╠═4f0f0340-8cc2-4820-99a0-94b7e00b50ec
# ╟─ca6394e7-c4d5-47e3-ab2a-c4df2d4a41c3
# ╠═3479a317-d16f-4905-a0ec-1c9d6f342b2c
# ╟─c9d0d206-08d7-40a9-a520-eae2c24bc477
# ╟─0a2597c4-4b63-45b5-b170-a8af7d066ead
# ╟─4154d786-0a91-4c05-a159-5afc2b820fec
# ╠═4f30b1ac-195a-45dd-9cc8-aad4cbea0904
# ╠═74dab7c3-2ea3-4123-80df-6f4ec4e7e525
# ╠═cec35ba2-6ec0-49a6-abbc-f4cc7ab68cb7
# ╠═c970ab26-9699-4d88-97bf-accd8705a4a0
# ╠═1c939645-80f1-4fe8-a497-62b7f22b833c
# ╠═cfb7c432-059b-4f25-8f03-33749c77f76a
# ╠═bab3a996-d530-4346-9d7a-35c1f98bd4ff
# ╠═a74b56e5-3a2b-40e3-8e9b-ddf44ef3548c
# ╠═ee5d1450-fea6-4bf1-aaa4-905c1fe40ce8
# ╠═9c8fbd1b-454a-4ee9-aaa8-8a2deddbb6d1
# ╠═0e2b2370-85ad-4eb4-98b1-0452933634bf
# ╠═7828f760-7344-4881-9d19-2fa3fe16781c
# ╠═d0657740-b31d-4efe-be23-dbfd356ac744
# ╠═2cb76c55-488d-4b81-9ae3-dbec88f12deb
# ╠═ec05fea5-62be-4e72-bf06-ce4d03720e0a
# ╠═5f6f9f8b-9b4a-4d80-b964-5e2c010e65fd
# ╠═9e7ebf4c-e911-494d-ad0b-d60019992694
# ╠═7f0c9ebb-ddfc-4ef9-a4a4-48999fca4138
# ╠═2f789cee-c839-4199-8495-93f21be66c3c
# ╠═6fb72be7-d743-4509-88a5-b3a44f67634d
# ╠═df0aae44-d5e4-4152-8707-9f339875ece1
# ╠═615a31bb-9c90-488f-b32a-ebc25be60e73
# ╠═0d6dda0d-ec3a-4a3a-ab1b-58f91084bc66
# ╠═0a71cc8b-81f0-4d8e-80fa-e5a513ef0087
# ╠═b7c7c68d-a57e-4b80-b06a-37ffedb74471
# ╠═8246858b-9574-4e7e-a876-865db8a23dcf
# ╠═3cebd8ed-a4fc-47e6-972a-84d831cd301a
# ╠═6b7da470-d709-4843-9ade-7d7faeb3b4a0
# ╠═9162c574-1b3d-4660-8369-2cc16f545f44
# ╠═3cd4208b-4b1c-4d7c-afdb-e6d2addda3cb
# ╟─2647fcc9-9d4f-43a6-9712-210bcbf9be3f
# ╠═f7f08d7b-d8a2-4b13-82d5-9b56202a04fc
# ╟─258c4aec-c706-4a6d-a3dc-8dbf736cb04b
# ╟─cded91d4-baf0-46c2-a341-872202a8472c
# ╠═b750f433-babe-40ec-9587-7650c56870d3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
