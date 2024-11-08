
USE [SQL WITH TDI];

/*Which date(s) had the highest total sales and
which product(s) contributed to those sales?*/

WITH DATESALES AS 
	(SELECT 
		Order_Date,
		SUM(Sales) AS TOTALSALES
	FROM SALES
	GROUP BY Order_Date)

SELECT 
	S.Order_Date,
	S.Product_ID,
	SUM(S.SALES) AS TOTALSALES
FROM SALES AS S 
WHERE S.Order_Date IN (SELECT Order_Date FROM DATESALES WHERE TOTALSALES = (SELECT MAX(TOTALSALES) FROM DATESALES))
GROUP BY S.Order_Date , S.Product_ID
ORDER BY S.Order_Date;

/*Which product(s) had the highest average unit
price among all products sold*/

WITH AVG_UNIT_PRICE AS 
	(SELECT Product_ID, AVG(Sales / Quantity) AS AVG_PRICE FROM SALES
	GROUP BY Product_ID)

SELECT 
    Product_ID, 
    Avg_Price AS Max_Avg_Price
FROM Avg_Unit_Price
WHERE Avg_Price = (SELECT MAX(Avg_Price) FROM Avg_Unit_Price);

/*What were the total sales for each product on dates where the
 quantity sold exceeded the average quantity sold for that product?*/

SELECT 
	Order_Date, 
	Product_ID, 
	SUM(CONVERT(INT,Sales)) AS TOTALSALES 
FROM SALES
WHERE CONVERT(INT,Quantity) > (SELECT AVG(CONVERT(INT,Quantity)) FROM SALES)
GROUP BY Order_Date, Product_ID
ORDER BY Order_Date;

/*What were the top 3 dates with the highest total sales, and which
 product(s) contributed to those sales on each date?*/

WITH DATESALES AS 
	(SELECT 
		TOP (3) Order_Date,
		SUM(Sales) AS TOTALSALES
	FROM SALES
	GROUP BY Order_Date
	ORDER BY TOTALSALES DESC)

SELECT S.Order_Date, S.Product_ID , SUM (Sales) AS TOTALSALES FROM SALES AS S
WHERE S.Order_Date IN (SELECT Order_Date FROM DATESALES)
GROUP BY S.Order_Date, S.Product_ID
ORDER BY S.Order_Date;

/*What percentage of the total sales on April 15th 2013,
 did each product contribute?*/

SELECT Product_ID, (SUM(Sales)/ (SELECT 
		SUM(CONVERT(INT,Sales)) AS TOTALSALES
		FROM SALES
		WHERE CONVERT(DATE,Order_Date) = '4/15/2013')) AS "% OF TOTAL SALES" 
FROM SALES 
WHERE CONVERT(DATE,Order_Date) = '4/15/2013'
GROUP BY Product_ID;

/*Onwhich date(s) did Technology products total sales exceed the combined
 total sales of all other product CATEGORIES?*/

WITH 
	Technology_products AS 
	(SELECT Order_Date,SUM(Sales) AS TOTALSALES FROM SALES WHERE Category = 'Technology' GROUP BY Order_Date),
	NON_Technology AS
	(SELECT Order_Date,SUM(Sales) AS TOTALSALES FROM SALES WHERE Category <> 'Technology' GROUP BY Order_Date)
SELECT 
	Technology_products.Order_Date,
	Technology_products.TOTALSALES AS TechnologySales,
	NON_Technology.TOTALSALES AS NonTechnologySales
FROM Technology_products JOIN NON_Technology 
	ON Technology_products.Order_Date = NON_Technology.Order_Date
WHERE 
	Technology_products.TOTALSALES > NON_Technology.TOTALSALES
ORDER BY Technology_products.Order_Date;

/* What were the cumulative total sales for each product over the entire
 period covered by the dataset, ordered by date?*/

WITH T_SALES AS 
	(SELECT Order_Date ,Product_ID ,ROUND(CONVERT(INT,SUM(Sales)),0) AS DALYTOTALSALES FROM SALES GROUP BY Order_Date,Product_ID)

SELECT 
	Order_Date,
	Product_ID,
	DALYTOTALSALES, 
	SUM(DALYTOTALSALES) OVER() AS TOTALSALES,
	(SUM(DALYTOTALSALES) OVER() - DALYTOTALSALES) AS "DIFFERENCE" 
FROM T_SALES 
ORDER BY Order_Date;

/* Which product(s) had the highest total sales 
over any consecutive 3 day period?*/

WITH DailySales AS 
	(SELECT 
        Order_Date,
        Product_ID,
        SUM(Sales) AS Daily_Total_Sales
    FROM SALES
    GROUP BY Order_Date, Product_ID),
ThreeDaySales AS 
	(SELECT 
        DS1.Product_ID,
        DS1.Order_Date AS Start_Date,
        DS1.Daily_Total_Sales 
            + COALESCE(DS2.Daily_Total_Sales, 0) 
            + COALESCE(DS3.Daily_Total_Sales, 0) AS Three_Day_Total_Sales
    FROM DailySales DS1
    LEFT JOIN DailySales DS2 ON DS1.Product_ID = DS2.Product_ID 
                            AND DS2.Order_Date = DATEADD(DAY, 1, DS1.Order_Date)
    LEFT JOIN DailySales DS3 ON DS1.Product_ID = DS3.Product_ID 
                            AND DS3.Order_Date = DATEADD(DAY, 2, DS1.Order_Date))
			--SELF JOINS
SELECT 
    Product_ID,
    Start_Date,
    Three_Day_Total_Sales
FROM ThreeDaySales
WHERE Three_Day_Total_Sales = (SELECT MAX(Three_Day_Total_Sales) FROM ThreeDaySales);
