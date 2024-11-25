--Questions:

/* 1. Create a query to categorize orders based on the `Profit` column:
	- 'Loss' for profits less than 0
	- 'Low Profit' for profits between 0 and 100
	- 'High Profit' for profits greater than 100. */

SELECT Order_ID, SUM(Profit) AS PROFIT, 
		CASE WHEN SUM(Profit) < 0 THEN 'Loss'
			 WHEN SUM(Profit) BETWEEN 0 AND 100 THEN 'Low Profit'
			 ELSE 'High Profit'
		END AS ProfitCategories
FROM SALES
GROUP BY Order_ID;

/* 2. Write a query to display the `Customer Name` along with 
	a flag indicating if their order quantity is 
	'High' (Quantity > 10) or 'Low' (Quantity<= 10).*/

SELECT Customer_Name, SUM(CONVERT(INT,Quantity)) AS Quantity,
		CASE WHEN SUM(CONVERT(INT,Quantity)) > 10 THEN 'High'
		ELSE 'Low' END AS QuantityIndicator
FROM SALES
GROUP BY Customer_Name;

/* 3. Create a query to classify orders based on the `Ship Mode`:
	- 'Fast' for 'First Class'
	- 'Standard' for 'Standard Class'*/

SELECT Order_ID, Ship_Mode,
		CASE WHEN Ship_Mode = 'First Class' THEN 'Fast'
		ELSE 'Standard' END AS QuantityIndicator
FROM SALES;

/* 4. Write a query to show the `Sales` along with a message indicating if
	the sales are 'Above Average' or 'Below Average', considering the
	 average sales of all orders*/

SELECT Order_ID, SUM(Sales) AS TotalSales, 
		CASE WHEN SUM(Sales) < (SELECT AVG(Sales)FROM SALES) THEN 'Below Average'
			 ELSE 'Above Average'
		END AS SalesIndicator
FROM SALES
GROUP BY Order_ID;

/*----------------------------------------------------------------------------------------------------------*/
-- Views:

/* 1. Create a view named ‘sales_summary’ that shows the total sales,
	quantity, and profit for each region.*/

CREATE VIEW Sales_Summary AS
	SELECT 
		Region, 
		SUM(CONVERT(INT,Quantity)) AS TotalQuantity, 
		SUM(CONVERT(INT,Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit 
	FROM SALES 
	GROUP BY Region;

/* 2. Modify the ‘sales_summary’ view to include the category and
	subcategory columns.*/
 
 ALTER VIEW Sales_Summary AS
	SELECT 
		Region, Category, Sub_Category,
		SUM(CONVERT(INT,Quantity)) AS TotalQuantity, 
		SUM(CONVERT(INT,Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit 
	FROM SALES 
	GROUP BY Region, Category, Sub_Category;

 /* 3. Drop the ‘sales_summary’ view.*/
 
 DROP VIEW Sales_Summary;
 
 /* 4. Create a view named ‘customer sales’ that shows the total sales
	and profit for each customer*/
 
 CREATE VIEW "Customer Sales" AS 
	SELECT 
		Customer_Name,
		SUM(CONVERT(INT,Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit 
	FROM SALES 
	GROUP BY Customer_Name;
 
 /* 5. Modify the ‘customer sales’ view to include 
	the city and state columns.*/
 
 ALTER VIEW "Customer Sales" AS
	SELECT 
		Customer_Name, State, City,
		SUM(CONVERT(INT,Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit 
	FROM SALES 
	GROUP BY Customer_Name, State, City;
 
 /* 6. Create a view named ‘product_sales’ that shows the total sales
	 and profit for each product category and subcategory.*/

CREATE VIEW Product_Sales AS
	SELECT 
		Category, Sub_Category,
		SUM(CONVERT(INT,Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit 
	FROM SALES 
	GROUP BY Category, Sub_Category;

/*----------------------------------------------------------------------------------------------------------*/
-- AdvancedSQLqueries

/* 1. Write a query to find the top 3 customers with the highest total sales.*/

SELECT 
	TOP(3) Customer_Name, SUM(Sales) AS TotalSales 
FROM SALES
GROUP BY Customer_Name
ORDER BY TotalSales DESC;

/* 2. Write a query to find the total sales and profit for each region,
	including only orders with a specific ship mode*/

SELECT Region, SUM(Sales) AS TotalSales, SUM(Profit) AS TotalProfit FROM SALES
WHERE Ship_Mode = 'Standard Class'
GROUP BY Region;

/* 3. Write a query to find the average sales 
	and profit for each category and subcategory*/

SELECT 
		Category, Sub_Category,
		AVG(CONVERT(INT,Sales)) AS TotalSales, 
		AVG(CONVERT(INT,Profit)) AS TotaLProfit 
FROM SALES 
GROUP BY Category, Sub_Category
ORDER BY TotaLProfit DESC, TotalSales DESC;

/* 4. Write a query to find the top 3 products 
	with the highest total sales and profit.*/

SELECT 
		TOP(3) Product_ID,
		SUM(CONVERT(INT,Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit 
FROM SALES 
GROUP BY Product_ID
ORDER BY TotaLProfit DESC, TotalSales DESC;

/*----------------------------------------------------------------------------------------------------------*/
-- Windowfunctions

/* 1. Write a query to find the running total of sales for each order*/

SELECT 
    Order_ID, 
    TotalSales,
    SUM(TotalSales) 
		OVER(ORDER BY TotalSales ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal 
FROM 
	(SELECT 
        Order_ID, 
        SUM(CONVERT(INT, Sales)) AS TotalSales
    FROM SALES
    GROUP BY Order_ID) AS SalesSummary
ORDER BY TotalSales, RunningTotal;

/* 2. Write a query to find the average sales and profit for each region
	including a running total.*/

SELECT 
	Region,
	TotalSales,
	TotaLProfit,
	SUM(TotalSales) 
		OVER(ORDER BY Region ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SalesRT,
	SUM(TotaLProfit) 
		OVER(ORDER BY Region ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ProfitRT
FROM 
	(SELECT Region,
		SUM(CONVERT(INT, Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit  
	FROM SALES
	GROUP BY Region) AS Summary;

/* 3. Write a query to find the total sales and profit for each product
	category and sub category including a running total*/

SELECT 
	Category,Sub_Category,
	TotalSales,
	TotaLProfit,
	SUM(TotalSales) 
		OVER(ORDER BY Category,Sub_Category ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SalesRT,
	SUM(TotaLProfit) 
		OVER(ORDER BY Category,Sub_Category ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ProfitRT
FROM 
	(SELECT Category,Sub_Category,
		SUM(CONVERT(INT, Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit  
	FROM SALES
	GROUP BY Category,Sub_Category) AS Summary;

/*----------------------------------------------------------------------------------------------------------*/
--CommonTableExpressions(CTEs)

/* 1. Write a query to find the total sales and profit for each region using
	a CTEto calculate the running total*/

WITH SUMMARY AS 
	(SELECT Region,
		SUM(CONVERT(INT, Sales)) AS TotalSales, 
		SUM(CONVERT(INT,Profit)) AS TotaLProfit  
	FROM SALES
	GROUP BY Region)

SELECT Region,TotalSales,TotaLProfit,
		SUM(TotalSales) 
			OVER(ORDER BY Region ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SalesRT,
		SUM(TotaLProfit) 
			OVER(ORDER BY Region ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ProfitRT 
FROM SUMMARY;

/* 2. Write a query to find the top 3 customers with the highest total
	sales, using a CTE to calculate the ranking*/

WITH SUMMARY AS 
	(SELECT Customer_ID,Customer_Name, 
			SUM(Sales) AS TOTALSALES 
	FROM SALES 
	GROUP BY Customer_ID,Customer_Name )

SELECT TOP(3)*, RANK() OVER(ORDER BY TOTALSALES DESC) AS "RANK" 
FROM SUMMARY
ORDER BY TOTALSALES DESC;

/* 3. Write a query to find the average sales for each category and
	subcategory using a CTE to calculate the running average*/

WITH SUMMARY AS 
	(SELECT Category, Sub_Category, AVG(CONVERT(INT,Sales)) AS AVERAGE  
	 FROM SALES
	 GROUP BY Category, Sub_Category)

SELECT Category, Sub_Category, "AVERAGE" AS "AVG Sales",
		AVG("AVERAGE") 
			OVER(ORDER BY Category, Sub_Category ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningAVG
FROM SUMMARY;

/* 4. Write a query to find the total sales and profit for each customer
	using a CTE to calculate the running total*/

WITH SUMMARY AS 
	(SELECT Customer_ID, Customer_Name, SUM(Sales) AS TotalSales, SUM(Profit) AS TotalProfit 
	 FROM SALES
	 GROUP BY Customer_ID, Customer_Name)

SELECT Customer_ID, Customer_Name, TotalSales,TotalProfit,
		SUM(TotalSales) 
			OVER(ORDER BY Customer_ID, Customer_Name ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SalesRT,
		SUM(TotaLProfit) 
			OVER(ORDER BY Customer_ID, Customer_Name ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ProfitRT  
FROM SUMMARY;

/* 5. Write a query to find the total sales and profit for each region using
	a CTEto calculate the running total and including only orders
	within a specific year and month*/

WITH SUMMARY AS 
	(SELECT Region, 
		SUM(Sales) AS TotalSales, 
		SUM(Profit) AS TotalProfit 
	 FROM SALES
	 WHERE CONVERT(DATE,Order_Date) BETWEEN '1/1/2011' AND '1/31/2011'
	 GROUP BY Region)

SELECT Region,TotalSales,TotalProfit,
		SUM(TotalSales) 
			OVER(ORDER BY Region ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SalesRT,
		SUM(TotaLProfit) 
			OVER(ORDER BY Region ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ProfitRT  
FROM SUMMARY
ORDER BY Region;