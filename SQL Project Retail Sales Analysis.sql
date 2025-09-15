-- SQL Retail Sales Analysis - P1
CREATE DATABASE SQL_PROJECT_1;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10


SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
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
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
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
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales



SELECT DISTINCT category FROM retail_sales


```


--- 1. Find the total revenue generated for each product category.

```
SELECT category, SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;
```


---2. Which age group contributes the most to total sales? (Group by decades: 10s, 20s, 30s, etc.)

```
SELECT (age/10)*10 AS age_group, SUM(total_sale) AS total_revenue
FROM retail_sales
WHERE age IS NOT NULL
GROUP BY (age/10)*10
ORDER BY total_revenue DESC;
```

---3. Find the top 5 customers who spent the most overall.

```
SELECT customer_id, SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

---4. Calculate the profit margin % for each transaction.

(Profit = total\_sale - cogs, Margin% = Profit / total\_sale \* 100)

```
SELECT transactions_id,
       total_sale,
       cogs,
       (total_sale - cogs) AS profit,
       ROUND(((total_sale - cogs)/total_sale)*100,2) AS margin_percent
FROM retail_sales
WHERE total_sale > 0;
```

---5. Find the day of the week with the highest average sales.

```
SELECT TO_CHAR(sale_date, 'Day') AS day_of_week,
       AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY TO_CHAR(sale_date, 'Day')
ORDER BY avg_sales DESC;
```

---6. Determine sales trend: compare total monthly sales in 2022.

```
SELECT EXTRACT(MONTH FROM sale_date) AS month,
       SUM(total_sale) AS monthly_sales
FROM retail_sales
WHERE EXTRACT(YEAR FROM sale_date) = 2022
GROUP BY EXTRACT(MONTH FROM sale_date)
ORDER BY month;
```

---7. Identify which gender spends more on average per transaction.

```sql
SELECT gender, ROUND(AVG(total_sale),2) AS avg_transaction_value
FROM retail_sales
GROUP BY gender;
```

---8. Find the top-selling category in terms of quantity for each month.

```sql
SELECT month, category, total_quantity
FROM (
    SELECT EXTRACT(MONTH FROM sale_date) AS month,
           category,
           SUM(quantiy) AS total_quantity,
           RANK() OVER (PARTITION BY EXTRACT(MONTH FROM sale_date)
                        ORDER BY SUM(quantiy) DESC) AS rnk
    FROM retail_sales
    GROUP BY EXTRACT(MONTH FROM sale_date), category
) t
WHERE rnk = 1;
```

---9. Determine the customer with the highest lifetime value (total spent).

```sql
SELECT customer_id, SUM(total_sale) AS lifetime_value
FROM retail_sales
GROUP BY customer_id
ORDER BY lifetime_value DESC
LIMIT 1;
```

--- 10. Find transactions where the profit margin is below 20%.

```
SELECT transactions_id, total_sale, cogs,
       (total_sale - cogs) AS profit,
       ROUND(((total_sale - cogs)/total_sale)*100,2) AS margin_percent
FROM retail_sales
WHERE ((total_sale - cogs)/total_sale)*100 < 20;

```
