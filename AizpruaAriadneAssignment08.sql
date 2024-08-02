--*  BusIT 103           Assignment   #8              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task. 
--Each task must be accomplished using some type of OUTER JOIN. 

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment08.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


Use AdventureWorksDW2012;

--IMPORTANT NOTE: Only one LEFT OUTER JOIN is to be used for each task. 
--The use of more than one LEFT OUTER JOIN per task will cause points to be TAKEN OFF.

--NOTE:  When the task does not specify sort order, it is your responsibility to order the information
--    so that is easy to interpret.


--  1.  List all Sales Reasons that have not been associated with an internet sale. (4 points)
--      Hint:  Use factInternetSalesReason and dimSalesReason. 
--		3 Rows
SELECT sr.SalesReasonKey, sr.SalesReasonName, sr.SalesReasonReasonType
FROM DimSalesReason sr
LEFT OUTER JOIN FactInternetSalesReason f
ON sr.SalesReasonKey = f.SalesReasonKey
WHERE f.SalesReasonKey IS NULL;


--2.    List all internet sales that do not have at least 1 sales reason associated.
--      List SalesOrderNumber, SalesOrderLineNumber and the order date. (4 points)
--      Hint:  Use factInternetSales and factInternetSalesReason. 
--		6429 rows
SELECT fis.SalesOrderNumber, fis.SalesOrderLineNumber, CONVERT(NVARCHAR, fis.OrderDate, 103) AS OrderDate
FROM FactInternetSales fis
LEFT OUTER JOIN FactInternetSalesReason fisr
ON fis.SalesOrderNumber = fisr.SalesOrderNumber
WHERE fisr.SalesOrderNumber IS NULL
ORDER BY fis.SalesOrderNumber;


--  3.  List all promotions that have not been associated with a reseller sale. (4 points)
--		4 Rows
SELECT p.PromotionKey, p.EnglishPromotionName, p.EnglishPromotionCategory
FROM DimPromotion p
LEFT OUTER JOIN FactResellerSales frs
ON p.PromotionKey = frs.PromotionKey
WHERE frs.PromotionKey IS NULL
ORDER BY p.EnglishPromotionName;


--4.    Find any cities in which AdventureWorks has no customers
--      List city, state/province, and the English country/region name
--      List each city only one time. Sort by country, state, and city. (4 points)
--		303 Rows
SELECT DISTINCT g.City, g.StateProvinceName, g.EnglishCountryRegionName
FROM DimGeography g
LEFT OUTER JOIN DimCustomer c
ON g.GeographyKey = c.GeographyKey
WHERE c.GeographyKey IS NULL
ORDER BY g.EnglishCountryRegionName, g.StateProvinceName, g.City;


--5.    Find any cities in which AdventureWorks has no resellers
--      List city, state/province, and the English country/region name
--      List each city only one time. Sort by country, state, and city. (4 points)
--		133 Rows
SELECT DISTINCT g.City, g.StateProvinceName, g.EnglishCountryRegionName
FROM DimGeography g
LEFT OUTER JOIN DimReseller r
ON g.GeographyKey = r.GeographyKey
WHERE r.GeographyKey IS NULL
ORDER BY g.EnglishCountryRegionName, g.StateProvinceName, g.City;


--6.    Write a query to determine if there are any product categories that do not have 
--      related sub categories. (4 points)
--		0 Rows
SELECT p.ProductCategoryKey, p.EnglishProductCategoryName
FROM DimProductCategory p
LEFT OUTER JOIN DimProductSubcategory sc
ON p.ProductCategoryKey = sc.ProductCategoryKey
WHERE sc.ProductCategoryKey IS NULL;


--7.    Find all promotions and any related internet sales. List unique instances of the 
--      english promotion name, customer first and last name, and the order date.
--      Sort by the promotion name. Be sure to list all promotions even if there is no related sale. (4 points)
--		29199 Rows
SELECT DISTINCT p.EnglishPromotionName, c.FirstName, c.LastName, fis.OrderDate
FROM DimPromotion p
LEFT OUTER JOIN 
    (FactInternetSales fis
    INNER JOIN DimCustomer c
	ON fis.CustomerKey = c.CustomerKey)
ON p.PromotionKey = fis.PromotionKey
ORDER BY p.EnglishPromotionName;


--8.    Find all promotions and any related reseller sales. List unique instances of the english 
--      promotion name, reseller name, and the order date.
--      Sort by the promotion name. Be sure to list all promotions even if there is no related sale. (4 points)
--		5174 Rows
SELECT DISTINCT p.EnglishPromotionName, r.ResellerName, frs.OrderDate
FROM DimPromotion p
LEFT OUTER JOIN
    (FactResellerSales frs
	INNER JOIN DimReseller r
	ON frs.ResellerKey = r.ResellerKey)
ON p.PromotionKey = frs.PromotionKey
ORDER BY p.EnglishPromotionName;


--9.    List reseller name for resellers who have not sold any bikes. (4 points)
--		114 Rows
SELECT r.ResellerName, rnb.ResellerKey, rnb.OrderDate, rnb.EnglishProductName
FROM DimReseller r
LEFT OUTER JOIN
     (SELECT frs.ResellerKey, frs.OrderDate, p.EnglishProductName
	 FROM FactResellerSales frs
	 INNER JOIN DimProduct p
	 ON frs.ProductKey = p.ProductKey
	 INNER JOIN DimProductSubcategory psc
	 ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
	 WHERE psc.ProductCategoryKey = 1) AS rnb
ON r.ResellerKey = rnb.ResellerKey
WHERE rnb.ResellerKey IS NULL
ORDER BY r.ResellerName;


--10.   List all male customers and any clothing they have purchased over the internet.
--      List customer alternate key, customer last name, customer first name, 
--      product alternate key, and product name.  Be sure to include male customers who have not 
--      purchased clothing. (4 points)
--		10497 Rows
SELECT c.CustomerAlternateKey, c.LastName, c.FirstName, coi.ProductAlternateKey, coi.EnglishProductName
FROM DimCustomer c
LEFT OUTER JOIN
     (SELECT fis.CustomerKey, p.ProductAlternateKey, p.EnglishProductName
	 FROM FactInternetSales fis
	 INNER JOIN DimProduct p
	 ON fis.ProductKey = p.ProductKey
	 INNER JOIN DimProductSubcategory psc
	 ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
	 WHERE psc.ProductCategoryKey = 3) AS coi
ON c.CustomerKey = coi.CustomerKey
WHERE c.Gender = 'M'
ORDER BY c.LastName, c.FirstName;


--11.   In your own words, write a business question that you can answer by querying the data warehouse 
--      and using an outer join.
--      Then write the SQL query that will provide the information that you are seeking. (10 points)

--List all the female customers in the State of Washington and any bikes they have purchase over the internet. 
--All the females who have not made any bike purchase in any state are also included.

SELECT cu.LastName, cu.FirstName, boi.EnglishProductName, boi.StateProvinceName
FROM DimCustomer cu
LEFT OUTER JOIN
     (SELECT p.ProductKey, p.EnglishProductName, c.CustomerKey, c.LastName, c.FirstName, g.StateProvinceName 
	 FROM DimProductSubcategory sc
	 INNER JOIN DimProduct p
	 ON sc.ProductSubcategoryKey = p.ProductSubcategoryKey
	 INNER JOIN FactInternetSales fis
	 ON p.ProductKey = fis.ProductKey
	 INNER JOIN DimCustomer c
	 ON fis.CustomerKey = c.CustomerKey
	 INNER JOIN DimGeography g
	 ON c.GeographyKey = g.GeographyKey
	 WHERE sc.ProductCategoryKey = 1 AND g.StateProvinceName = 'Washington') AS boi
ON cu.CustomerKey = boi.CustomerKey
WHERE cu.Gender = 'F'
ORDER BY cu.LastName, cu.FirstName;
