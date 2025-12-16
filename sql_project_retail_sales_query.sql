
CREATE DATABASE sql_project_retail_sales;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(10),
    age INT,
	category VARCHAR(15),
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10

--How many rows in total?
SELECT COUNT(*) FROM retail_sales;

--Data Cleaning

--Check null value
SELECT * FROM retail_sales
WHERE 
     transactions_id IS NULL
     OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

--Delete rows which contain null value
DELETE FROM retail_sales
WHERE 
     transactions_id IS NULL
     OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_num_sales FROM retail_sales;

-- How many customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_num_customers FROM retail_sales;

-- How many categories do we have?
SELECT COUNT(DISTINCT category) AS total_num_categories FROM retail_sales;

-- What are the categories?
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Findings

-- 1. Retrieve all columns for sales made on speific date eg.'2022-11-05:
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
     AND quantiy >= 4
	 AND TO_CHAR(sale_date, 'YYYY-MM')='2022-11';

-- 3. Calculate the total sales (total_sale) of each category:
SELECT 
    category,
	SUM(total_sale) AS total_sales,
	COUNT(*) AS total_num_orders
FROM retail_sales
GROUP BY category;

-- 4. Find the average age of customers who purchased items from the 'Beauty' category:
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Find the total number of transactions made by each gender in each category.:
SELECT 
    category,
	gender,
	COUNT(*) AS num_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY 1;

-- 7. Calculate the total sale for each month. Find out best selling month in each year:
SELECT
    year,
	month,
	total_sale
FROM
(
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
	    EXTRACT(MONTH FROM sale_date) AS month,
	    SUM(total_sale) AS total_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY SUM(total_sale) DESC)
    FROM retail_sales
	GROUP BY 1,2
) 
WHERE rank = 1;

-- 8. Find the top 5 customers based on the highest total sales:
SELECT 
    customer_id,
	SUM(total_sale)
FROM
   retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- 9. Find the number of unique customers who purchased items from each category:
SELECT 
    category,
	COUNT(DISTINCT customer_id)	AS cnt_unique_cs
FROM retail_sales
GROUP BY 1;

-- 10. Check the number of orders of each shift (Example Morning between 4h & 12h, Afternoon Between 12h & 18h, Evening >18):
WITH hourly_sale AS (
SELECT *,
    CASE
	    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 4 AND 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 18 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;


