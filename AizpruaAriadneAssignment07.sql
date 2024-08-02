--*  BusIT 103           Assignment   #7              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment07.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


USE AdventureWorksDW2012; 

--1.a.	List AdventureWorks male customers.
--		Show first & last names and state.  
--		Order the list by last name, then first name. (1 point)
--      9351 Rows
SELECT C.FirstName, C.LastName, G.StateProvinceName
FROM dbo.DimGeography AS G
INNER JOIN dbo.DimCustomer AS C
ON G.GeographyKey = C.GeographyKey
WHERE C.Gender = 'M'
ORDER BY C.LastName, C.FirstName;


--1.b.	Copy/paste query from 1.a. and modify to list AdventureWorks female customers from Oregon. (4 points)
--		Show first & last names and state.  
--		Order the list by last name, then first name.
--      545 Rows
SELECT C.FirstName, C.LastName, G.StateProvinceName
FROM dbo.DimGeography AS G
INNER JOIN dbo.DimCustomer AS C
ON G.GeographyKey = C.GeographyKey
WHERE C.Gender = 'F' AND G.StateProvinceName = 'Oregon'
ORDER BY C.LastName, C.FirstName;


--2.a.	Explore the data warehouse using the Dim.Product table.  
--		Show the English product name, product key, product alternate key, standard cost and list price.
--		Sort on English product name. Note how the name and the alternate key remain the same but the
--		product is entered again using with a new primary key to reflect the history of changes to the product attributes. (1 point)
--	    606 rows
SELECT P.EnglishProductName, P.ProductKey, P.ProductAlternateKey, P.StandardCost, P.ListPrice
FROM dbo.DimProduct AS P
ORDER BY P.EnglishProductName;


--2.b.	Show the English product name and product alternate key for each product only once.
--		Sort on English product name. Note the difference in record count. (1 point)
--		504 rows
SELECT DISTINCT P.EnglishProductName, P.ProductAlternateKey
FROM dbo.DimProduct AS P
ORDER BY P.EnglishProductName;


--2.c.	List Products, their subcategories and their categories with each product appearing only once.
--		Show the English category name, English subcategory name, product alternate key, and English product name.
--		Sort the results by the English category name, English subcategory name, and English product name 
--		The record count will go down again because some products in the product table are inventory and
--		not for sale. They don't have a value in the ProductSubcategory field. (5 points)
--		295 rows
SELECT DISTINCT C.EnglishProductCategoryName, S.EnglishProductSubcategoryName, P.ProductAlternateKey, P.EnglishProductName
FROM dbo.DimProductCategory AS C
INNER JOIN dbo.DimProductSubcategory AS S
ON C.ProductCategoryKey = S.ProductCategoryKey
INNER JOIN dbo.DimProduct AS P
ON S.ProductSubcategoryKey = P.ProductSubcategoryKey
ORDER BY C.EnglishProductCategoryName, S.EnglishProductSubcategoryName, P.EnglishProductName;


--3.	List all English named products purchased over the Internet by customers who have a graduate degree.
--		Show Product key and English Product Name and English Education.  
--		Order the list by English Product name. (5 points)
--		Show a product only once even if it has been purchased several times.
--		155 Rows
SELECT DISTINCT P.ProductKey, P.EnglishProductName, C.EnglishEducation
FROM dbo.DimProduct AS P
INNER JOIN dbo.FactInternetSales AS FIS
ON P.ProductKey = FIS.ProductKey
INNER JOIN dbo.DimCustomer AS C
On FIS.CustomerKey = C.CustomerKey
WHERE C.EnglishEducation = 'Graduate Degree'
ORDER BY P.EnglishProductName;


--4.	List all English named products purchased over the Internet by customers whose work in professional or managerial jobs.
--		Show Product key and English Product Name and English Occupation.  
--		Order the list by English Product name. (5 points)
--		Show a product only once even if it has been purchased several times.
--	    314 Rows
SELECT DISTINCT P.ProductKey, P.EnglishProductName, C.EnglishOccupation
FROM dbo.DimProduct AS P
INNER JOIN dbo.FactInternetSales AS FIS
ON P.ProductKey = FIS.ProductKey
INNER JOIN dbo.DimCustomer AS C
On FIS.CustomerKey = C.CustomerKey
WHERE C.EnglishOccupation IN ('Professional', 'Management')
ORDER BY P.EnglishProductName;


--5.	List customers who have purchased accessories over the Internet.  
--		Show customer first name and last name, and English product category.
--		If a customer has purchased accessories more than once, show only 1 row for that customer.  That customer should not appear twice.
--		Order the list by last name, then first name. (6 points)
--		15,062 rows
SELECT DISTINCT C.FirstName, C.LastName, PC.EnglishProductCategoryName
FROM dbo.DimProductCategory AS PC
INNER JOIN dbo.DimProductSubcategory AS S
ON PC.ProductCategoryKey = S.ProductCategoryKey
INNER JOIN dbo.DimProduct AS P
ON S.ProductSubcategoryKey = P.ProductSubcategoryKey
INNER JOIN dbo.FactInternetSales AS FIS
ON P.ProductKey = FIS.ProductKey
INNER JOIN dbo.DimCustomer AS C
ON FIS.CustomerKey = C.CustomerKey
WHERE PC.EnglishProductCategoryName = 'Accessories'
ORDER BY C.LastName, C.FirstName;


--6.	List all Internet sales for clothing that occurred during 2007 (Order Date in 2007).  
--		Show product Key, Product name, and SalesAmount for each line item sale.
--		Show the date as mm/dd/yyyy as DateOfOrder. (6 points)
--		Show the list in oldest to newest order by date and alphabetically by Product name.
--	    3708 Rows
SELECT P.ProductKey, P.EnglishProductName, FIS.SalesAmount, CONVERT(nvarchar(10), FIS.OrderDate, 101) AS 'DateOfOrder'
FROM dbo.DimProductCategory AS PC
INNER JOIN dbo.DimProductSubcategory AS S
ON PC.ProductCategoryKey = S.ProductCategoryKey
INNER JOIN dbo.DimProduct AS P
ON S.ProductSubcategoryKey = P.ProductSubcategoryKey
INNER JOIN dbo.FactInternetSales AS FIS
ON P.ProductKey = FIS.ProductKey
WHERE PC.EnglishProductCategoryName = 'Clothing' AND YEAR(FIS.OrderDate) = '2007'
ORDER BY DateOfOrder ASC, P.EnglishProductName ASC;


--7.	List all Internet sales of Bikes purchased by customers in British Columbia during 2006.  
--		Show product Key, product name, and SalesAmount for each line item sale.
--		Show the list in order alphabetically by product name. (6 points)
--		223 Rows
SELECT P.ProductKey, P.EnglishProductName, FIS.SalesAmount
FROM dbo.DimProductCategory AS PC
INNER JOIN dbo.DimProductSubcategory AS S
ON PC.ProductCategoryKey = S.ProductCategoryKey
INNER JOIN dbo.DimProduct AS P
ON S.ProductSubcategoryKey = P.ProductSubcategoryKey
INNER JOIN dbo.FactInternetSales AS FIS
ON P.ProductKey = FIS.ProductKey
INNER JOIN dbo.DimCustomer AS C
ON FIS.CustomerKey = C.CustomerKey
INNER JOIN dbo.DimGeography AS G
ON C.GeographyKey = G.GeographyKey
WHERE PC.EnglishProductCategoryName = 'Bikes' AND G.StateProvinceName = 'British Columbia' AND YEAR(FIS.OrderDate) = '2006'
ORDER BY P.EnglishProductName;


--8.	In your own words, write a business question that you can answer by querying the data warehouse.
--		Then write the SQL query that will provide the information that you are seeking. (10 points)

--      I would like to know the bikes sales made by females customers in the State of Washington.
--		Show product Key, product first name and last name as CustomerName, Gender and Sales Amount for each line item sale.
--		Sort by Product Name, then Customer Name.

SELECT P.ProductKey, P.EnglishProductName, C.FirstName + ' ' + C.LastName AS CustomerName, C.Gender, FIS.SalesAmount
FROM dbo.DimProductCategory AS PC
INNER JOIN dbo.DimProductSubcategory AS S
ON PC.ProductCategoryKey = S.ProductCategoryKey
INNER JOIN dbo.DimProduct AS P
ON S.ProductSubcategoryKey = P.ProductSubcategoryKey
INNER JOIN dbo.FactInternetSales AS FIS
ON P.ProductKey = FIS.ProductKey
INNER JOIN dbo.DimCustomer AS C
ON FIS.CustomerKey = C.CustomerKey
INNER JOIN dbo.DimGeography AS G
ON C.GeographyKey = G.GeographyKey
WHERE PC.EnglishProductCategoryName = 'Bikes' AND G.StateProvinceName = 'Washington' AND C.Gender = 'F'
ORDER BY P.EnglishProductName, CustomerName;

	


