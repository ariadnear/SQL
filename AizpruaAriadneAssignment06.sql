--*  BusIT 103           Assignment   #6              DUE DATE :  Consult course calendar
							
--You are required to use INNER JOINs to solve each problem. We are not using cross joins with WHERE clauses. 
--Even if you know another method that will produce the result, this module is practice in INNER JOINs.

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment06.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


--You are to develop SQL statements for each task listed. You should type your SQL statements under each task. 


USE AdventureWorks2012;

--  You are required to use INNER JOINs to solve each problem. We are not using cross joins with WHERE clauses.
--  To make the joins in the first 4 question more understandable, create a database diagram with the following tables:
	--Production.Product
	--Production.ProductReview
	--Production.ProductModel
	--Production.ProductSubcategory
	--Production.ProductCategory

--1.a.	List any products that have product reviews.  Show product ID, product name, and comments.
--		Hint:  Use the Production.Product and Production.ProductReview tables. (1 points)
--		4 Rows
 SELECT P.ProductID, P.Name AS ProductName, R.Comments
 FROM Production.Product AS P
 INNER JOIN Production.ProductReview AS R
 ON P.ProductID = R.ProductID;

--1.b.	Modify 1.a. to list product reviews for Product ID 798.  Show product ID, product name,
-- and comments. (6 points)
--		1 Row
 SELECT P.ProductID, P.Name AS ProductName, R.Comments
 FROM Production.Product AS P
 INNER JOIN Production.ProductReview AS R
 ON P.ProductID = R.ProductID
 WHERE P.ProductID = 798;


--2.a.	List products with product model numbers. Show Product ID, product name, 
--		standard cost, model ID number, and model name. Order by model ID. (1 points)
--		Hint: Look for a table that contains "model" in its name
--		295 Rows
SELECT P.ProductID, P.Name AS ProductName, P.StandardCost, M.ProductModelID, M.Name AS ModelName
FROM Production.Product AS P
INNER JOIN Production.ProductModel AS M
ON P.ProductModelID = M.ProductModelID
ORDER BY M.ProductModelID;


--2. b.	Modify 2.a. to list products whose product model is 3 (Full-Finger Gloves). Show Product ID , product name, 
--		standard cost, ID number, and model name and order by model ID. (6 points)
--		3 Rows
SELECT P.ProductID, P.Name AS ProductName, P.StandardCost, M.ProductModelID, M.Name AS ModelName
FROM Production.Product AS P
INNER JOIN Production.ProductModel AS M
ON P.ProductModelID = M.ProductModelID
WHERE M.ProductModelID = 3
ORDER BY M.ProductModelID;


--3. a.	List Products, their subcategories and their categories.  Show the category name, subcategory name, 
--		product ID, and product name, in this order. Sort in alphabetical order on category name,
--		then subcategory name, and then by product name. (1 points)
--		295 Rows

--		Hint:  To understand the relationshships, refer to your database diagram and the following tables:
--		Production.Product
--		Production.ProductSubCategory
--		Production.ProductCategory
SELECT C.Name AS CategoryName, S.Name AS SubcategoryName, P.ProductID, P.Name AS ProductName
FROM Production.ProductCategory AS C
INNER JOIN Production.ProductSubcategory AS S
ON C.ProductCategoryID = S.ProductCategoryID
INNER JOIN Production.Product AS P
ON S.ProductSubcategoryID = P.ProductSubcategoryID
ORDER BY CategoryName, SubcategoryName, ProductName;


--3. b.	Modify 3.a. to list Products in category 1.  Show the category name, subcategory name, 
--		product ID, and product name, in this order. Sort in alphabetical order on category name,
--		then subcategory name, and then by product name. (6 points)
--		Hint: Add the product category id field to the results set to check your results and then remove it or comment it out.
--		97 Rows
SELECT C.Name AS CategoryName, S.Name AS SubcategoryName, P.ProductID, P.Name AS ProductName
FROM Production.ProductCategory AS C
INNER JOIN Production.ProductSubcategory AS S
ON C.ProductCategoryID = S.ProductCategoryID
INNER JOIN Production.Product AS P
ON S.ProductSubcategoryID = P.ProductSubcategoryID
WHERE C.ProductCategoryID = 1
ORDER BY CategoryName, SubcategoryName, ProductName;


--4.a.	List Products, their subcategories, their categories, and their model.  Show the model name, category name, 
--		subcategory name, product ID, and product name in this order. Sort in alphabetical order by model name. (1 points)
--		295 Rows

--		Hint:  To understand the relationshships, refer to your database diagram and the following tables:
--		Production.Product
--		Production.ProductSubCategory
--		Production.ProductCategory
--		Production.ProductModel
--		Choose a path from one table to the next and follow it in a logical order
SELECT M.Name AS ModelName, C.Name AS CategoryName, S.Name AS SubcategoryName, P.ProductID, P.Name AS ProductName 
FROM Production.ProductCategory AS C
INNER JOIN Production.ProductSubcategory AS S
ON C.ProductCategoryID = S.ProductCategoryID
INNER JOIN Production.Product AS P
ON S.ProductSubcategoryID = P.ProductSubcategoryID
INNER JOIN Production.ProductModel AS M
ON P.ProductModelID = M.ProductModelID
ORDER BY ModelName;


--4. b.	Modify 4.a. to list those products in model ID 5 with silver in the product name. Change
-- the sort to sort only on Product ID. Hint: Add the product model id field to the results set to
-- check your results and then remove it or comment it out. (6 points)
--	5 Rows
SELECT M.Name AS ModelName, C.Name AS CategoryName, S.Name AS SubcategoryName, P.ProductID, P.Name AS ProductName
FROM Production.ProductCategory AS C
INNER JOIN Production.ProductSubcategory AS S
ON C.ProductCategoryID = S.ProductCategoryID
INNER JOIN Production.Product AS P
ON S.ProductSubcategoryID = P.ProductSubcategoryID
INNER JOIN Production.ProductModel AS M
ON P.ProductModelID = M.ProductModelID
WHERE M.ProductModelID = 5 AND P.Name Like '%silver%'
ORDER BY ProductID;


--5.	List sales for customer id 18759.  Show product names, sales order id, and OrderQty. (5 points)
--		8 Rows
--		Hint:  First create a database diagram with the following tables:
--		Production.Product
--		Sales.SalesOrderHeader
--		Sales.SalesOrderDetail
SELECT P.Name AS ProductName, SOH.SalesOrderID, SOD.OrderQty
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product AS P
ON SOD.ProductID = P.ProductID
WHERE SOH.CustomerID = 18759;


--6.	List all sales for Bikes that were ordered during 2008.  Show product ID, product name,
-- and LineTotal for each line item sale.
--	Show the list in order alphabetically by product name. (7 points)
--	 Hint: Use the diagram you created in #5
--	11378 Rows. IMP: If using AdventureWorks2017, # of rows will be different. See below for more info 
/*
NOTE: If you are using AdventureWorks2017 Database (DB), your result set might be slightly different
 than what you would normally see with 2012 DB. So, do not worry too much about the number of 
rows returned by SQL Server when using 2017 DB. If your SQL/code is correct, I will run it 
under 2012 DB and it will be fine.Q#6: AdventureWorks2017 does not have OrderDate for year 2008.
So, you will use any year of your choice from 2011- 2014. Your result in that case will NOT be
11378 Rows and that is OK. I will run your query on 2012.
*/
SELECT P.ProductID, P.Name AS ProductName, SOD.LineTotal
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product AS P
ON SOD.ProductID = P.ProductID
INNER JOIN Production.ProductSubcategory AS S
ON P.ProductSubcategoryID = S.ProductSubcategoryID
WHERE S.Name LIKE '%Bikes%' AND SOH.OrderDate BETWEEN '2008-01-01' AND '2008-12-31'
ORDER BY ProductName;

	
--7.	In your own words, write a business question for AdventureWorks that you will try to answer with a SQL query.
--		Then try to develop the SQL to answer the question. (10 points)
--		You may find that the AdventureWorks database structure is highly normalized and therefore, difficult
--		to work with.  As a result, you may not run into difficulties when developing your SQL.  For this task
--		that is fine.  Just show your question and as much SQL as you were able to figure out. 

-- List all the Bikes. Show product ID, product name, product color, and order quantity.
-- Sort by product name and then by color.

-- In the future, I would like to work in grouping by color to know what are the most sold colors of bikes. 
-- After running this query, it seems like every product name (bikes) comes in only one color.

SELECT P.ProductID, P.Name AS BikeName, P.Color, SOD.OrderQty
FROM Production.ProductSubcategory AS S
INNER JOIN Production.Product AS P
ON S.ProductSubcategoryID = P.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail AS SOD
ON P.ProductID = SOD.ProductID
WHERE S.Name LIKE '%Bikes%'
ORDER BY BikeName, P.Color;
