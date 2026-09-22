WITH customer_ordered AS (
    SELECT 
        c.first_name + ' ' + c.last_name AS full_name,
        c.email,
        o.order_id,
        o.order_status,
        o.staff_id
    FROM sales.customers c
    INNER JOIN sales.orders o
        ON c.customer_id = o.customer_id
),

customer_ordered_product AS (
    SELECT
        co.full_name,
        co.email,
        co.order_id,
        co.order_status,
        co.staff_id,
        p.product_name
    FROM customer_ordered co
    INNER JOIN sales.order_items oi
        ON co.order_id = oi.order_id
    INNER JOIN production.products p
        ON oi.product_id = p.product_id
),

order_by_staff AS (
    SELECT 
        cop.full_name,
        cop.email,
        cop.order_id,
        cop.product_name,
        cop.order_status,
        s.first_name + ' ' + s.last_name AS staff_name,
        s.manager_id
    FROM customer_ordered_product cop
    INNER JOIN sales.staffs s
        ON cop.staff_id = s.staff_id
),

order_by_manager AS (
    SELECT 
        obs.full_name,
        obs.email,
        obs.order_id,
        obs.product_name,
        CASE
            WHEN obs.order_status = 1 THEN 'Initial Arrived'
            WHEN obs.order_status = 2 THEN 'Packing Done'
            WHEN obs.order_status = 3 THEN 'In Progress'
            WHEN obs.order_status = 4 THEN 'Shipped'
            ELSE 'Invalid'
        END AS order_status,
        obs.staff_name,
        m.first_name + ' ' + m.last_name AS manager_name
    FROM order_by_staff obs
    INNER JOIN sales.staffs m
        ON obs.manager_id = m.staff_id
)

SELECT *
FROM order_by_manager;