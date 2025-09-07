CREATE  database Coffee_Shop


Select * from Coffee_Shop

--1-What is the total revenue?
Select 
	ROUND(SUM(transaction_qty * unit_price),2) AS Revenue
FROM Coffee_Shop
--2-What is the total Profit?
Select 
	ROUND(SUM(transaction_qty * unit_price),2) * 0.4 AS Revenue
FROM Coffee_Shop
--2-How do sales change daily or monthly?
Select 
	FORMAT(transaction_date,'MMMM') AS Monthly,
	ROUND(SUM(transaction_qty * unit_price),2) AS Revenue			
FROM Coffee_Shop
GROUP BY FORMAT(transaction_date,'MMMM')
ORDER BY ROUND(SUM(transaction_qty * unit_price),2)
--3-What are the peak sales times (morning, noon, night)?
SELECT
    CASE 
        WHEN DATEPART(HOUR, transaction_TIME) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, transaction_TIME) BETWEEN 12 AND 17 THEN 'Noon'
        WHEN DATEPART(HOUR, transaction_TIME) BETWEEN 18 AND 23 THEN 'Night'
        ELSE 'Late Night'
    END AS Period,
    ROUND(SUM(transaction_qty * unit_price),2) AS Revenue
FROM Coffee_Shop
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, transaction_TIME) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, transaction_TIME) BETWEEN 12 AND 17 THEN 'Noon'
        WHEN DATEPART(HOUR, transaction_TIME) BETWEEN 18 AND 23 THEN 'Night'
        ELSE 'Late Night'
    END

--4-What is the average order size?
SELECT 
    ROUND(AVG(Revenue), 2) AS Avg_Revenue
FROM (
    SELECT SUM(transaction_qty * unit_price) AS Revenue
    FROM Coffee_Shop
    GROUP BY transaction_id
) t
----************ٍٍTHE SAME RESULT 
Select 
    ROUND(avg(transaction_qty * unit_price),2)  AS AVG_Selling
FROM Coffee_Shop
--------------------------------------------PRODUCTS---------------------------------------------------------
--What are the best selling product_detail in quantity?
Select 
     product_detail,
    ROUND(SUM(transaction_qty * unit_price),2) AS Revenue
FROM Coffee_Shop
GROUP BY product_detail
ORDER BY ROUND(SUM(transaction_qty * unit_price),2) DESC
--What are the most profitable product_category?
Select 
     product_category,
    ROUND(SUM(transaction_qty * unit_price),2) AS Revenue
FROM Coffee_Shop
GROUP BY product_category
ORDER BY ROUND(SUM(transaction_qty * unit_price),2) DESC
--Are there products that are frequently purchased together?
Select 
    transaction_id,
    product_detail,
    COUNT(product_detail) AS FREQ_pro 
FROM Coffee_Shop 
GROUP BY transaction_id,product_detail
ORDER BY transaction_id
-----------------------------BRANCH--------------------------------------
--Which branch generates the highest revenue?
Select 
    store_location,
    ROUND(SUM(transaction_qty * unit_price),2) AS REVUNVE
FROM Coffee_Shop
GROUP BY store_location
ORDER BY ROUND(SUM(transaction_qty * unit_price),2)
--Which branch has the most orders?
Select 
    store_location,
    SUM(transaction_qty) AS total_quantity
FROM Coffee_Shop
GROUP BY store_location
ORDER BY SUM(transaction_qty)
--What is the average order value in each branch?
WITH ORDERVALUE AS(
Select   
    store_location,
    SUM(transaction_qty * unit_price) AS order_value
    FROM Coffee_Shop
    GROUP BY  store_location
)
SELECT 
    store_location,
    AVG(order_value) AS avg_order_value
FROM ORDERVALUE
GROUP BY store_location
ORDER BY avg_order_value DESC;
--Is there a difference in the best-selling products from one branch to another?
Select 
    store_location,
    product_category,
    COUNT(product_category) As count_products
FROM Coffee_Shop
GROUP BY store_location,product_category
ORDER BY store_location
------------------------------------------------Customers and behavior---------------------------------------
--What time of day do most sales happen?
SELECT
    DATEPART(HOUR, transaction_time) AS HourOfDay,
    COUNT(transaction_id) AS total_orders,
    SUM(transaction_qty) AS total_quantity,
    ROUND(SUM(transaction_qty * unit_price), 2) AS Revenue
FROM Coffee_Shop
GROUP BY DATEPART(HOUR, transaction_time)
ORDER BY Revenue DESC
--What is the average number of products in one order?
Select
    product_category,
   SUM(transaction_qty) * 1.0 / COUNT(DISTINCT transaction_id) AS avg_products_per_order
FROM Coffee_Shop
GROUP BY product_category
--Are there recurring purchase patterns (e.g., coffee with a croissant)?
SELECT 
    A.product_detail AS Product_A,
    B.product_detail AS Product_B,
    COUNT(*) AS Times_Bought_Together
FROM Coffee_Shop A
JOIN Coffee_Shop B
    ON A.transaction_id = B.transaction_id
   AND A.product_detail < B.product_detail
GROUP BY 
    A.product_detail, 
    B.product_detail
ORDER BY 
    Times_Bought_Together DESC;
--Are sales different on weekdays and weekends?
SELECT
    DATENAME(WEEKDAY, transaction_date) AS DayName,
    COUNT(transaction_id) AS Total_Orders,
    SUM(transaction_qty) AS Total_Quantity,
    ROUND(SUM(transaction_qty * unit_price), 2) AS Revenue
FROM Coffee_Shop
GROUP BY DATENAME(WEEKDAY, transaction_date)
ORDER BY Revenue DESC    

