-- Customers who placed at least one order in 2017
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
      AND YEAR(o.order_date) = 2017
);
select * from sales.customers;
select * from sales.orders
select  1 from sales.orders

-- Products whose list price >= the average price of ANY brand
SELECT
    product_id,
    brand_id,
    product_name,
    list_price
FROM production.products
WHERE list_price >= ANY (
    SELECT AVG(list_price)
    FROM production.products
    GROUP BY brand_id);
  -- summary:
  -- multiple AND --> ALL
  -- multiple OR --> ANY

select * from production.products

-- CROSS APPLY
SELECT *
FROM production.categories o
--where categor_id = 7
CROSS APPLY(
    SELECT TOP 2 * 
    FROM production.products i
    WHERE i.category_id = o.category_id
    order by list_price DESC
) p;

-- OUTER APPLY (left join)

---
-- Products prices above the avg for strider and Trek brands
SELECT *
FROM produciton.products p
WHERE list_price >
(
SELECT AVG(p.list_price)
FROM production.products p
WHERE 
    p.brand_id = b.brand_id
    AND brand_name IN  ('Strider', 'Trek')
    )
    GROUP  BY p.brand_id
);
-----------------
SELECT *
FROM production.products
WHERE list_price >
ALL(
    SELECT AVG(p.list_price)
    FROM production.products p
    WHERE EXISTS (
        SELECT 1
        FROM production.brands b
        WHERE
            p.brand_id = b.brand_id
            AND brand_name IN ('Strider','Trek')
            )
    GROUP BY p.brand_id
);

-- NESTED SUBQUERIES

---

-- CTEs  (Common Expression Tables)
WITH NY_CA_CUSTOMERS AS (
