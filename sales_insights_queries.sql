use OnlineRetail
select * from SalesTransactions

--Q1. What is the overall revenue trend month-over-month across the analysis period?
SELECT
FORMAT(InvoiceDate,'yyyy-MM') AS Month,
ROUND(SUM(Revenue),2) AS TotalRevenue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY FORMAT(InvoiceDate,'yyyy-MM')
ORDER BY Month;

--Q2. Which products generate the highest total revenue and highest quantity sold?

--Top Products by Revenue
SELECT TOP 10 Description,
ROUND(SUM(Revenue),2) AS TotalRevenue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY Description
ORDER BY TotalRevenue DESC;

--Top Products by Quantity Sold
SELECT TOP 10 Description,
SUM(Quantity) AS TotalQuantitySold
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY Description
ORDER BY TotalQuantitySold DESC;

---Q3. Which countries contribute the most revenue, and how dependent is the business on the UK market?
--Revenue by Country
SELECT Country,
ROUND(SUM(Revenue),2) AS TotalRevenue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY Country
ORDER BY TotalRevenue DESC;

--UK vs International Revenue
SELECT CASE
WHEN Country = 'United Kingdom'
THEN 'UK'
ELSE 'International'
END AS Market,
ROUND(SUM(Revenue),2) AS Revenue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY
CASE
WHEN Country = 'United Kingdom'
THEN 'UK'
ELSE 'International'
END;

---Q4. What is the customer repeat-purchase rate?

WITH CustomerOrders AS
(SELECT Customer_ID,
COUNT(DISTINCT Invoice) AS OrderCount
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY Customer_ID)
SELECT CAST(100.0 * SUM(CASE WHEN OrderCount > 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(10,2)) AS RepeatPurchaseRate
FROM CustomerOrders;


---Q5. What is the Average Order Value (AOV) and how has it changed over time?
SELECT FORMAT(InvoiceDate,'yyyy-MM') AS Month,
ROUND(SUM(Revenue) /COUNT(DISTINCT Invoice),2) AS AverageOrderValue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY FORMAT(InvoiceDate,'yyyy-MM')
ORDER BY Month;

---Q6. What share of total revenue comes from the top 20% of customers?
 WITH CustomerRevenue AS
(SELECT Customer_ID,
SUM(Revenue) AS Revenue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY Customer_ID),

RankedCustomers AS
(SELECT *,NTILE(5) OVER(ORDER BY Revenue DESC) AS RevenueGroup
FROM CustomerRevenue)

SELECT ROUND(100.0 * SUM(Revenue)/
(SELECT SUM(Revenue) FROM CustomerRevenue),2) AS RevenueContributionPercent
FROM RankedCustomers
WHERE RevenueGroup = 1;

---Q7. What actionable business recommendations can be derived from the sales and customer analysis?

--Top Countries

SELECT TOP 5 Country,
ROUND(SUM(Revenue),2) AS Revenue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY Country
ORDER BY Revenue DESC;

--Top Customers
SELECT TOP 10 Customer_ID,
ROUND(SUM(Revenue),2) AS Revenue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY Customer_ID
ORDER BY Revenue DESC;

--Top Products
SELECT TOP 10 Description,
ROUND(SUM(Revenue),2) AS Revenue
FROM SalesTransactions
WHERE IsCancellation = 0
GROUP BY Description
ORDER BY Revenue DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------