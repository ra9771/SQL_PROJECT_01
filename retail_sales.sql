-- SQL Retail Sales Analysis
USE project;

CREATE TABLE retail_sales (
transaction_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales; 

-- Data Cleaning

SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

SELECT * FROM retail_sales
WHERE
transaction_id IS NULL
OR
sale_date IS NUll
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- Delete 

SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE
transaction_id IS NULL
OR
sale_date IS NUll
OR
sale_time IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE ?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- HOW MANY UNNIQUE CUSTOMER WE HAVE ?
SELECT COUNT(distinct customer_id) AS total_sale FROM retail_sales;

SELECT distinct category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE 
sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT * FROM retail_sales
WHERE
category = 'Clothing'
AND 
quantity >= 10
AND
sale_date =11-2022;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
category,
SUM(total_sale) AS net_sale,
COUNT(*) as total_order
FROM retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
ROUND(AVG(age)) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE 
total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
category,
gender,
COUNT(*) as total_transaction
FROM retail_sales
GROUP BY
category,
gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sale_rank
    FROM retail_sales
    GROUP BY year, month
) AS ranked_sales
WHERE sale_rank = 1;

-- ORDER BY 1, 3 desc

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
category,
COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- END OF PROJECT-----------

-- Conclusion of Retail Sales Analysis Project
-- The Retail Sales Analysis project aimed to extract actionable insights from the retail_sales dataset using structured SQL queries. Through a comprehensive process of data
-- cleaning, exploration, and business-focused analysis, we were able to uncover meaningful trends and patterns in customer behavior, product performance, and sales
-- performance across time.

-- KEY POINTS:
-- This project demonstrates the power of SQL for business intelligence by turning raw transactional data into insightful reports. The findings can help:

-- Improve inventory planning based on high-demand categories and peak sales months.

-- Enhance customer targeting using demographic and behavioral patterns.

-- Optimize operations by aligning staffing with busy sales shifts.
