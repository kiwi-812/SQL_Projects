USE [SQL WITH TDI];

/*Convert all customer names to lowercase and display the result,
ordering by the lowercase customer name*/

SELECT 
	DISTINCT(LOWER(Customer_Name)) AS NAME 
FROM SALES 
ORDER BY NAME;

/*Convert all customer names to uppercase and display 
the total sales foreach customer, grouped by the uppercase name*/

SELECT 
	UPPER(Customer_Name) AS NAME,
	ROUND(SUM(Sales),2) AS TotalSales 
FROM SALES 
GROUP BY UPPER(Customer_Name);

/*Concatenate the customer name and city with a comma and space between them,
and order the results by the combined string*/

SELECT 
	DISTINCT(CONCAT(Customer_Name,' , ',City)) AS "NAME , CITY"
FROM SALES
ORDER BY "NAME , CITY";

/*Extract the first three characters of the customer names and display the result,
ordering by the substring*/

SELECT 
	DISTINCT(SUBSTRING(Customer_Name,1,3)) AS Abbreviation  
FROM SALES
ORDER BY Abbreviation;

/*Get the first character of the customer names COMBINED WITH LAST NAME
and calculate the total salesfor these grouped names*/

SELECT 
	CONCAT(SUBSTRING(Customer_Name,1,1),'.',SUBSTRING(Customer_Name,CHARINDEX(' ',Customer_Name)+1,LEN(Customer_Name))) AS NAME,
	ROUND(SUM(Sales),2) AS TotalSales
FROM SALES
GROUP BY CONCAT(SUBSTRING(Customer_Name,1,1),'.',SUBSTRING(Customer_Name,CHARINDEX(' ',Customer_Name)+1,LEN(Customer_Name)))
ORDER BY TotalSales DESC;

/*Get the last three characters of the customer names and display the result,
ordering by the last three characters*/

SELECT 
	DISTINCT(SUBSTRING(Customer_Name,LEN(Customer_Name)-2, LEN(Customer_Name))) AS Last3Characters
FROM SALES
ORDER BY Last3Characters;

/*Replace all spaces in customer names with underscores 
and calculate the total quantity of items ordered by each modified name,*/

SELECT 
	REPLACE(Customer_Name,' ','_') AS NAME,
	SUM(CONVERT(INT, Quantity)) AS TotalQuantity
FROM SALES
GROUP BY REPLACE(Customer_Name,' ','_')
ORDER BY NAME;

/*Find the length of each customer name 
and display the result, ordering by the length*/

SELECT  
	DISTINCT(Customer_Name),
	LEN(Customer_Name) AS Length
FROM SALES
ORDER BY Length;

/*Remove leading and trailing spaces from customer names (if any) 
and display the result, ordering by the trimmed names*/

SELECT DISTINCT(TRIM(Customer_Name)) AS NAME
FROM SALES
ORDER BY NAME;

/*Remove leading spaces from customer names and display the result
where the customer name starts with 'A', ordering by the trimmed names*/

SELECT 
	DISTINCT(LTRIM(Customer_Name)) AS "LEADING" 
FROM SALES
WHERE 
	LTRIM(Customer_Name) LIKE 'A%'
ORDER BY "LEADING";


/*Remove trailing spaces from customer names and display the result 
where the length of the customer name is greater than 10, ordering by the trimmed names*/

SELECT 
	DISTINCT(RTRIM(Customer_Name)) AS "TRAILING" 
FROM SALES
WHERE 
	LEN(RTRIM(Customer_Name)) = 10
ORDER BY "TRAILING";

/*Display customer names, replacing NULL values with 'Unknown', TotalPurchase
and order by TotalPurchase.*/

SELECT 
	CASE WHEN Customer_Name IS NULL THEN 'Unknown'
	ELSE Customer_Name END AS "NAME",
	COUNT(*) AS TotalPurchase
FROM SALES
GROUP BY 
	CASE WHEN Customer_Name IS NULL THEN 'Unknown'
	ELSE Customer_Name END
ORDER BY TotalPurchase DESC;

