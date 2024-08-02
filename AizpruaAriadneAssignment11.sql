--*  BusIT 103           Assignment   #11              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment11.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


--  It is your responsibility to provide a meaningful column name for the return value of the function 
--  and use an appropriate sort order
	

USE AdventureWorksDW2012;

--1.	Display a count of resellers by country
--		Sort from highest to lowest count of resellers, then by country in alphabetical order. (5 points)
--      6 Rows

SELECT g.EnglishCountryRegionName, COUNT(r.ResellerKey) AS TotalResellers
FROM DimReseller r
INNER JOIN DimGeography g
ON r.GeographyKey = g.GeographyKey
GROUP BY g.EnglishCountryRegionName
ORDER BY TotalResellers DESC, g.EnglishCountryRegionName;


--2.	List customer occupations (use EnglishOccupation) and the number of customers having each occupation.
--		First check to see if there are any customers without an occupation.
--		Add the count returned to see if it makes sense. (5 points)
--      5 Rows

--Checking customers w/o occupation. 0
SELECT *
FROM DimCustomer c
WHERE c.EnglishOccupation IS NULL;

--My query
SELECT c.EnglishOccupation, COUNT(c.CustomerKey) AS CustomerCount
FROM DimCustomer c
GROUP BY c.EnglishOccupation
ORDER BY CustomerCount DESC;

--Adding the count to check the number of customers. 18484
SELECT SUM(co.CustomerCount) AS TotalCustomerCount
FROM 
	(SELECT c.EnglishOccupation, COUNT(c.CustomerKey) AS CustomerCount
	FROM DimCustomer c
	GROUP BY c.EnglishOccupation) AS co;


--3.a.  List all resellers and total sales amount for each.  
--		Show Reseller name, business type, and total sales with the sales showing two decimal places.
--	    Be sure to include resellers for which there are no sales. (5 points)
--      701 Rows
SELECT r.ResellerName, r.BusinessType, ROUND(SUM(frs.SalesAmount), 2) AS TotalSales
FROM DimReseller r
LEFT OUTER JOIN FactResellerSales frs
ON r.ResellerKey = frs.ResellerKey
GROUP BY r.ResellerName, r.BusinessType
ORDER BY TotalSales;


--3.b.	Look up the IsNull function. Copy and paste your statement from 3.a. and use the IsNull function to 
--		replace null total sales amounts with 0. (5 points)
--      701 Rows
SELECT r.ResellerName, r.BusinessType, ISNULL(ROUND(SUM(frs.SalesAmount), 2), 0) AS TotalSales
FROM DimReseller r
LEFT OUTER JOIN FactResellerSales frs
ON r.ResellerKey = frs.ResellerKey
GROUP BY r.ResellerName, r.BusinessType
ORDER BY TotalSales;


--4.    List resellers and total sales for each.  
--		Show reseller name, business type, and total sales.
--		List only those resellers having sales exceeding $500,000. (6 points)
--      31 Rows
SELECT r.ResellerName, r.BusinessType, ROUND(SUM(frs.SalesAmount), 2) AS TotalSales
FROM DimReseller r
INNER JOIN FactResellerSales frs
ON r.ResellerKey = frs.ResellerKey
GROUP BY r.ResellerName, r.BusinessType
HAVING SUM(frs.SalesAmount) > 500000
ORDER BY TotalSales DESC;


--5.    List resellers and total sales for each for 2008.  
--      Show Reseller name, business type, and total sales.
--      List only those resellers having sales exceeding $150,000. (6 points)
--      10 Rows
SELECT r.ResellerName, r.BusinessType, ROUND(SUM(frs.SalesAmount), 2) AS TotalSales
FROM DimReseller r
INNER JOIN FactResellerSales frs
ON r.ResellerKey = frs.ResellerKey
WHERE YEAR(OrderDate) = 2008
GROUP BY r.ResellerName, r.BusinessType
HAVING SUM(frs.SalesAmount) > 150000
ORDER BY TotalSales DESC;


--6.a.	List the amount of the total sales of reseller sales by business type.
--		First find the business type to determine you have them all. Then create your query. (6 points)
--      3 Rows

--Checking the business types. 3
SELECT DISTINCT r.BusinessType
FROM DimReseller r;

--My query
SELECT r.BusinessType, ROUND(SUM(frs.SalesAmount), 2) AS TotalSales
FROM DimReseller r
INNER JOIN FactResellerSales frs
ON r.ResellerKey = frs.ResellerKey
GROUP BY r.BusinessType
ORDER BY TotalSales;


--6.b.	Extra credit challenge. +5 No partial credit given. 
--		List the amount of the average the total sales of reseller sales by business type.
--		To do this find the total sales for each reseller first and then find the average
--		of the total of all sales by a reseller within a business type. 
--      3 Rows

SELECT ts.BusinessType, ROUND(AVG(ts.TotalSales), 2) AS AvgTotalSales
FROM 
	(SELECT r.ResellerName, r.BusinessType, ROUND(SUM(frs.SalesAmount), 2) AS TotalSales
	FROM DimReseller r
	INNER JOIN FactResellerSales frs
	ON r.ResellerKey = frs.ResellerKey
	GROUP BY r.ResellerName, r.BusinessType) AS ts
GROUP BY ts.BusinessType;


--7.	List all customers and the most recent date they placed an order. Do not show the time with the order date. 
--		First find the number of unique customers to determine that your results includes the correct number of customers.
--		Then determine which fields are needed to create accurate information about the customer. (6 points)
--      18484 Rows

--Number of unique customers. 18484
SELECT c.CustomerKey
FROM DimCustomer c;

--My query
SELECT c.CustomerKey, MAX(CONVERT(nvarchar, fis.OrderDate, 101)) AS CustLatestOrder
FROM DimCustomer c
INNER JOIN FactInternetSales fis
ON c.CustomerKey = fis.CustomerKey
GROUP BY c.CustomerKey
ORDER BY c.CustomerKey;


--8.    In your own words, write a business question that you can answer by querying the data warehouse
--      and using an aggregate function with the having clause.
--      Then write the complete SQL query that will provide the information that you are seeking. (6 points)


--List the total of Bikes that where sold in 2007 or later in the States of Oregon, Washington and California.
SELECT g.StateProvinceName, COUNT(fis.OrderQuantity) AS TotalBikes
FROM DimGeography g
INNER JOIN DimCustomer c
ON g.GeographyKey = c.GeographyKey
INNER JOIN FactInternetSales fis
ON c.CustomerKey = fis.CustomerKey
INNER JOIN DimProduct p
ON fis.ProductKey = p.ProductKey
INNER JOIN DimProductSubcategory sc
ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
WHERE sc.ProductCategoryKey = 1 AND YEAR(OrderDate) >= 2007
GROUP BY g.StateProvinceName
HAVING g.StateProvinceName IN ('Oregon', 'Washington', 'California');


-- Double checking my answer
SELECT g.StateProvinceName, fis.OrderQuantity, fis.OrderDate
FROM DimGeography g
INNER JOIN DimCustomer c
ON g.GeographyKey = c.GeographyKey
INNER JOIN FactInternetSales fis
ON c.CustomerKey = fis.CustomerKey
INNER JOIN DimProduct p
ON fis.ProductKey = p.ProductKey
INNER JOIN DimProductSubcategory sc
ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
WHERE sc.ProductCategoryKey = 1 AND YEAR(OrderDate) >= 2007 AND g.StateProvinceName = 'Washington';