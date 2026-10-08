-- =============================================
-- Project: Food Delivery Database
-- File: database/02-constraints.sql
-- Description: Foreign Key constraints and Referential Integrity
-- =============================================

-- 1. Branches -> Restaurants
ALTER TABLE branches
ADD CONSTRAINT FK_branches_restaurants_restaurant_id
FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id);

-- 2. Menu Items -> Categories
ALTER TABLE menu_items
ADD CONSTRAINT FK_menu_items_categories_category_id
FOREIGN KEY (category_id) REFERENCES categories(category_id);

-- 3. Menu Items -> Restaurants
ALTER TABLE menu_items
ADD CONSTRAINT FK_menu_items_restaurants_restaurant_id
FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id);

-- 4. Branch Menu Items -> Branches & Menu Items (Junction Table)
ALTER TABLE branch_menu_items
ADD CONSTRAINT FK_branch_menu_items_branches_branch_id
FOREIGN KEY (branch_id) REFERENCES branches(branch_id);

ALTER TABLE branch_menu_items
ADD CONSTRAINT FK_branch_menu_items_menu_items_item_id
FOREIGN KEY (item_id) REFERENCES menu_items(item_id);

-- 5. Orders -> Customers & Branches
ALTER TABLE orders
ADD CONSTRAINT FK_orders_customers_customer_id
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT FK_orders_branches_branch_id
FOREIGN KEY (branch_id) REFERENCES branches(branch_id);

-- 6. Order Items -> Orders & Menu Items
ALTER TABLE order_items
ADD CONSTRAINT FK_order_items_orders_order_id
FOREIGN KEY (order_id) REFERENCES orders(order_id)
ON DELETE CASCADE; -- Safe for line items if an entire draft order is removed

ALTER TABLE order_items
ADD CONSTRAINT FK_order_items_menu_items_item_id
FOREIGN KEY (item_id) REFERENCES menu_items(item_id);

-- 7. Payments -> Orders (1:1 Relationship)
ALTER TABLE payments
ADD CONSTRAINT FK_payments_orders_order_id
FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- 8. Deliveries -> Orders & Riders
ALTER TABLE deliveries
ADD CONSTRAINT FK_deliveries_orders_order_id
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE deliveries
ADD CONSTRAINT FK_deliveries_riders_rider_id
FOREIGN KEY (rider_id) REFERENCES riders(rider_id);

-- 9. Reviews -> Customers & Orders
ALTER TABLE reviews
ADD CONSTRAINT FK_reviews_customers_customer_id
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE reviews
ADD CONSTRAINT FK_reviews_orders_order_id
FOREIGN KEY (order_id) REFERENCES orders(order_id);