# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `SQL_PROJECT_1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL_PROJECT_1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE SQL_PROJECT_1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Find the total revenue generated for each product category?**:
```sql
SELECT category, SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;
```

2. **Which age group contributes the most to total sales? (Group by decades: 10s, 20s, 30s, etc.)?**:
```sql
SELECT (age/10)*10 AS age_group, SUM(total_sale) AS total_revenue
FROM retail_sales
WHERE age IS NOT NULL
GROUP BY (age/10)*10
ORDER BY total_revenue DESC;
```

3. **Find the top 5 customers who spent the most overall?**:
```sql
SELECT customer_id, SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

4. **Calculate the profit margin % for each transaction?**:
 (Profit = total\_sale - cogs, Margin% = Profit / total\_sale \* 100)
```sql
SELECT transactions_id,
       total_sale,
       cogs,
       (total_sale - cogs) AS profit,
       ROUND(((total_sale - cogs)/total_sale)*100,2) AS margin_percent
FROM retail_sales
WHERE total_sale > 0;
```

5. **Find the day of the week with the highest average sales?**:
```sql
SELECT TO_CHAR(sale_date, 'Day') AS day_of_week,
       AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY TO_CHAR(sale_date, 'Day')
ORDER BY avg_sales DESC;
```

6. **Determine sales trend: compare total monthly sales in 2022?**:
```sql
SELECT EXTRACT(MONTH FROM sale_date) AS month,
       SUM(total_sale) AS monthly_sales
FROM retail_sales
WHERE EXTRACT(YEAR FROM sale_date) = 2022
GROUP BY EXTRACT(MONTH FROM sale_date)
ORDER BY month;
```

7. **Identify which gender spends more on average per transaction?**:
```sql
sql
SELECT gender, ROUND(AVG(total_sale),2) AS avg_transaction_value
FROM retail_sales
GROUP BY gender;
```

8. **Find the top-selling category in terms of quantity for each month?**:
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

9. **Determine the customer with the highest lifetime value (total spent)?**:
```sql
SELECT customer_id, SUM(total_sale) AS lifetime_value
FROM retail_sales
GROUP BY customer_id
ORDER BY lifetime_value DESC
LIMIT 1;
```

10. **Find transactions where the profit margin is below 20%.**:
```sql
SELECT transactions_id, total_sale, cogs,
       (total_sale - cogs) AS profit,
       ROUND(((total_sale - cogs)/total_sale)*100,2) AS margin_percent
FROM retail_sales
WHERE ((total_sale - cogs)/total_sale)*100 < 20;
```

## Findings

- **Customer Demographics**: The dataset spans customers of different ages and genders, with transactions spread across multiple product categories such as Clothing and Beauty. Grouping by age brackets shows that middle-aged customers (30–50 years) contribute the most to sales.
- **Revenue Drivers**: Clothing consistently emerges as the top revenue-generating category, while Beauty has frequent high-value transactions.
- **Profit Margins**: Some transactions generate very low margins (<20%), suggesting discount-driven or low-profit sales.
- **High-Value Customers**: A small group of customers account for the largest share of revenue, making them potential targets for loyalty programs.

## Reports

- **Sales by Category**: Identifies which product categories contribute most to overall sales and which ones dominate in different months.
- **Monthly Trend Analysis**: Highlights variations in total revenue throughout 2022, useful for spotting seasonal peaks and planning inventory.
- **Customer Reports**: Includes top 5 highest-spending customers, customer lifetime value (LTV) analysis, and spending differences by gender.
- **Profitability Reports**:Shows which transactions and categories yield higher profit margins and flags those with low profitability.

## Conclusion

This project demonstrates how SQL can be used to uncover valuable insights from retail sales data. By analyzing revenue drivers, customer demographics, and profit margins, businesses can make better decisions about promotions, inventory planning, and customer engagement strategies. The queries in this project go beyond simple reporting to address practical business questions, making it a solid starting point for real-world SQL analytics.

## How to Use
1. Create the table using the schema provided.
2. Import the dataset (CSV).
3. Run queries from `retail_sales_queries.sql`.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## 📂 Repository Structure
```
SQL-Project-Retail-Sales-Analysis/
│
├── data/
│   └── retail_sales.csv              # dataset (or link in README if too large)
│
├── sql/
│   ├── 01_sales_summary.sql          # category/overall revenue queries
│   ├── 02_customer_insights.sql      # top customers, LTV, demographics
│   ├── 03_profitability.sql          # margins, low-profit transactions
│   ├── 04_trends.sql                 # monthly/weekly trends, seasonal
│   └── all_queries.sql               # combined file
│
├── notebooks/
│   └── data_cleaning.ipynb           # optional cleaning, validation checks
│
├── reports/
│   ├── findings.md                   # key insights, tables, explanations
│   └── visuals/                      # charts/plots if you want to add later
│
├── README.md                         # main documentation
├── LICENSE                           # (MIT license for open use)
└── .gitignore                        # ignore temp files
```



This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!


Thank you for your support, and I look forward to connecting with you!
