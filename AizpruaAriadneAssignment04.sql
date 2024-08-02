--*  BusIT 103           Assignment   #4              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment04.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


USE AdventureWorksLT2012;

--1.  List the name, product number, size, and standard cost in alphabetical order by name for Products 
--    whose Standard Cost is $1000 or more. (5 points)
--    41 rows
SELECT Product.Name, Product.ProductNumber, Product.Size, Product.StandardCost 
FROM SalesLT.Product
WHERE Product.StandardCost >= 1000
ORDER BY Product.Name ASC;


--2.  Use the SalesLT.Address table to list addresses in Alberta or Manitoba. Select the address1, 
--    city, state/province, country/region and postal code. Sort by state/province and then by city. (5 points)
--    15 rows
SELECT Address.AddressLine1, Address.City, Address.StateProvince, Address.CountryRegion, Address.PostalCode
FROM SalesLT.Address
WHERE Address.StateProvince = 'Alberta' OR Address.StateProvince = 'Manitoba'
ORDER BY Address.StateProvince, Address.City;


--3.  List the company name and phone for those customers whose phone number contains the following sequence: 555.
--    Order the list by phone number in ascending order. (5 points)
--    407 rows
SELECT Customer.CompanyName, Customer.Phone
FROM SalesLT.Customer
WHERE Customer.Phone LIKE '%555%'
ORDER BY Customer.Phone ASC;
 

--4.  List the name, product number, list price and size for products whose size is one of the following:  S, M, L, XL.
--	  Order the list by the product number in ascending order. (5 points)
--    34 rows
SELECT Product.Name, Product.ProductNumber, Product.ListPrice, Product.Size
FROM SalesLT.Product
WHERE Product.Size IN ('S', 'M', 'L', 'XL')
ORDER BY Product.ProductNumber ASC;


--5.  List the name, product number, standard cost and weight for products whose standard cost is less than $1000 
--	  and whose weight is greater than 5000. Round money values to exactly 2 decimal places and name the column StdCost. 
--    Sort by product number. (5 points)
--    58 rows
SELECT Product.Name, Product.ProductNumber, ROUND(Product.StandardCost, 2) AS 'StdCost', Product.Weight
FROM SalesLT.Product
WHERE Product.StandardCost < 1000 AND Product.Weight > 5000
ORDER BY Product.ProductNumber;

 
--6.  List Victoria and Vancouver addresses from the SalesLT.Address table. 
--	  Select the address1, city, state/province and postal code. (5 points)
--    Order the list by city.
--    7 rows
SELECT Address.AddressLine1, Address.City, Address.StateProvince, Address.PostalCode
FROM SalesLT.Address
WHERE Address.City IN ('Victoria', 'Vancouver')
ORDER BY Address.City;


--7.  Copy/paste the query from question 6. Modify it to return Victoria and Vancouver addresses located 
--    only in British Columbia. 
--	  Note: There is a Victoria in Texas and one in Australia, to name two. Be sure to write your filter to remove instances of Victoria 
--    outside British Columbia. (5 points)
--    6 rows
SELECT Address.AddressLine1, Address.City, Address.StateProvince, Address.PostalCode
FROM SalesLT.Address
WHERE Address.City IN ('Victoria', 'Vancouver') AND Address.StateProvince = 'British Columbia'
ORDER BY Address.City;


--8.  List the name and product number for all products in the Product table that have not been discontinued.
--    Note that the DiscontinuedDate is not included in the results set. You may want to add it to verify your
--    results and then remove it again.  (5 points)
--    295 rows
SELECT Product.Name, Product.ProductNumber
FROM SalesLT.Product
WHERE Product.DiscontinuedDate IS NULL;


--9.  List the name and product number for all products in the Product table that include 'bike' in the name.
--    Sort by the name. (Something to think about--How many of these products are actually bikes?) (5 points)
--    5 rows	
SELECT Product.Name, Product.ProductNumber
FROM SalesLT.Product
WHERE Product.Name LIKE '%bike%'
ORDER BY Product.Name;


--10. List the name and product category id, and parent id for all product categories that include 'bike' in the name.
--    Sort by the parent product category id. (5 points)
--    (Something else to consider--How many of these products are bikes?)
--    6 rows	
SELECT ProductCategory.Name, ProductCategory.ProductCategoryID, ProductCategory.ParentProductCategoryID
FROM SalesLT.ProductCategory
WHERE ProductCategory.Name LIKE '%bike%'
ORDER BY ProductCategory.ParentProductCategoryID;
