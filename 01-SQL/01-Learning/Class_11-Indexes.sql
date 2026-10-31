/*========================================================================================================================
                            INDEXES
========================================================================================================================*/
-- by default non clustered banta hai, clustered banane k lie explicitly define krna padta hai
CREATE INDEX CLUSTERED idx_orders ON sales.index_orders (col_name);



SELECT
    s.store_name,
    YEAR(o.order_date) AS order_year,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON oi.order_id = o.order_id
INNER JOIN sales.stores AS s
    ON s.store_id = o.store_id
GROUP BY s.store_name, YEAR(o.order_date)
ORDER BY s.store_name, order_year;

-- ROLLUP, CUBE, GROUPING SETS
-- kafi bekaar class thi aj ki