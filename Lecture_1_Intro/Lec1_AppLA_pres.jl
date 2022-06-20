### A Pluto.jl notebook ###
# v0.19.9

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

# ╔═╡ f7c985b3-731b-4c56-afdb-4c67f47d9c94
using ImageTransformations

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

# ╔═╡ fbbedfd3-264b-4dd5-84f9-67c9f674b3f6
html"""<button onclick="present()">present</button>"""

# ╔═╡ be0e4aa9-3c2c-4d71-914e-5c0c2a3797ca
md"""
#### Intializing packages

_When running this notebook for the first time, this could take a little longer, a few minutes. Hang in there!_
"""

# ╔═╡ a272d501-5f4f-4f65-9f0d-8e7397935646
PlutoUI.TableOfContents(aside=true)

# ╔═╡ b8171bbb-d3f4-4236-9d77-3ccffd6d4613
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

# ╔═╡ 48c65f48-f31b-4d5d-acf5-bfa4c36f6a95
md"# _Disclaimer – On-Line Teaching_

1. The audio-visual recordings, presentations, readings, and any other works offered under the course materials aim to support remote and/or online learning. **They are only for the personal use of the students**.


2. **Further use of course materials other than the personal and educational purposes** as defined in this disclaimer, such as making copies, reproductions, replications, submission and sharing on different platforms including the digital ones or commercial usage **are strictly prohibited and illegal**.


3. **The persons violating the above-mentioned prohibitions can be subject to** the administrative, civil, and criminal sanctions under the Law on Higher Education Nr. 2547, the By-Law on Disciplinary Matters of Higher Education Students, the Law on Intellectual Property Nr. 5846, the Criminal Law Nr. 5237, the Law on Obligations Nr. 6098, and any other relevant legislation.


4. The academic expressions, views, and discussions in the course materials including the audio-visual recordings fall within the scope of the freedom of science and art.

---
"

# ╔═╡ e4e67907-bab7-4775-bc4d-1072de1faad0
md"# Motivation

* **Linear Algebra** has been a topic for math-savvy students and taught only in Science and Engineering programs since its foundation in 1600's.


* However, **in today's world, data is everywhere** and methods from Linear Algebra help decipher the underlying story of data in every field. 


* **Social sciences, administrative sciences, medicine, law, in addition to engineering and sciences, have all been inundated with data and data-centric approaches**.


* Therefore, **it is only natural that the processed data by the methods of linear algebra would make sense to the people trained in the specific field** of the data much better.


* Consequently, those who are trained in any field, that is **everyone, need to understand the tools**, as well as their working principles, in order to work on and make sense out of the pre-processed and processed data. Hence

#### Applied Linear Algebra for Everyone 
---
"

# ╔═╡ 5f6a7a63-dbda-45c1-8505-84e2861f9c60
md"# Goal and Requirements

**The main goal of this course** is to help students, professionals and researchers in any field to be literate in data manipulations using the tools from Linear Algebra. 

Hence, the students would **gain a good understanding of the basic ideas**, as well as an **_appreciation for how they are used in many applications_**, including
  
  - data fitting,
  - classification,
  - clustering,
  - Markov model,
  - Principle Component Analysis (PCA),
  - machine learning (neural net and gradient descent),
  - image processing,
  - Linear programming,
  - ...

---
"

# ╔═╡ 112c4c4f-7990-4336-ad37-5fa6b0874024
md"""#

**Applied Linear Algebra for Everyone** has been prepared (still ongoing) with the following **mindset and expectations**:. 


* it **uses the Julia programming language on the Pluto notebook** as the teaching and application environment; 


* it **does not require any prerequisite** to follow and learn the materials, just enough motivation and perseverance would suffice; 


* the lecture notebooks on Pluto will **include single line codes (occasionally a few lines would be needed)**, markdown texts and necessary equations (not many); 


* it mainly **emphasizes the concepts and intuitions with many examples and applications** rather than math foundations of the methods;


* **for curious and math oriented people, and for some who are willing to invest a little more**, there will be brief intros and a few handworked examples of some methods that are considered to be important and fundamental for the understanding and building intuitions of the concepts.

!!! note

	It is important to note that this course covers less mathematics than a typical course on applied linear algebra.

	This course and Math 107 cover complementary topics in applied linear algebra:

	- the course will be on a few linear algebra concepts, and many applications; However,
	- the focus of Math 107 is on concepts and basic theory of the algorithms.

---
"""

# ╔═╡ d6c8c0b8-fd89-4a7e-98c3-f1741aa057a1
md"# Inspiration

A few pioneers have been teaching similar courses (mostly available online) and written excellent books on the fundamentals, applications and importance of Linear Algebra.

Here I would like to name a few who have inspired me to embark on this project:

* First and foremost, **_Prof. William Gilbert Strang_** from MIT,
  - inspiring lectures on Linear Algebra, talks on the importance of Linear Algebra for everyone, all available on YouTube;  
  - book titled `Linear Algebra for Everyone`, and 
  - assessment of linear algebra to be simpler and more accessible than Calculus. 


*  **_Prof. Stephen P. Boyd_** from Stanford University, 
  - lectures on _Introduction to Applied Linear Algebra_ on youtube;  
  - the [course materials on the webpage] (https://stanford.edu/class/engr108); 
  - textbook [`Introduction to Applied Linear Algebra - Vectors, Matrices, and Least Squares`] (https://web.stanford.edu/~boyd/vmls/) available online, 
  - [`Julia Language Companion`] (https://web.stanford.edu/~boyd/vmls/vmls-julia-companion.pdf) and lecture slides. 


*  **_Profs. Alan Edelman, David P. Sanders & Charles E. Leiserson_** from MIT, 
  - lectures on _Introduction to Computational Thinking_, delivered online on the Pluto notebook, 
  - videos of lectures, homeworks, cheatsheets, all are available on the [webpage of the course] (https://computationalthinking.mit.edu/Spring21/).

---
"

# ╔═╡ 534234e3-e8a3-4d8d-a905-9dc6c59baf8d
md"# Content of the course

> #### Lecture 1: Vectors 

> #### Lecture 2: Matrices

> #### Lecture 3: Clusstering

> #### Lecture 4: Least Squares
>> ##### Lecture 4.1: Linear Regression
>> ##### Lecture 4.2: Polynomial and piecewise fit
>> ##### Lecture 4.3: Classification

> #### Lecture 5: Eigenvalues and Eigenvectors

> #### Lecture 6: Factorization
>> ##### Lecture 6.1: LU, QR and QΛQ^T
>> ##### Lecture 6.2: Singular Value Decomposition (SVD)

> #### Lecture 7: Principal Component Analysis (PCA)

> #### Lecture 8: Neural Nets: Biological to Artificial

> #### Lecture 9: Gradient descent and its variants (??)

> #### Lecture 10: Linear programming (??)
---
"

# ╔═╡ 01797703-30fb-42e7-893a-faa5883fea10
md"# Lecture - 1: Vectors

### Content 

> ##### 1.1. Installing Julia and Pluto

> ##### 1.2. Brief Review of vectors
>> ##### 1.2.1. Vectors in physics (2D and 3D)
>> ##### 1.2.2. Vectors in general
>>> #####  Brief digression: Dataframes
>> ##### 1.2.3. Simple vector operations
>>> ##### Add, subtract and multiply
>> ##### 1.2.4. A few definitions
>>> ##### Length and distance
>>> ##### Norm

>> ##### 1.3. Relevant applications
>>> ##### 1.3.1. Sum, Mean, RMS value
>>> ##### 1.3.2. De-meaned vector, Standart deviation
>>> ##### 1.3.3. Standardization
>>> ##### 1.3.4. Correlation coefficient
>>> ##### 1.3.5. Projection

---
"

# ╔═╡ 5af9b4df-93ac-468b-a23d-a47121cade0a
md"# 1.1. Julia & Pluto


* Throughout the course, we are going to use **_Julia_** programing language on **_Pluto_** notebook.


* In the first lecture, I will go through the installation of Julia programing language and Pluto notebook environment, together with the basics of using Pluto notebook.


### Why Julia?

* **_Julia_** was launched as an open-source programing language in 2012 by a group at MIT. 


* From the start, the **_Julia_** programming language was built for scientific and numerical computation with the speed comparable to ``C`` and ``Fortran`` and with the ease of learning comparable to ``Python``, ``Matlab``, ``R`` and other scripting languages. 


* Its math-friendly syntax makes it easy for users of ``Matlab``, ``Mathematica``, ``Octave`` and ``R`` to adapt.


* It started and is still being developed as a tool for efficient and fast computations required in data science problems and in implementations of machine learning algorithms, as well as in all sorts of numerical computations arisen in different fields.

### Benchmark Julia
"

# ╔═╡ f002d8e5-821a-485c-8a13-0c198935c955
load("benchmark.png")

# ╔═╡ 4d88b926-9543-11ea-293a-1379b1b5ae64
md"""# 
### Download Julia
	
 * Go to the offical **_The Julia Programming Language_** website 		**_julialang.org_** and download _the current stable release_ that is suitable for your computer.
	
 * Once **_Julia_** is downloaded and opened in `REPL` (`R`ead–`E`val–`P`rint-`L`oop) environment, as shown below, perform a simple algebraic computation like ``2+5`` as a regular calculator just to verfy that it is properly downloaded:
   
"""

# ╔═╡ 90d44a05-15c2-4a4c-b665-0ded387a6a8d
# repl.png is in the same folder as Pluto_LA.jl, so no need for the complete path
repl = load("repl.png")

# ╔═╡ 3e1dba04-ee47-4439-a6fa-71a4bf7ea32a
md""" 

!!! note 

	You can do any operation that you could in a **_julia_** code on the `REPL` environment
 
"""

# ╔═╡ b956d523-8f52-4b9b-8885-6c77b9e64c7a
md"""## 1.1.1. Pluto Notebook

* **_Pluto_** is a programming environment for **_Julia_**, designed to be _interactive_ and _helpful_; somewhat similar to **_Jupyter_** notebook.
 

!!! note

	**_Pluto_** notebook is an interctive environment and **changes while working on it**.

!!! note \"Notebook vs IDE\"
	* **Notebooks** are files which supports the use of computer codes and text elements and images.
	* **Integrated Development Environments** (IDE) are software for building applications with the different tools for writing a program such as source code editor and code debugger.

"""

# ╔═╡ f48a0e46-ef4d-4b40-9702-4155ba681df2
md"### Set up Pluto environment

* **_Pluto_** is a package that runs on Julia:

  + Switch to **Package** platform by typing right square bracket ``]``, then

  + type **add Pluto** to install Pluto on your system.
!!! note
	This step is done only once when you are installing Pluto package.

Then, type **back space** to get bact to the `REPL` environment, and type 
+ **import Pluto** and
+ **Pluto.run()**
to start Pluto Environment, as shown below.

!!! note 
	These two steps have to be implemented everytime when you use **_Pluto_** notebook.
"

# ╔═╡ 8fab1792-a13c-470a-83eb-f8d67887e32e
md"#
### User Interface
Note that the **Pluto Notebook** will open in your default browser as shown below:"

# ╔═╡ 755b31d0-c2fb-4687-84c8-bc6cdf2cd34b
pluto_browser = load("pluto_browser.png");

# ╔═╡ ecc2af82-2446-4164-b605-d307cae3bdfd
@bind pluto_rows RangeSlider(1:size(pluto_browser)[1])

# ╔═╡ 84de5da7-e014-448b-9ad9-ef86d4cee3d3
pluto_browser[pluto_rows,:]

# ╔═╡ dfe8d392-e180-459f-9633-316dfe99ea93
md"#

You may wish to open
* a **_sample notebook_** to study and learn notebook environment, or
* a **_new notebook_** to start writing your code, or
* a file from a local directory or a webpage.
OR
* one of the recent sessions again from the list of **_Recent sessions_**.

---
"

# ╔═╡ a56c4db6-8d98-4c58-9862-97bfb57f430b
pluto_browser[pluto_rows,:]

# ╔═╡ 1e9b21e4-078e-4d3d-8dc2-908181f81267
md"#
### Interactivity
Since Julia is a scripting language where one can type an operation and see the result, I will give a few simple arithmetic operations below and introduce what we mean by _interactive_ environment:

!!! note 

	* Results appear above the cell in Pluto environment, different from other notebooks like **_Juypiter Notebook_**. 
	
	* You can hide the code cell by clicking the ``eye`` sign on the left of the cell, which allows user to present a ``clean`` page with results only.

!!! important 

	When you change a value in one cell, **_Pluto_** checks all the cells, find dependencies between cells and implement those cells to update the values. 

"

# ╔═╡ 4d970613-94f3-4918-964d-d62df499763a
md"
``Example-1:``
* Assign values for ``a`` and ``b``, and calculate ``c=a/b``,
* then, change ``a`` or ``b`` as you wish and observe.
"

# ╔═╡ 7e054d5e-badd-48e4-b9e2-5ed0aa85de26
a = rand((1:5),1)

# ╔═╡ b40e4488-9409-4a35-b979-f437a54a8276
b = rand((1:5),1)

# ╔═╡ c912c3cf-cd26-4a1a-9189-3d762da321a7
c = a/b

# ╔═╡ 856da551-1a93-4baf-8ef6-5946c225f2cd
md" ``Example-2:`` Did you notice another example of **_interactivity_** before?"

# ╔═╡ 7db34f43-0777-4cc3-a070-8f53a68cdca3
md"
* Try assigning a new value for ``a`` in another cell, for example type ``a = 5`` and see what happens.

  `` $ \bf What \;do \;you \;think?$`` 
"

# ╔═╡ 1b6b35ab-c02a-4d40-8740-ca39c622260e
md"
* Pluto can not allow multiple definitions for the same variable; ``\bf WHY?``


* While writing a code on Pluto, you need to be carefull not to assign new values to an existing variable.

!!! caution 

	This is not a Julia Programing requirement but it is of Pluto's interactive environment.
"

# ╔═╡ 1417c2e3-2749-4fac-b008-520f89d23503
md"# 
### Issues

* Not being able to assign new values to already used variables may make the programing difficult for some.


* Pluto may evaluate a lot of cells just to show you the results of your latest input.
  + As a remedy `Disable cell` option has been introduced in the `Actions botton` seen on the right as a button with three dots on it.


* 
"

# ╔═╡ c4dec3a3-6d20-4c09-85a8-f753cd3dc094
md"# 1.2. Brief Review of Vectors

"

# ╔═╡ 70f17fd5-c54d-4888-b745-9ac48bf7efb9
md"
>Here is a nice overview of **_Vectors_** by 3-Blue-1-Brown (Grant Sanderson) for your reference. I strongly recommend you to watch it and try to understand the intuitive picture of the concept rather than the mathematical details.
"

# ╔═╡ 001b6077-9659-472c-8975-192465264100
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/fNk_zzaMoSs" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 93134e1f-4cec-4f05-8f18-6428a26afaf8
md"""

## 1.2.1. Why do we need vectors?


It is all about **defining a quantity uniquely** so that we can understand, comprehend and use them in our daily lives. Here are a few examples:

* certain objects need **real numbers**, like 
  - a person's weight and height, I am 75kg and 1.8m tall
  - when shopping, you need to quantify the food like 1.5 kg of cheese, 2 kg of orange etc.
  - when driving, the speed of a car may be about 65 km/h or 100 km/h
  - your age may be defined as 21 or 21.5 years old
  - ...


* Some others may be defined using only **integer numbers** like
  - number of courses you take may be 5 or 6 
  - a student's rank in the class, 1st, 10th, ..
  - number of books you carry daily on average
  - ...


* Some others may be defined using **Boolean data type** like 
  - rain, snow and other weather conditions usually defined by "YES" or "NO", 
  - pass or fail is like '1:Pass' or '0:Fail'
  - having a hearth deases is '1:YES' or '0:NO'
  - ...


* Meanwhile, some others like displacement, velocity, force may **need more than one number** for their unique definitions, like
  - for a velocity of a car, we need its speed as well as its direction
  - your location on the campus, we need more than a distance from the student center
  - if you are pushing an object with a force, we need not only its magnitude but also its direction 
  - price of a house is defined by many parameters, like square meter, number of rooms and bathrooms, location, etc..


!!! note
	When we need more than one number to define a quantity, we usually use vector (also called as array) notation.

**Vectors in freshmen physics:** _Velocity_ (`` \bf v``), _Accelaration_ (`` \bf a``), _Force_ (`` \bf F``), etc..
For example:
```math
{\bf v} = 3 {\it i} + 4 {\it j} = (3,4) \;\; meter/sec {\rm \;\; in\;2D\;space,\;or}
``` 
```math
{\bf F} = 10 {\it i} + 20 {\it j} + 30 {\it k} = (10, 20, 30) \;\; Newton {\rm \;\; in\;3D\;space.}
``` 
where $i$, $j$ and $k$ are the unit vectors in $x$, $y$ and $z$ directions, respectively.
"""

# ╔═╡ d8a2533f-e241-4d1d-a939-8006b555daef
md" 

!!! note 

	In a programing language, we define vectors as ordered arrays like
	```math
	{\text v} = [3,4]
	``` ```math
	{\text F} = [10,20,30]
	```
	where ${\bf v}$ and ${\bf F}$ are column arrays in **_Julia_**.
"

# ╔═╡ 93625590-1e00-42f9-9ff0-a17d1eb2a286
md"#
### Examples

##### Let us draw 2-vectors on the cartasian coordinate

``v_1 = [v_{11},v_{12}] \rm {\color{blue} \;is \;the \;blue \;vector}, \;and``
``v_2 = [v_{21},v_{22}] \rm {\color{red} \;is \;the \;red \;vector}:``
"

# ╔═╡ ff2f7d91-2c71-4cf4-a8dc-75f18650088b
begin
	v1 = rand((-2:0.2:2),2) # A vector in R^2 
	v2 = rand((-2:0.2:2),2) # Another vector in R^2  
	md" $\bf v_1=$", v1, md" $\bf v_2=$", v2
end

# ╔═╡ f6eef184-ae45-492e-8896-ae5e755a2b9e
begin

	x1_vals = [0 0 0.5 -0.5; v1[1] v2[1] v1[1]+0.5 v2[1]-0.5 ]
	y1_vals = [0 0 1.0 -1.0; v1[2] v2[2] v1[2]+1.0 v2[2]-1.0 ]

	# After importing LaTeXStrings package, L stands for Latex in the following expressions; L"v_1"
	plot(x1_vals, y1_vals, arrow = true, color = [:blue :red :blue :red],
     legend = :none, xlims = (-3, 3), ylims = (-3, 3),
	 annotations = [(v1[1], v1[2]-0.2, Plots.text(L"v_1", color="blue")),
		 			(v2[1], v2[2]-0.2, Plots.text(L"v_2", color="red")),
	 				(v1[1]+0.5, v1[2]+1.0-0.2, Plots.text(L"v_1", color="blue")),
	 				(v2[1]-0.5, v2[2]-1.0-0.2, Plots.text(L"v_2", color="red"))],
     xticks = -3:1:3, yticks = -3:1:3,
     framestyle = :origin)
end

# ╔═╡ 025a7287-b093-48a4-980c-f5174fc00f30
md"#

##### Let us draw 3-vectors on the cartasian coordinate

``{\color{blue} {\bf v_3} = [v_{31},v_{32},v_{33}] \rm \;is \;the \;blue \;vector}, \;and\;``
``{\color{red} {\bf v_4}= [v_{41},v_{42},v_{43}] \rm \;is \;the \;red \;vector}:``
" 

# ╔═╡ 4f0f0340-8cc2-4820-99a0-94b7e00b50ec
begin
	v3 = rand((-2:0.2:2),3) #[-1, -1, 1] #randn(3) # A vector in R^3  
	v4 = rand((-2:0.2:2),3) #[-1, 1, -1] #randn(3) # A vector in R^3 
	md" $\color{blue} \bf v_3=$", v3, md" $\color{red} \bf v_4=$", v4
end

# ╔═╡ c9d0d206-08d7-40a9-a520-eae2c24bc477
begin
	
	x2_vals = [0 0 1 1; v3[1] v4[1] v3[1]+1 v4[1]+1]
	y2_vals = [0 0 1 1; v3[2] v4[2] v3[2]+1 v4[2]+1]
	z2_vals = [0 0 1 1; v3[3] v4[3] v3[3]+1 v4[3]+1]

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
md""" 
## 1.2.2. Vectors in general
* Quantities in physics are represented by ``3`` numbers, at most, to define them uniquely.


* Quantities in general problems can be defined uniquely by more than ``3`` numbers.

  + In most Linear Algebra applications, especially in Data Science applications, one encounters quantities that have 1000's of defining components.
  + Usually represented by ``n`` dimensional vectors (referred to as _arrays_) where ``n`` is the number of independent components to uniquely identify the quantity. 

#### Quantities with n independent components?

"""

# ╔═╡ d7ef1697-b832-4038-9d9f-512a74094fca
md"#

#### Example:

`House` is a quantity to be defined by many independent components (referred to as properties, atributes or features) like, 
* `location`, 
* `sq meter`,
* `price`,
* `number of rooms`,
* `number of bedrooms`,
* `number of bathrooms`,
* `view`,
* `year built`,
* ...
  
Therefore, each house can be defined by many attributes that constitute the components of the array. 

!!! note
	Attributes are not necessarily numerical, could be alphanumeric (=string)
"

# ╔═╡ 4f30b1ac-195a-45dd-9cc8-aad4cbea0904
md"# 
### A brief digression: DataFrame package

The following data set is taken from the website
[kaggle.com] (https://www.kaggle.com/shivachandel/kc-house-data), which contains house sale prices for King County in USA, including Seattle.

* The dataset consisted of 21 variables and 21613 observations:
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

# ╔═╡ a2a0aa9d-c6a7-4b72-8f77-5dcd1123732d
md"""#
#### Read, store and manipulate the table 

Let us first read and assign the table to a `variable`: 

**To read and store**
* need to **_know the format of the table_**; CSV, XLSX, etc..
* need to **_import the necessary packages_**; CSV, XLSX, DataFrames
"""

# ╔═╡ c970ab26-9699-4d88-97bf-accd8705a4a0
df_house = DataFrame(XLSX.readtable("house_data.xlsx", "Sheet1")...)

# ╔═╡ 5e58e35f-9ac6-4e0f-b619-86cd6b511629
ones(1000)' * df_house.price

# ╔═╡ 25c06b3a-25ae-4247-9d36-775728f351c6
sum(df_house.price)

# ╔═╡ 7926881c-f1b3-4b5e-8aa9-97443d16b903
md"""#

We have now stored the housing data set into `df_house` as a DataFrame file.


**To manipulate the data**
* need to **know the tools you are using**, the `DataFrames` package in this case,
* need to **understand matrix and vector operations**

Let us review a few of `DataFrames` instructions to work on the data.

For slicing:
* `first(df_house,n)` → $n$ is the number of lines starting from the 1st
* `last(df_house,n)` → $n$ is the number of lines before and including the last line
* `df_house[row_1:row_n,col_1:col_m]` → Selects the rows between `row_1` and `row_2`, and the columns from `col_1` to `col_2`
* `names(df_house)` → gives the titles of the columns if they are included in the. table
* `df_house.name` → gives you an access to the columns with their names
* `size(df_house)` → gives you the size of the table as (number of rows,number of columns).
"""

# ╔═╡ 1c939645-80f1-4fe8-a497-62b7f22b833c
df_house_first = first(df_house,2)

# ╔═╡ a8d3d0e1-59af-48ed-8bf9-984422cb2ee1
md"""#"""

# ╔═╡ cfb7c432-059b-4f25-8f03-33749c77f76a
df_house_slice = df_house[1:2,1:5]

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

# ╔═╡ d0657740-b31d-4efe-be23-dbfd356ac744
md" 

!!! conclusion
	Each row of the table corresponds to a specific house and every one of them has 19 entries, as the vectors in 19 Dimensional space. 

#### End of Digression
"

# ╔═╡ 2cb76c55-488d-4b81-9ae3-dbec88f12deb
md"
## 1.2.3. Simple vector operations

### Creating and adding two random vectors

Let us first create a random 5-vector (this is a notation to tell you that each vector consists of 5 elements and it is in 5 Dimensional space)

"

# ╔═╡ ec05fea5-62be-4e72-bf06-ce4d03720e0a
v5=randn(Float16,5) #vector in R^5 with each coordinate chosen randomly with mean 0 and standard deviation 1, using ``randn``

# ╔═╡ 5f6f9f8b-9b4a-4d80-b964-5e2c010e65fd
v6=rand(Float16,5) #vector in R^5 with each coordinate chosen randomly between 0 and 1, using ``rand``

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

# ╔═╡ 75b87a28-3744-4f07-94d4-4d8827329f8c
md"
!!! note \"Vector Addition\"
	**_Two vectors of the same size can be added_** by adding the corresponding elements, to form another vector of the same size, called the sum of the vectors.
"

# ╔═╡ 9162c574-1b3d-4660-8369-2cc16f545f44
md"#

### Visualizing vector addition (in 2D)

 $\color{blue} {\bf u_1}=(x_1, y_1)$ $\color{blue} is \; the \;blue \;vector$, \
 $\color{red} {\bf u_2}=(x_2, y_2)$ $\color{red} is \; the \;red \;vector$, \
 $\color{green} {\bf u_1 + u_2} =(x_1+x_2, y_1+y_2)$ $\color{green} is \;the \;green \;vector$, .
"

# ╔═╡ 20be3bc6-16ec-4709-a8d8-7b22d8b95379
x1=rand(-3:1:3); y1=rand(-3:1:3); x2=rand(-3:1:3); y2=rand(-3:1:3);

# ╔═╡ 2647fcc9-9d4f-43a6-9712-210bcbf9be3f
md""" 
 	``{\bf u_1}`` =( $x1 , $y1 )  ``\qquad {\bf u_2}`` =( $x2 , $y2 ) 
  ``\;\; \Rightarrow \;\; {\bf u_1} + {\bf u_2}`` = ( $(x1 + x2) , $(y1 + y2)  )

"""

# ╔═╡ 3cd4208b-4b1c-4d7c-afdb-e6d2addda3cb
begin

	x_vals = [0 0 x1 x2 0 ; x1 x2 (x1+x2) (x1+x2) (x1+x2)]
	y_vals = [0 0 y1 y2 0 ; y1 y2 (y1+y2) (y1+y2) (y1+y2)]

	plot(x_vals, y_vals, arrow = true, line = [:solid :solid :dash :dash], color = [:blue :red :red :blue :green], lw = [2 2 1 1 2],
     legend = :none, xlims = (-5, 5), ylims = (-5, 5),
     annotations = [(x1+0.5, y1-0.3, "($x1, $y1)"),
                    (x2, y2+0.4, "($x2, $y2)"),
                    ((x1+x2+0.5), (y1+y2), "($(x1+x2), $(y1+y2))")],
     xticks = -5:1:5, yticks = -5:1:5,
	 xlabel = L"x", ylabel = L"y",
     framestyle = :zerolines) #try framestyle = :origin
end

# ╔═╡ cded91d4-baf0-46c2-a341-872202a8472c
md" 
**Vector substraction** is nothing but scalar multiplication of a vector and adding to another. For example, let us say we would like to subtract ${\bf u_3}=(x_3,y_3)$ from ${\bf u_4}=(x_4,y_4)$, then

${\bf u_3} + (-1) {\bf u_4}=(x_3,y_3) + (-1) (x_4,y_4) = (x_3-x_4,y_3-y_4)$

---
"

# ╔═╡ b15ae47f-1905-47af-9831-7c4c9dfcd147
md"#
### Examples

* **Displacements:** When vectors $\bf a$ and $\bf b$ represent displacements, the sum $\bf a + b$ is the net displacement found by first displacing by $\bf a$, then displacing by $\bf b$.


* **Displacements between two points:** If the vectors $\bf p$ and $\bf q$ represent the positions of two points in 2-D or 3-D space, then $\bf p − q$ is the displacement vector from $\bf q$ to $\bf p$. 

"

# ╔═╡ 445f969a-2d87-42c3-893a-8c5db4f37c48
begin
	p1=rand(-3:3); 
	p2=rand(-3:3); 
	q1=rand(-3:3);
	q2=rand(-3:3); 
	
	p_vals = [0 0 ; p1 q1 ]
	q_vals = [0 0 ; p2 q2 ]
	plot(p_vals, q_vals, arrow = true, xticks = -5:1:5, yticks = -5:1:5, color = [:blue :red], lw = [2 2],
		legend = :none, xlims = (-5, 5), ylims = (-5, 5), framestyle = :zerolines,
		annotations = [(p1/2+0.1, p2/2+0.1, L"p"),
                       (q1/2+0.1, q2/2+0.1, L"q")])

	p2_vals = [q1 0; p1 p1-q1]
	q2_vals = [q2 0; p2 p2-q2]
	plot!(p2_vals, q2_vals, arrow = true, color = :green, lw = 2,
     annotations = [(((p1+q1)/2)+0.5, (p2+q2)/2+0.5, L"p-q"), (((p1-q1)/2)+0.5, (p2-q2)/2+0.5, L"p-q")],
	 xlabel = L"x", ylabel = L"y",
     framestyle = :zerolines) #try framestyle = :origin
end

# ╔═╡ a5efcaed-1e2e-4c6d-b96a-a362bb93c792
md"
* **Feature differences:** If $\bf f$ and $\bf g$ are n-vectors that give n feature values for two items, the difference vector $\bf d = f − g$ gives the difference in feature values for the two objects. For example, $d_7 = 0$ means that the two objects have the same value for feature 7;


* **Time series:** If $\bf a$ and $\bf b$ represent time series of the same quantity, such as daily profit at two different stores, then $\bf a + b$ represents a time series which is the total daily profit at the two stores. 
---
"

# ╔═╡ f7f08d7b-d8a2-4b13-82d5-9b56202a04fc
md"#

### Scalar-vector multiplication

For a given vector $\bf v$ = [$v_1, v_2, v_3, v_4, v_5$] and a scalar $c$, 

 $c \bf v$ = [$c v_1, c v_2, c v_3, c v_4, c v_5$].

That is, the scalar multiplies all the entries of the vector.
!!! note
	Scalar multiplication distributes over vector addition: 
	$c({\bf v_1 + v_2}) = (c{\bf v_1} + c{\bf v_2})$ 
"

# ╔═╡ a0e8a024-68b1-488d-83c5-7da9f2f6ddec
v11 = [1, 2, 3]

# ╔═╡ 66334033-d75c-4322-b9b9-d9b0f6d8bcd4
v22 = [4, 5, 6]

# ╔═╡ 122d9ff2-8a55-44fa-9726-df29ad94f27f
v11+v22

# ╔═╡ beb9f6c0-9480-4e3f-9a4a-82be4203918f
2*(v11+v22) == 2*v11+2*v22

# ╔═╡ 7bf33c3b-9fb8-4e4a-950d-6c0377fbde8f
md"#

### Vector multiplication - dot product

Let $\bf v$ = [$v_1, v_2, v_3$] and $\bf w$ = [$w_1, w_2, w_3$] be two 3-vectors, then we can define two different multiplications  

* **Dot product**:
```math 
{\bf v} ⋅ {\bf w} = \|{\bf v}\| \;\|{\bf w}\| \;cos\theta = \sum_{\rm i=1:3}{v_i w_i} \;→ \;\; scalar.
```

where $\|\;\|$ is used for the length (≡ `norm`) of the vector, $\theta$ is the angle between the two vectors. 

The dot product (also called **inner product**) of two n-vectors $\bf a$ and $\bf b$ is also defined as the product of the transpose of one with the other as

```math 
{\bf a}^T {\bf b} = \begin{bmatrix} a_1 & a_2 & \dots & a_n \end{bmatrix} \begin{bmatrix} b_1 \\ b_2 \\ \vdots \\ b_n \end{bmatrix} = a_1 b_1 + a_2 b_2 + \dots + a_n b_n = \sum_{\rm i=1:n}{a_i b_i}
```
⇒ Notice that the summation expression is the sum of the elementwise product of both vectors.

!!! note
	Dot Products are generally used in the definition of **_lengths_** of vectors and **_projections_** of vectors onto other vectors or planes.
  
"

# ╔═╡ 88de33cf-7cc3-4b17-9d8b-23a7971dbb65
md"#

#### Examples[^1]:

* **Unit vector:** ${\bf e^T_i a} = a_i$. The inner product of $\bf a$ vector with the **$i^{th}$ standard unit vector** gives (or ‘picks out’) the $i^{th}$ element $\bf a$.
```math
{\bf e_1} = \begin{bmatrix} 1 \\ \vdots \\ 0 \\ 0 \\ 0 \\ \vdots \\ 0 \end{bmatrix}
\begin{matrix}  1^{st} entry \\ \vdots \\ (i-1)^{st} entry \\ i^{th} entry \\ (i-1)^{st} entry \\ \vdots \\ n^{th} entry  \end{matrix}; \;\; \cdots \;\; 
{\bf e_i} = \begin{bmatrix} 0 \\ \vdots \\ 0 \\ 1 \\ 0 \\ \vdots \\ 0 \end{bmatrix}
\begin{matrix}  1^{st} entry \\ \vdots \\ (i-1)^{st} entry \\ i^{th} entry \\ (i-1)^{st} entry \\ \vdots \\ n^{th} entry  \end{matrix}; \;\; \cdots \;\;
{\bf e_n} = \begin{bmatrix} 0 \\ \vdots \\ 0 \\ 0 \\ 0 \\ \vdots \\ 1 \end{bmatrix}
\begin{matrix}  1^{st} entry \\ \vdots \\ (i-1)^{st} entry \\ i^{th} entry \\ (i-1)^{st} entry \\ \vdots \\ n^{th} entry  \end{matrix}
```


* **Sum:** ${\bf 1}^T {\bf a} = a_1 + \dots + a_n$. The inner product of a vector with the vector of ones gives the sum of the elements of the vector.


* **Average:** $({\bf 1}/n)^T {\bf a}=(a_1+···+a_n)/n$. The innerproduct of an n-vector with the vector $1/n$ gives the average or mean of the elements of the vector. The average of the entries of a vector is denoted by `avg(x)`. The Greek letter μ is a traditional symbol used to denote the average or mean.


* **Sum of squares:** ${\bf a}^T {\bf a} = a^2_1 +···+a^2_n$. The inner product of a vector with itself gives the sum of the squares of the elements of the vector.


* **Selective sum:** Let $\bf b$ be a vector all of whose entries are either 0 or 1. Then ${\bf b}^T \bf a$ is the sum of the elements in $\bf a$ for which $b_i =1$.

[^1] Stephen Boyd, Lieven Vandenberghe, _Introduction to Applied Linear Algebra: Vectors, Matrices, and Least Squares_, Cambridge University Press, 2018.
"


# ╔═╡ b6167c3f-331a-4fc0-bf83-e34a0c63e0a5
a_ex = [1:9;]

# ╔═╡ 67f0c700-44f2-4b31-ab82-c8bad5cb4dd2
a_sum = ones(length(a_ex))' * a_ex # Sum of a

# ╔═╡ 9b4e5e5b-0ec6-4168-8b1c-bea93a17e6b6
a_avg = sum(a_ex)/length(a_ex) # Average of a

# ╔═╡ 1a13325e-88e2-4a8d-9b51-e6787a33d70e
a_ssq = a_ex' * a_ex # sum of the squares of a

# ╔═╡ d251cefe-1d55-4f60-b9b2-e7bfef596cae
a_ss = [1; 1; zeros(5); 1; 1]' * a_ex # Sum of a_1, a_2, a_8, a_9

# ╔═╡ 08b8c340-543c-439e-9bec-c896ded4913e
a1_ss = [1 1 hcat(zeros(5)...) 1 1] * a_ex 

# ╔═╡ 5b9c7938-1b43-40ef-accc-fd72f79a8e83
md"#

### Vector multiplication - cross product  

* **Cross product** (_may skip it for now_):
```math 
{\bf v} × {\bf w} = {\bf z} =
\begin{vmatrix} 
i & j & k \\
v_1 & v_2 & v_3 \\
w_1 & w_2 & w_3 \\
\end{vmatrix}
\;→ \;\; {\bf z} \; ⟂ \;to \;{\bf v} \;and \;{\bf w}.
```  
```math
\|{\bf z}\|= \|{\bf v}\|\;\|{\bf w}\|\;sin\theta
```
where $|\;\;\;|$ denotes `determinant` of the matrix inside the bars, and $\theta$, as before, is the angle between the two vectors. 

!!! note
	Cross Products are used in Physics extensively, but not much in Data 	Sciences. 

A few applications may include the following: it may be used
	
* to find a perpendicular (= orthogonal) vector to the vectors $\bf v$ and $\bf w$, as the resulting vector $\bf z$ is always perpendicular to both of the vectors involved in the product;
* to find an error when a point is projected on a line (example will be given below.)
"

# ╔═╡ 0e03a31f-b062-4fa0-aacb-4d9b4ece185d
md" 
## 1.2.4. A few definitions 
### Length of a vector
###### What is the length (magnitude) of a vector?

Let us denote the vector by $\bf v$ = ($v_1, v_2, v_3$), then the magnitude of the vector can be written as
```math
length = \sqrt{v_1^2 + v_2^2 + v_3^2} 
```
There are several ways to calculate the length of a vector of any size:
1. `sqrt`($\bf v$' $\bf v$), where ' refers to the transpose of the vector;
2. implement the definition given above;
3. `norm`($\bf v$, $\bf v$) (mathematicall $\|\bf v\|$), where `norm` is the term used for the length of a vector;
4. `sqrt``dot`($\bf v$, $\bf v$), where `sqrt` and `dot` are the instructions to perform the square-root and the dot product operations in _Julia_ programin language.

!!! note 
	Don't use `length` to find the length of a vector. `length` instruction gives the dimension (size) of the vector, which is 3 for the vector $\bf v$.
"

# ╔═╡ a342cf0f-7867-4cc3-8d19-32304a05c1af
vv = rand(-5:5,3)

# ╔═╡ 7776654d-8053-492e-8ec8-1b37106b9c77
length1_vv = sqrt(vv' * vv) # 1. vv' is the transpose of vv

# ╔═╡ c7ef7ad1-587f-4973-944e-16c6c5a63bb5
length2_vv = sqrt(vv[1]^2+vv[2]^2+vv[3]^2) # 2. from definition

# ╔═╡ 2f981b1b-5860-4c8b-a2d8-003aee287bd6
length21_vv = sqrt(sum(vv.^2)) # 2. from definition using `sum` and pointwise operation

# ╔═╡ 29774e08-c36f-4907-b060-2fa41699ce2b
length3_vv = norm(vv) # 3. norm is the length of a vector in LA

# ╔═╡ ab38d1b0-3b47-430e-960d-525ed1894f0d
length4_vv = sqrt(dot(vv,vv)) # 4. 'dot` is the Julia's instruction  

# ╔═╡ bfc0b5a2-66bc-4891-84fe-93794940a393
length(vv) # gives the dimension of the vector

# ╔═╡ 48d3d9a6-bf9e-450c-a1e8-66dbf95cfbd1
size(vv) # gives the dimension as the number of rows and columns

# ╔═╡ de011089-7cb7-40ce-bb51-a0dc81b74f5e
md"""# 
### Norm and Distance

##### Norm of a vector is simply a measure of its magnitude


* There are many different definitions of `Norm` for vectors and matrices and it is denoted by $\| \cdot \|$.


* The most common definition is known as `Euclidean Norm`, with general designation of $\| \cdot \|_2$. Since it is usually a default norm in most applicatons, the subscript '2' is usually omitted.
  - For 2-vector ${\bf x} = \begin{bmatrix} x_1 \\ x_2 \end{bmatrix}$: $\qquad \|x\|= \sqrt{x_1^2 + x_2^2}$
   - For $n$-vector $\bf x$: $\qquad \qquad \|x\| = \sqrt{x_1^2 + x_2^2+\cdots+x_n^2}$


* The Euclidean norm can also be expressed as the squareroot of the inner product of the vector with itself:  $\|x\| = \sqrt{x^T x}$.


* Two other common vector norms for n-vectors are the 1-norm $\| \cdot \|_1$ and the $\infty$-norm $\| \cdot \|_{\infty}$, defined as
$\|x\|_1 = |x_1| + \dots + |x_n|, \qquad \|x\|_\infty = max\{|x_1|, \dots , |x_n|\}$


*  1-norm and the $\infty$-norm are the sum and the maximum of the absolute values of the entries in the vector, respectively. 

"""

# ╔═╡ 6e1ec991-a125-484e-b1c5-a23ac7ee36d7
a_lecture = rand((-3:3), 5)

# ╔═╡ 30676169-e350-4a54-8daf-577c9dbfe28f
norm(a_lecture,2), norm(a_lecture,1), norm(a_lecture,Inf)

# ╔═╡ 8fa6a139-6cac-4428-b2d2-c2e7058b9906
md"""#

**`Euclidean distance`** is the distance between two vectors $\bf a$ and $\bf b$, defined as the norm of their difference:

$\text{dist}(\bf a, b)= \| a - b \|$

* **Feature distance:** If $\bf x$ and $\bf y$ represent vectors of n features of two objects, the quantity $\bf \| a - b \|$ is called the feature distance, and gives a measure of how different the objects are (in terms of their feature values).


* **Nearest neighbor:** Suppose $\bf z_1, \dots , z_m$ is a collection of m n-vectors, and that $\bf x$ is another n-vector. $\bf z_j$ is the nearest neighbor of $\bf x$ (among $\bf z_1, \dots , z_m$) if
$\|x - z_j\| \le \|x - z_i\|\qquad for \; i=1,\dots,m$


* **Document dissimilarity:** Suppose n-vectors $\bf x$ and $\bf y$ represent the histograms of word occurrences for two documents. Then $\|x - y\|$ represents a measure of the dissimilarity of the two documents.
"""

# ╔═╡ 35a01f9e-06e3-45a4-ab08-f16102b7819b
md"""# 1.3. Relevant applications

### Sum and Average of an array

Dot product can also be used to sum up the entries of an array
 
"""

# ╔═╡ b5cc6660-e52d-45fc-90de-c8a4b3c2d9ee
vv_1 = rand(0:5,5)

# ╔═╡ 0f05f2ee-fe1a-4d85-abec-6a3531182fb9
ww_1 = ones(5)

# ╔═╡ 79f4d5b8-7ac9-44fd-95ff-7dbdbc20942b
dot(vv_1, ww_1)

# ╔═╡ cd686799-ef18-43a1-946f-f79a3eb1327c
md"So, let us remember the table we have worked in the context of `DataFrames`, and find the average price of an house sold in that neighborhood and in that time frame: We need to 
1. **find the names of the columns** in the table: `names(df_house)`
2. **find the number of rows** of the table: `size(df_house)[1]`
3. **form an array** that is composed of `1`s only, with the size of the number of rows: `ones(size(df_house)[1])`
4. **sum up the entries of the column** for _price_: `dot(ones(size(df_house)[1]), df_house.price)`
5. **divide it by the number of entries** in the array: /`size(df_house)[1]` 
"

# ╔═╡ e1daa7b0-1f65-4263-a5b5-f9f7f79375d2
names(df_house) # 1.

# ╔═╡ e89ae5fd-f4ec-488c-95d6-6593676ee163
size(df_house)[1] # 2.

# ╔═╡ 20b49e47-5a79-4d72-aaf9-b79b423bde02
ones(size(df_house)[1]) # 3.

# ╔═╡ ddac83ca-c67b-4a07-9990-e8d165630998
dot(ones(size(df_house)[1]), df_house.price) # 4.

# ╔═╡ 9152e5a8-3818-4cd6-ad6a-b741f843a24d
sum(df_house.price)

# ╔═╡ af21ae80-d242-46aa-ab9f-0ed21f7b1284
dot(ones(size(df_house)[1]), df_house.price)/size(df_house)[1] # 5.

# ╔═╡ da88ee62-2b88-4636-8a1b-0a5ec9d7d0c3
md"""# 
### Root-Mean-Square Value (rms)

${\bf{\text rms}(x)} = \sqrt{\frac{x_1^2 + \dots + x_n^2}{n}} = \frac{\|{\bf x}\|}{\sqrt{n}}$

* The RMS value of a vector $\bf x$ is useful when comparing norms of vectors with different dimensions.


* **RMS prediction error:** Suppose that the n-vector $\bf y$ represents a time series of some quantity, for example, hourly temperature at some location, and $\hat{\bf y}$ is another n-vector that represents an estimate or prediction of the same time series, based on other information. The difference $\bf y - \hat{\bf y}$ is called the prediction error, and its RMS value ${\bf{\text rms}(\bf y - \hat{\bf y})}$ is called the RMS prediction error. If this value is small (say, compared to ${\bf{\text rms}(y)}$) the prediction is good.
"""

# ╔═╡ a445b2f7-1468-4916-b062-80585b441abb
norm(ones(16)) # norm of n-vector 1 = 1/sqrt(n) 

# ╔═╡ e361943a-7ac7-43cb-8dd3-269130c01419
norm(ones(16))/sqrt(16) # RMS value is 1; a typical value of the vector

# ╔═╡ 8a8d9a85-aabb-4fbf-916c-7f7723f462d7
md"""#
### Demeaning a vector

* For any vector $\bf x$, the vector $\tilde{\bf x} = {\bf x} − avg(\bf x)1$ is called the associated **de-meaned vector**, obtained by subtracting from each entry of $\bf x$ the mean value of the entries.

  The de-meaned vector is useful for understanding how the entries of a vector deviate from their mean value.

"""

# ╔═╡ 92a37af5-b98d-477c-b824-7a642d56a386
p_mean = let
	μ_liv = ones(size(df_house)[1]) * sum(df_house.sqft_living)/size(df_house)[1]
	μ_pr = ones(size(df_house)[1]) .* sum(df_house.price)/size(df_house)[1]
	scatter(df_house.sqft_living, df_house.price)
	plot!(df_house.sqft_living, μ_pr, color = :red)
	plot!(μ_liv, df_house.price, color = :red)
end

# ╔═╡ 53ab6b9d-9835-4ab0-8711-c43fe76c9ac0
dmean_living = df_house.sqft_living .- sum(df_house.sqft_living)/size(df_house)[1]

# ╔═╡ 6b4f6269-b400-430f-921e-9d62a5bfd557
dmean_price = df_house.price .- sum(df_house.price)/size(df_house)[1]

# ╔═╡ 8052ad94-2fcd-4184-aa82-9715d5f16d7b
scatter(dmean_living, dmean_price)

# ╔═╡ 8cad4f8e-fcf7-4a4e-ad01-6762174204e3
md"""#

### Standart deviation

##### The standard deviation is a measure of how spread out numbers are.
\

The **standard deviation** of an n-vector $\bf x$ is defined as the RMS value of the de-meaned vector ${\bf x} − avg(\bf x)1$, as given below.

  The standard deviation of a vector $\bf x$ tells us the typical amount by which its entries deviate from their average value.
  
$std({\bf x}) = \sqrt{\frac{(x_1 -avg({\bf x}))^2 + \dots + (x_n -avg({\bf x}))^2}{n}}$

$std({\bf x}) = \frac{\|{\bf x} - ({\bf 1}^T {\bf x}/n) {\bf 1}\|}{\sqrt{n}}$


* Another slightly different definition of the standard deviation of a vector is widely used, in which the denominator $\sqrt{n}$ is replaced with $\sqrt{n − 1}$ (for n ≥ 2).


* In some applications the Greek letter σ (sigma) is traditionally used to denote standard deviation, while the mean is denoted μ (mu).
$\mu = {\bf 1}^T {\bf x}/n, \qquad \sigma = \|{\bf x}- \mu {\bf 1} \| / \sqrt{n}$

* **Adding a constant to every entry of a vector does not change its standard deviation**:
$std({\bf x}+a {\bf 1}) = std(\bf x)$

* **Multiplying a vector by a scalar multiplies the standard deviation by the absolute value of the scalar**:
$std(a{\bf x}) = |a| std({\bf x})$.
"""

# ╔═╡ 8fc7ad49-27dc-4aad-9237-976e1e9cf37e
md"""# 
### Standardization

##### What is it?

Instead of using the original vectors (features) directly, it is common to apply a scaling and offset to each original vector. **This is called standardizing or z-scoring the features.**

**Goal:** Across the data set, **the average value of a feature is near zero**, and the **standard deviation is around one**. 

##### How to compute?

* Remember the de-meaned version of a vector $\bf x$: Subtract the mean value from each entry of the vector:
$\tilde{\bf x} = {\bf x} - avg({\bf x}){\bf 1}$
 
* Standardized version of $\bf x$ is nothing but dividing its de-meaned version by the standart deviation of $\bf x$:
${\bf z}= \frac{\tilde {\bf x}}{std({\bf x})} = \frac{{\bf x} - avg({\bf x}){\bf 1}}{std({\bf x})}$

* Its entries are sometimes called the $z$-scores associated with the original entries of $\bf x$.
#
"""

# ╔═╡ f1638480-d63e-418e-af69-1201e8e7137e
avg(x) = ones(length(x))' * x / length(x)

# ╔═╡ f91f7995-cf8d-4719-80fa-6fe11a0c9dbd
std(x) = norm(x - avg(x) * ones(length(x))) / sqrt(length(x))

# ╔═╡ c6988b6d-876d-4ec4-8d89-3793e0b68b32
begin
	n_st = 10
	σ_st = 2.0
	x_st = 1.0 .+ σ_st * rand(-1:0.1:1, n_st)
	μ_st = avg(x_st) # average
	x_dm = x_st - μ_st * ones(n_st) # de-mean
	z_st = x_dm / std(x_st) # standardize
end

# ╔═╡ f6b8a949-98de-4cb1-ab08-fb1c6acde394
begin
# Original vector x
	scatter([1:n_st], x_st, xlabel = L"k", ylabel = L"x", markersize = 5)
	plot!([1:n_st], [μ_st*ones(n_st), (μ_st + std(x_st))*ones(n_st), (μ_st - std(x_st))*ones(n_st)], line = :dash, color = :red)
	p1_original = plot!([1:n_st], x_st, ylimit = (-4,4), legend=false, color=:green, yticks = [-4:1:4;])
# de-meaned vector x
	scatter([1:n_st], x_dm, xlabel = L"k", ylabel = L"\tilde{x}", markersize = 5)
	plot!([1:n_st], [zeros(n_st), std(x_dm) *ones(n_st), -std(x_dm) *ones(n_st)], line = :dash, color = :red)
	p1_demeaned = plot!([1:n_st], x_dm, ylimit = (-4,4), legend = false, color = :green, yticks = [-4:1:4;])
# standardized vector z
	scatter([1:n_st], z_st, xlabel = L"k", ylabel = L"z", markersize = 5)
	plot!([1:n_st], [zeros(n_st), std(z_st) *ones(n_st), -std(z_st) *ones(n_st)], line = :dash, color = :red)
	p1_standardized = plot!([1:n_st], z_st, ylimit = (-4,4), legend = false, color = :green, yticks = [-4:1:4;])
	plot(p1_original,p1_demeaned,p1_standardized, layout = (1,3) )
end

# ╔═╡ 624ea283-b640-4241-befc-73ca3c529111
md"""# 
### Correlation Coefficient

##### What is it?

* `The correlation coefficient` is a statistical measure of the strength of the relationship between the relative movements of two variables.


* `The correlation coefficient` describes how one variable moves in relation to another. 


* `The values range between -1.0 and 1.0`. A calculated number greater than 1.0 or less than -1.0 means that there was an error in the correlation measurement.


* `A correlation of -1.0 shows a perfect negative correlation`, while a `correlation of 1.0 shows a perfect positive correlation`. `A correlation of 0.0 shows no linear relationship between the movement of the two variables`.


##### How to compute?

Suppose $\bf a$ and $\bf b$ are n-vectors, with associated de-meaned vectors

$\tilde{\bf a} = {\bf a} - avg({\bf a}) {\bf 1} \qquad \tilde{\bf b} = {\bf b} - avg(\bf b) 1$

their correlation coefficient is defiined as

$\rho = \frac{\tilde{\bf a}^T \tilde{\bf b}}{\|\tilde{\bf a}\| \|\tilde{\bf b}\|}$ OR

$Cor({\bf a, b})=\frac{\sum_{i=1}^{n}(a_i - \bar{\bf a}) (b_i - \bar{\bf b})}{\sqrt{\sum_{i=1}^{n}(a_i - \bar{\bf a})^2} \sqrt{\sum_{i=1}^{n}(b_i - \bar{\bf b})^2}}$

where $\bar{\bf a}$ ($=avg(\bf a) = \mu_a$) and $\bar{\bf b}$ ($=avg(\bf b) = \mu_b$) are the mean values of ${\bf a}$ and ${\bf b}$, respectively.

"""

# ╔═╡ 486368b5-a701-4eae-bace-b11885178e04
md"#
##### Example
"

# ╔═╡ 74db1ecb-0ca8-4f56-8b28-84b2c21fc008
function correl_coef(a,b)
	a_tilde = a .- avg(a)
	b_tilde = b .- avg(b)
	return (a_tilde'*b_tilde)/(norm(a_tilde)*norm(b_tilde))
end

# ╔═╡ fec7f28f-aab3-491f-afaa-185eb4a3b278
begin
# 1
	a1_cor = [4.4, 9.4, 15.4, 12.4, 10.4, 1.4, -4.6, -5.6, -0.6, 7.4];
	b1_cor = [6.2, 11.2, 14.2, 14.2, 8.2, 2.2, -3.8, -4.8, -1.8, 4.2];
	ρ1=correl_coef(a1_cor,b1_cor)
	scatter([1:10],a1_cor,xlabel=L"k",ylabel=L"a_k",markersize=3, color=:red)
	p1_a1 = plot!([1:10],a1_cor, color =:blue,legend=false,framestyle=:zerolines)
	scatter([1:10],b1_cor,xlabel=L"k",ylabel=L"b_k",markersize=3,color=:red)
	p1_b1 = plot!([1:10],b1_cor, color = :blue, legend = false,framestyle=:zerolines)
	p1_ab=scatter(a1_cor,b1_cor,xlabel=L"a_k",ylabel=L"b_k",legend = false, titlefont = 10, title = L"\rho=0.97", markersize=3,color=:red,framestyle=:zerolines)
# 2
	a2_cor = [4.1, 10.1, 15.1, 13.1, 7.1, 2.1, -2.9, -5.9, 0.1, 7.1];
	b2_cor = [5.5, -0.5, -4.5, -3.5, 1.5, 7.5, 13.5, 14.5, 11.5, 4.5];
	ρ2=correl_coef(a2_cor,b2_cor)
	scatter([1:10],a2_cor,xlabel=L"k",ylabel=L"a_k",markersize=3, color=:red)
	p2_a2 = plot!([1:10],a2_cor,color=:blue,legend=false,framestyle=:zerolines)
	scatter([1:10],b2_cor,xlabel=L"k",ylabel=L"b_k",markersize=3,color=:red)
	p2_b2 = plot!([1:10],b2_cor,color =:blue,legend=false,framestyle=:zerolines)
	p2_ab=scatter(a2_cor,b2_cor,xlabel=L"a_k",ylabel=L"b_k",legend=false, titlefont = 10, title=L"\rho=-0.99", markersize=3,color=:red,framestyle=:zerolines)
# 3
	a3_cor = [-5.0, 0.0, 5.0, 8.0, 13.0, 11.0, 1.0, 6.0, 4.0, 7.0];
	b3_cor = [5.8, 0.8, 7.8, 9.8, 0.8, 11.8, 10.8, 5.8, -0.2, -3.2];
	ρ3=correl_coef(a3_cor,b3_cor)
	scatter([1:10],a3_cor,xlabel=L"k",ylabel=L"a_k",markersize=3, color=:red)
	p3_a3 = plot!([1:10],a3_cor,color =:blue,legend=false,framestyle=:zerolines)
	scatter([1:10],b3_cor,xlabel=L"k",ylabel=L"b_k",markersize=3,color=:red)
	p3_b3 = plot!([1:10],b3_cor,color=:blue,legend=false,framestyle=:zerolines, yticks = (-5:5:15))
	p3_ab=scatter(a3_cor,b3_cor,xlabel=L"a_k",ylabel=L"b_k",legend=false, markersize=3,color=:red,framestyle=:zerolines, yticks = (-5:5:15),titlefont = 10, title=L"\rho=0.004")
	plot(p1_a1,p1_b1,p1_ab,p2_a2,p2_b2,p2_ab,p3_a3,p3_b3,p3_ab,layout =(3,3))
end

# ╔═╡ 585b27eb-1c5a-4f57-a14b-c2b8ac99d3b5
ρ1,ρ2,ρ3

# ╔═╡ c3d684f7-8978-4cc6-b65d-59e6da94cef3
md"""# 
### Projection
##### How about taking the dot product of two different vectors?

This is mostly used to find the projection of a vector onto another vector:

Let us denote the two vectors by $\bf v$ = ($v_1, v_2, v_3$) and $\bf w$ = ($w_1, w_2, w_3$), then the dot product will result in
```math
{\bf v} \cdot {\bf w} = v_1 w_1 + v_2 w_2 + v_3 w_3 \equiv \|{\bf v}\| \|{\bf w}\| \;cos\theta 
```

Assuming that the magnitude of $\bf w$ is unity ($\|{\bf w}\|=1$), then from the definition, the magnitude of the projected vector $\bf v$ along the vector $\bf w$ is
```math 
{\bf v} ⋅ {\bf w} = \|{\bf v}\| \;cos\theta
```
Hence, the projection of $\bf v$ onto $\bf w$ is represented as

```math
	Proj_{\bf w} \bf v = (\bf v \cdot \bf w) \bf w
```
"""

# ╔═╡ f05fda42-ae5d-404a-8e71-25f6f338362a
begin
	vv1 = rand(-3:0.5:3,2) # Vector v
	ww1 = rand(-3:0.5:3,2) # Vector w
	mag_ww1=norm(ww1) # magnitude of w
	ww1_n = ww1/mag_ww1 # unit vector w
	proj_wv = dot(vv1,ww1_n)*ww1_n # Projection of v on unit vector w
end

# ╔═╡ 4d2db045-e798-421b-8b76-74271176031a
begin

	x3_vals = [0 0 ; vv1[1] ww1[1] ]
	y3_vals = [0 0 ; vv1[2] ww1[2] ]

	# After importing LaTeXStrings package, L stands for Latex in the following expressions; L"v_1"
	plot(x3_vals, y3_vals, arrow = true, aspect_ratio = :equal, color = [:blue :red],
     legend = :none, xlims = (-3, 3), ylims = (-3, 3),
	 annotations = [(vv1[1], vv1[2]+0.2, Plots.text(L"v", color="blue")),
		 			(ww1[1], ww1[2]+0.2, Plots.text(L"w", color="red"))],
     xticks = -3:1:3, yticks = -3:1:3,
     framestyle = :origin)
	plot!([-3*ww1[1], 3*ww1[1]],[-3*ww1[2], 3*ww1[2]], color=:red,linestyle=:dash)
	plot!([vv1[1] 0; proj_wv[1] proj_wv[1]], [vv1[2] 0; proj_wv[2] proj_wv[2]], arrow = true, color=:blue, linestyle=[:dash :dash],
	annotations = [(proj_wv[1]-0.2, proj_wv[2]-0.2, Plots.text(L"^{proj_w \mathbf{v}}", color="blue")), ((vv1[1]+proj_wv[1])/2-0.5, (vv1[2]+proj_wv[2])/2, Plots.text(L"^{||\mathbf{v \times w}||}", color="blue"))])
end

# ╔═╡ b750f433-babe-40ec-9587-7650c56870d3
md"
## Resources

* julialang.org (web page) [Download Julia](https://julialang.org)
* How to install Julia and Pluto (Youtube) [Intro to Pluto ](https://www.youtube.com/watch?v=OOjKEgbt8AI)
* Pluto - One year later (Youtube) [Pluto](https://www.youtube.com/watch?v=HiI4jgDyDhY)
* Stephen Boyd, Lieven Vandenberghe, [Introduction to Applied Linear Algebra: Vectors, Matrices, and Least Squares] (https://web.stanford.edu/~boyd/vmls/vmls.pdf), Cambridge University Press, 2018.
"

# ╔═╡ 15bbc002-e797-404d-961b-494e20fef2df
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
ImageTransformations = "02fcd773-0e25-5acc-982a-7f6622650795"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
XLSX = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
DataFrames = "~1.3.1"
FileIO = "~1.12.0"
HypertextLiteral = "~0.9.3"
ImageIO = "~0.6.0"
ImageShow = "~0.3.3"
ImageTransformations = "~0.9.4"
LaTeXStrings = "~1.3.0"
Plots = "~1.25.6"
PlutoUI = "~0.7.38"
XLSX = "~0.7.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0-beta3"
manifest_format = "2.0"
project_hash = "74048ed5d7b80bd2b390cfe6b5068c5b77f7d102"

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

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

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

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9489214b993cd42d17f44c36e359bf6a7c919abf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "0f4e115f6f34bbe43c19751c90a38b2f380637b9"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.3"

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

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

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
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c98aea696662d09e215ef7cda5296024a9646c75"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.4"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "3a233eeeb2ca45842fe100e0413936834215abf5"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.4+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

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
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

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
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

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
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "d9a03ffc2f6650bd4c831b285637929d99a4efb5"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.5"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "42fe8de1fe1f80dab37a39d391b6301f7aeaa7b8"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.4"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b7bc05649af456efc75d178846f47006c2c4c3c7"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.6"

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
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

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
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

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
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

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
git-tree-sha1 = "b4975062de00106132d0b01b5962c09f7db7d880"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.5"

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
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

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

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

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
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d16070abde61120e01b4f30f6f398496582301d6"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.12"

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
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

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
git-tree-sha1 = "a9e798cae4867e3a41cae2dd9eb60c047f1212db"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.6"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "383a578bdf6e6721f480e749d503ebc8405a0b22"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.6"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2c11d7290036fe7aac9038ff312d3b3a2a5bf89e"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.4.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "9abba8f8fb8458e9adf07c8a2377a070674a24f1"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.8"

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

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XLSX]]
deps = ["Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "7fa8618da5c27fdab2ceebdff1da8918c8cd8b5d"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.7.10"

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
git-tree-sha1 = "3593e69e469d2111389a9bd06bac1f3d730ac6de"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.9.4"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

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
# ╠═fbbedfd3-264b-4dd5-84f9-67c9f674b3f6
# ╟─be0e4aa9-3c2c-4d71-914e-5c0c2a3797ca
# ╠═f7c985b3-731b-4c56-afdb-4c67f47d9c94
# ╠═b4b7ed3f-43f4-479a-9913-519706c02a2f
# ╠═a272d501-5f4f-4f65-9f0d-8e7397935646
# ╟─b8171bbb-d3f4-4236-9d77-3ccffd6d4613
# ╟─48c65f48-f31b-4d5d-acf5-bfa4c36f6a95
# ╟─e4e67907-bab7-4775-bc4d-1072de1faad0
# ╟─5f6a7a63-dbda-45c1-8505-84e2861f9c60
# ╟─112c4c4f-7990-4336-ad37-5fa6b0874024
# ╟─d6c8c0b8-fd89-4a7e-98c3-f1741aa057a1
# ╟─534234e3-e8a3-4d8d-a905-9dc6c59baf8d
# ╟─01797703-30fb-42e7-893a-faa5883fea10
# ╟─5af9b4df-93ac-468b-a23d-a47121cade0a
# ╟─f002d8e5-821a-485c-8a13-0c198935c955
# ╟─4d88b926-9543-11ea-293a-1379b1b5ae64
# ╠═90d44a05-15c2-4a4c-b665-0ded387a6a8d
# ╠═3e1dba04-ee47-4439-a6fa-71a4bf7ea32a
# ╟─b956d523-8f52-4b9b-8885-6c77b9e64c7a
# ╟─f48a0e46-ef4d-4b40-9702-4155ba681df2
# ╟─8fab1792-a13c-470a-83eb-f8d67887e32e
# ╟─755b31d0-c2fb-4687-84c8-bc6cdf2cd34b
# ╟─ecc2af82-2446-4164-b605-d307cae3bdfd
# ╟─84de5da7-e014-448b-9ad9-ef86d4cee3d3
# ╟─dfe8d392-e180-459f-9633-316dfe99ea93
# ╟─a56c4db6-8d98-4c58-9862-97bfb57f430b
# ╟─1e9b21e4-078e-4d3d-8dc2-908181f81267
# ╟─4d970613-94f3-4918-964d-d62df499763a
# ╠═7e054d5e-badd-48e4-b9e2-5ed0aa85de26
# ╠═b40e4488-9409-4a35-b979-f437a54a8276
# ╠═c912c3cf-cd26-4a1a-9189-3d762da321a7
# ╟─856da551-1a93-4baf-8ef6-5946c225f2cd
# ╟─7db34f43-0777-4cc3-a070-8f53a68cdca3
# ╟─1b6b35ab-c02a-4d40-8740-ca39c622260e
# ╟─1417c2e3-2749-4fac-b008-520f89d23503
# ╟─c4dec3a3-6d20-4c09-85a8-f753cd3dc094
# ╟─70f17fd5-c54d-4888-b745-9ac48bf7efb9
# ╠═001b6077-9659-472c-8975-192465264100
# ╟─93134e1f-4cec-4f05-8f18-6428a26afaf8
# ╟─d8a2533f-e241-4d1d-a939-8006b555daef
# ╟─93625590-1e00-42f9-9ff0-a17d1eb2a286
# ╠═ff2f7d91-2c71-4cf4-a8dc-75f18650088b
# ╟─f6eef184-ae45-492e-8896-ae5e755a2b9e
# ╟─025a7287-b093-48a4-980c-f5174fc00f30
# ╠═4f0f0340-8cc2-4820-99a0-94b7e00b50ec
# ╟─c9d0d206-08d7-40a9-a520-eae2c24bc477
# ╟─0a2597c4-4b63-45b5-b170-a8af7d066ead
# ╟─4154d786-0a91-4c05-a159-5afc2b820fec
# ╟─d7ef1697-b832-4038-9d9f-512a74094fca
# ╟─4f30b1ac-195a-45dd-9cc8-aad4cbea0904
# ╟─a2a0aa9d-c6a7-4b72-8f77-5dcd1123732d
# ╠═cec35ba2-6ec0-49a6-abbc-f4cc7ab68cb7
# ╠═c970ab26-9699-4d88-97bf-accd8705a4a0
# ╠═5e58e35f-9ac6-4e0f-b619-86cd6b511629
# ╠═25c06b3a-25ae-4247-9d36-775728f351c6
# ╟─7926881c-f1b3-4b5e-8aa9-97443d16b903
# ╠═1c939645-80f1-4fe8-a497-62b7f22b833c
# ╟─a8d3d0e1-59af-48ed-8bf9-984422cb2ee1
# ╠═cfb7c432-059b-4f25-8f03-33749c77f76a
# ╟─bab3a996-d530-4346-9d7a-35c1f98bd4ff
# ╠═a74b56e5-3a2b-40e3-8e9b-ddf44ef3548c
# ╠═ee5d1450-fea6-4bf1-aaa4-905c1fe40ce8
# ╠═9c8fbd1b-454a-4ee9-aaa8-8a2deddbb6d1
# ╠═0e2b2370-85ad-4eb4-98b1-0452933634bf
# ╟─d0657740-b31d-4efe-be23-dbfd356ac744
# ╟─2cb76c55-488d-4b81-9ae3-dbec88f12deb
# ╠═ec05fea5-62be-4e72-bf06-ce4d03720e0a
# ╠═5f6f9f8b-9b4a-4d80-b964-5e2c010e65fd
# ╠═9e7ebf4c-e911-494d-ad0b-d60019992694
# ╠═7f0c9ebb-ddfc-4ef9-a4a4-48999fca4138
# ╟─2f789cee-c839-4199-8495-93f21be66c3c
# ╠═6fb72be7-d743-4509-88a5-b3a44f67634d
# ╠═df0aae44-d5e4-4152-8707-9f339875ece1
# ╟─75b87a28-3744-4f07-94d4-4d8827329f8c
# ╟─9162c574-1b3d-4660-8369-2cc16f545f44
# ╠═20be3bc6-16ec-4709-a8d8-7b22d8b95379
# ╟─2647fcc9-9d4f-43a6-9712-210bcbf9be3f
# ╟─3cd4208b-4b1c-4d7c-afdb-e6d2addda3cb
# ╟─cded91d4-baf0-46c2-a341-872202a8472c
# ╟─b15ae47f-1905-47af-9831-7c4c9dfcd147
# ╟─445f969a-2d87-42c3-893a-8c5db4f37c48
# ╟─a5efcaed-1e2e-4c6d-b96a-a362bb93c792
# ╟─f7f08d7b-d8a2-4b13-82d5-9b56202a04fc
# ╠═a0e8a024-68b1-488d-83c5-7da9f2f6ddec
# ╠═66334033-d75c-4322-b9b9-d9b0f6d8bcd4
# ╠═122d9ff2-8a55-44fa-9726-df29ad94f27f
# ╠═beb9f6c0-9480-4e3f-9a4a-82be4203918f
# ╟─7bf33c3b-9fb8-4e4a-950d-6c0377fbde8f
# ╟─88de33cf-7cc3-4b17-9d8b-23a7971dbb65
# ╠═b6167c3f-331a-4fc0-bf83-e34a0c63e0a5
# ╠═67f0c700-44f2-4b31-ab82-c8bad5cb4dd2
# ╠═9b4e5e5b-0ec6-4168-8b1c-bea93a17e6b6
# ╠═1a13325e-88e2-4a8d-9b51-e6787a33d70e
# ╠═d251cefe-1d55-4f60-b9b2-e7bfef596cae
# ╠═08b8c340-543c-439e-9bec-c896ded4913e
# ╟─5b9c7938-1b43-40ef-accc-fd72f79a8e83
# ╟─0e03a31f-b062-4fa0-aacb-4d9b4ece185d
# ╠═a342cf0f-7867-4cc3-8d19-32304a05c1af
# ╠═7776654d-8053-492e-8ec8-1b37106b9c77
# ╠═c7ef7ad1-587f-4973-944e-16c6c5a63bb5
# ╠═2f981b1b-5860-4c8b-a2d8-003aee287bd6
# ╠═29774e08-c36f-4907-b060-2fa41699ce2b
# ╠═ab38d1b0-3b47-430e-960d-525ed1894f0d
# ╠═bfc0b5a2-66bc-4891-84fe-93794940a393
# ╠═48d3d9a6-bf9e-450c-a1e8-66dbf95cfbd1
# ╟─de011089-7cb7-40ce-bb51-a0dc81b74f5e
# ╠═6e1ec991-a125-484e-b1c5-a23ac7ee36d7
# ╠═30676169-e350-4a54-8daf-577c9dbfe28f
# ╟─8fa6a139-6cac-4428-b2d2-c2e7058b9906
# ╟─35a01f9e-06e3-45a4-ab08-f16102b7819b
# ╠═b5cc6660-e52d-45fc-90de-c8a4b3c2d9ee
# ╠═0f05f2ee-fe1a-4d85-abec-6a3531182fb9
# ╠═79f4d5b8-7ac9-44fd-95ff-7dbdbc20942b
# ╟─cd686799-ef18-43a1-946f-f79a3eb1327c
# ╠═e1daa7b0-1f65-4263-a5b5-f9f7f79375d2
# ╠═e89ae5fd-f4ec-488c-95d6-6593676ee163
# ╠═20b49e47-5a79-4d72-aaf9-b79b423bde02
# ╠═ddac83ca-c67b-4a07-9990-e8d165630998
# ╠═9152e5a8-3818-4cd6-ad6a-b741f843a24d
# ╠═af21ae80-d242-46aa-ab9f-0ed21f7b1284
# ╟─da88ee62-2b88-4636-8a1b-0a5ec9d7d0c3
# ╠═a445b2f7-1468-4916-b062-80585b441abb
# ╠═e361943a-7ac7-43cb-8dd3-269130c01419
# ╟─8a8d9a85-aabb-4fbf-916c-7f7723f462d7
# ╟─92a37af5-b98d-477c-b824-7a642d56a386
# ╠═53ab6b9d-9835-4ab0-8711-c43fe76c9ac0
# ╠═6b4f6269-b400-430f-921e-9d62a5bfd557
# ╠═8052ad94-2fcd-4184-aa82-9715d5f16d7b
# ╟─8cad4f8e-fcf7-4a4e-ad01-6762174204e3
# ╟─8fc7ad49-27dc-4aad-9237-976e1e9cf37e
# ╠═f1638480-d63e-418e-af69-1201e8e7137e
# ╠═f91f7995-cf8d-4719-80fa-6fe11a0c9dbd
# ╠═c6988b6d-876d-4ec4-8d89-3793e0b68b32
# ╟─f6b8a949-98de-4cb1-ab08-fb1c6acde394
# ╟─624ea283-b640-4241-befc-73ca3c529111
# ╟─486368b5-a701-4eae-bace-b11885178e04
# ╠═74db1ecb-0ca8-4f56-8b28-84b2c21fc008
# ╟─fec7f28f-aab3-491f-afaa-185eb4a3b278
# ╠═585b27eb-1c5a-4f57-a14b-c2b8ac99d3b5
# ╟─c3d684f7-8978-4cc6-b65d-59e6da94cef3
# ╠═f05fda42-ae5d-404a-8e71-25f6f338362a
# ╟─4d2db045-e798-421b-8b76-74271176031a
# ╟─b750f433-babe-40ec-9587-7650c56870d3
# ╟─15bbc002-e797-404d-961b-494e20fef2df
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
