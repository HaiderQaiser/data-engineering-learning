-- ---------------------------------------------
-- SECTION 1: TOP MENU ITEMS BY CATEGORY
-- Business Question: Top-selling menu items ranked within each category (Delivered Orders Only)
-- ---------------------------------------------
SELECT
    c.category_id,
    c.category_name,
    mi.item_id,
    mi.item_name,
    SUM((oi.quantity * oi.price) - oi.discount) AS revenue,
    SUM(oi.quantity) AS quantity_sold,
    DENSE_RANK() OVER(
        PARTITION BY c.category_id
        ORDER BY SUM((oi.quantity * oi.price) - oi.discount) DESC
    ) AS rank_no
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN menu_items mi
    ON oi.item_id = mi.item_id
JOIN categories c
    ON mi.category_id = c.category_id
WHERE o.order_status = 'Delivered'
GROUP BY 
    c.category_id,
    c.category_name,
    mi.item_id,
    mi.item_name
ORDER BY 
    c.category_id ASC, 
    rank_no ASC;
-- ---------------------------------------------
-- SECTION 2: CATEGORY REVENUE & MARKET SHARE
-- Business Question: Revenue, Quantity Sold, and Percentage Market Share by Food Category
-- ---------------------------------------------
WITH RevenueSummary AS (
    SELECT
        c.category_id,
        c.category_name,
        SUM((oi.quantity * oi.price) - oi.discount) AS category_revenue,
        SUM(oi.quantity) AS total_quantity_sold,
        SUM(SUM((oi.quantity * oi.price) - oi.discount)) OVER() AS platform_total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN menu_items mi
        ON oi.item_id = mi.item_id
    JOIN categories c
        ON mi.category_id = c.category_id
    WHERE o.order_status = 'Delivered'
    GROUP BY 
        c.category_id,
        c.category_name
)
SELECT
    category_id,
    category_name,
    category_revenue,
    total_quantity_sold,
    CAST(
        (category_revenue * 100.0 / NULLIF(platform_total_revenue, 0)) 
        AS DECIMAL(5,2)
    ) AS percentage_share
FROM RevenueSummary
ORDER BY 
    category_revenue DESC;