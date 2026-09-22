-- CHAPTER 07 - WINDOW FUNCTIONS
function_name() OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression]
    [frame_specification]
)
-- PARTITION BY AND ROW_NUMBER()
SELECT 
    ROW_NUMBER() OVER(
        PARTITION BY city
        ORDER BY first_name 
    ) AS RN,
    first_name,
    last_name, 
    city
FROM sales.customers;

-- RANK AND DENSE RANK
SELECT 
    product_name,
    list_price,
    RANK() OVER (
        ORDER BY list_price) AS ranking,
    DENSE_RANK() OVER(
        ORDER BY list_price) AS dense_ranking
FROM production.products;

-- USING WITH
WITH cte_ranking AS(
SELECT
    product_name,
    list_price,
    category_id,
    RANK() OVER(
        PARTITION BY category_id
        ORDER BY list_price
    ) AS ranking
FROM production.products)
SELECT * FROM cte_ranking;

-- NTILE()
-- HUMARE RECORDS KO N HISSON MN BREAK KRDEGA AUR PHIR USKE HISAAB SE RESULT DEGA
SELECT
    product_name,
    list_price,
    NTILE(4) OVER (ORDER BY list_price) AS price_quartile
FROM production.products
ORDER BY list_price;
-- ANOTHER EXAMPLE
SELECT 
    product_name,
    list_price,
    NTILE(10) OVER (
        ORDER BY list_price DESC
    ) AS price_bucket
FROM production.products;

-- LAG() AND LEAD()

SELECT
    customer_id,
    order_date,
    LAG(order_date,1) OVER(
        PARTITION BY customer_id
        ORDER BY order_date) AS previous_order,
    -- prev_difference
  -- USE DATEDIFF(DAY, col_name, col_name)
    LEAD(order_date,1) OVER(
        PARTITION BY customer_id
        ORDER BY order_date) next_order
FROM sales.orders;

-- FIRST_VALUE() AND LAST_VALUE()
SELECT DISTINCT
    category_id,
    FIRST_VALUE(product_name) OVER(
        PARTITION BY category_id
        ORDER BY list_price
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS cheapest_product,
    LAST_VALUE(product_name) OVER(
        PARTITION BY category_id
        ORDER BY list_price
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS expensive_product
FROM production.products;
-- SAME CODE BUT IN EASY WAY
SELECT DISTINCT
    category_id,
    FIRST_VALUE(product_name) OVER(
        PARTITION BY category_id 
        ORDER BY list_price ASC
    ) AS cheapest_product,
    
    FIRST_VALUE(product_name) OVER(
        PARTITION BY category_id 
        ORDER BY list_price DESC
    ) AS expensive_product
FROM production.products;

-- RUNNING TOTAL (pehle din ka total then pehle + second day ka total then 1st + 2nd + 3rd day ka total and so on)
-- QUERY FROM BOOK 7.7 
SELECT
    oi.order_id,
    o.order_date,
    oi.list_price,
    SUM(oi.list_price) OVER (
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
    
FROM sales.order_items oi
INNER JOIN sales.orders o
    ON oi.order_id = o.order_id
ORDER BY order_date;

-- CHAPTER 09 - DATA MODIFICATION AND SCHEMA DESIGN
--                         ◇◇◇ DML ---> DATA MANIPULATION LANGUAGES ◇◇◇
-- INSERT INTO CLAUSE
INSERT INTO production.categories
(category_name)
VALUES 
('Electric Scooters')
 
--  DELETE CLAUSE
DELETE FROM production.categories 
WHERE category_id = 8

-- UPDATE CLAUSE
UPDATE production.categories
SET col_name = 'value' , col_name = 'value'
WHERE condition;




SELECT * FROM production.categories