-- =============================================
-- Project: Food Delivery Database
-- File: database/03-seed-data.sql
-- Description: Sample data insertion script
-- =============================================

-- ---------------------------------------------
-- 1. SEED DATA FOR: categories
-- ---------------------------------------------
INSERT INTO categories (category_name) 
VALUES 
    ('Fast Food'),
    ('Desi / Local'),
    ('Beverages'),
    ('Desserts'),
    ('Chinese'); 

-- ---------------------------------------------
-- 2. SEED DATA FOR: customers
-- ---------------------------------------------
INSERT INTO customers (first_name, last_name, phone, email, city, state)
VALUES 
    ('Haider', 'Qaiser', '03001234567', 'haider@example.com', 'Karachi', 'Sindh'),
    ('Muzayyan', 'Khan', '03019876543', 'muzayyan@example.com', 'Karachi', 'Sindh'),
    ('Ali', 'Raza', '03215554433', 'ali.raza@example.com', 'Lahore', 'Punjab'),
    ('Sara', 'Ahmed', '03331112223', 'sara.ahmed@example.com', 'Islamabad', 'ICT'),
    ('Hamza', 'Siddiqui', '03459998877', 'hamza.s@example.com', 'Karachi', 'Sindh');

-- ---------------------------------------------
-- 3. SEED DATA FOR: restaurants
-- ---------------------------------------------
INSERT INTO restaurants (restaurant_name, phone, email, city, state)
VALUES 
    ('KFC', '021111532532', 'contact@kfc.pk', 'Karachi', 'Sindh'),
    ('Student Biryani', '021111111778', 'info@studentbiryani.com', 'Karachi', 'Sindh'),
    ('Kababjees', '021111111522', 'support@kababjees.com', 'Karachi', 'Sindh');

-- ---------------------------------------------
-- 4. SEED DATA FOR: riders
-- ---------------------------------------------
INSERT INTO riders (first_name, last_name, phone, email, address, vehicle_no, vehicle_type)
VALUES 
    ('Tariq', 'Mahmood', '03009991122', 'tariq.rider@example.com', 'Gulshan-e-Iqbal, Karachi', 'KHI-8821', 'Motorcycle'),
    ('Usman', 'Ghani', '03124445566', 'usman.g@example.com', 'DHA Phase 2, Karachi', 'KHI-5543', 'Motorcycle'),
    ('Kamran', 'Akmal', '03337778899', 'kamran.a@example.com', 'FB Area, Karachi', 'KHI-1209', 'Motorcycle');

-- ---------------------------------------------
-- 5. SEED DATA FOR: branches
-- (Referencing: restaurants -> 1: KFC, 2: Student Biryani, 3: Kababjees)
-- ---------------------------------------------
INSERT INTO branches (branch_name, restaurant_id, phone, city, state)
VALUES 
    ('KFC - Gulshan-e-Iqbal', 1, '02134991122', 'Karachi', 'Sindh'),
    ('KFC - DHA Phase 5', 1, '02135882233', 'Karachi', 'Sindh'),
    ('Student Biryani - Saddar', 2, '02132221100', 'Karachi', 'Sindh'),
    ('Student Biryani - Johar', 2, '02134611100', 'Karachi', 'Sindh'),
    ('Kababjees - Do Darya', 3, '02135234411', 'Karachi', 'Sindh');

-- ---------------------------------------------
-- 6. SEED DATA FOR: menu_items
-- (Referencing: categories -> 1: Fast Food, 2: Desi, 3: Beverages, 4: Desserts, 5: Chinese)
-- (Referencing: restaurants -> 1: KFC, 2: Student Biryani, 3: Kababjees)
-- ---------------------------------------------
INSERT INTO menu_items (item_name, category_id, restaurant_id, price)
VALUES 
    ('Zinger Burger', 1, 1, 550.00),
    ('Mighty Zinger', 1, 1, 850.00),
    ('Hot Wings (10 Pcs)', 1, 1, 650.00),
    ('Chicken Biryani', 2, 2, 380.00),
    ('Beef Biryani', 2, 2, 450.00),
    ('Chicken Karahi (Full)', 2, 3, 1800.00),
    ('Reshmi Kabab (4 Pcs)', 2, 3, 850.00),
    ('Pepsi 1.5L', 3, 1, 180.00),
    ('Lassi (Sweet)', 3, 2, 150.00),
    ('Gulab Jamun (2 Pcs)', 4, 3, 220.00);

-- ---------------------------------------------
-- 7. SEED DATA FOR: branch_menu_items
-- (Mapping Menu Items to Specific Branches)
-- ---------------------------------------------
INSERT INTO branch_menu_items (branch_id, item_id)
VALUES 
    -- KFC Gulshan (branch_id: 1)
    (1, 1), (1, 2), (1, 3), (1, 8),
    -- KFC DHA (branch_id: 2)
    (2, 1), (2, 2), (2, 8),
    -- Student Biryani Saddar (branch_id: 3)
    (3, 4), (3, 5), (3, 9),
    -- Student Biryani Johar (branch_id: 4)
    (4, 4), (4, 9),
    -- Kababjees Do Darya (branch_id: 5)
    (5, 6), (5, 7), (5, 8), (5, 10);

-- ---------------------------------------------
-- 8. SEED DATA FOR: orders
-- ---------------------------------------------
INSERT INTO orders (customer_id, branch_id, order_date, required_date, order_status, address)
VALUES 
    -- Order 1 (Haider at KFC Gulshan - Delivered)
    (1, 1, '2026-09-01 19:30:00', '2026-09-01 20:15:00', 'Delivered', 'Flat 4B, Block 13D, Gulshan-e-Iqbal, Karachi'),
    -- Order 2 (Muzayyan at Student Biryani Saddar - Delivered)
    (2, 3, '2026-09-02 13:15:00', '2026-09-02 14:00:00', 'Delivered', 'House 12, Line Area, Saddar, Karachi'),
    -- Order 3 (Ali at KFC DHA - Delivered)
    (3, 2, '2026-09-05 21:00:00', '2026-09-05 21:45:00', 'Delivered', 'Street 5, Phase 5, DHA, Karachi'),
    -- Order 4 (Sara at Kababjees - Delivered)
    (4, 5, '2026-09-10 20:00:00', '2026-09-10 21:00:00', 'Delivered', 'Villa 88, Do Darya, Karachi'),
    -- Order 5 (Haider Repeat Order at KFC Gulshan - Delivered)
    (1, 1, '2026-09-15 20:30:00', '2026-09-15 21:15:00', 'Delivered', 'Flat 4B, Block 13D, Gulshan-e-Iqbal, Karachi'),
    -- Order 6 (Hamza at Student Biryani Johar - Cancelled)
    (5, 4, '2026-09-18 14:00:00', '2026-09-18 14:45:00', 'Cancelled', 'Block 1, Pechs, Karachi'),
    -- Order 7 (Muzayyan Repeat Order at Kababjees - Preparing/In-Progress)
    (2, 5, '2026-09-20 21:15:00', '2026-09-20 22:00:00', 'Preparing', 'House 12, Line Area, Saddar, Karachi');

-- ---------------------------------------------
-- 9. SEED DATA FOR: order_items
-- (Line Items for Each Order)
-- ---------------------------------------------
INSERT INTO order_items (order_id, item_id, quantity, price, discount)
VALUES 
    -- Order 1 (1 Mighty Zinger + 1 Pepsi)
    (1, 2, 1, 850.00, 50.00),
    (1, 8, 1, 180.00, 0.00),
    -- Order 2 (2 Chicken Biryani + 1 Lassi)
    (2, 4, 2, 380.00, 0.00),
    (2, 9, 1, 150.00, 0.00),
    -- Order 3 (2 Zinger Burgers + 1 Hot Wings)
    (3, 1, 2, 550.00, 100.00),
    (3, 3, 1, 650.00, 0.00),
    -- Order 4 (1 Chicken Karahi + 1 Reshmi Kabab + 1 Gulab Jamun)
    (4, 6, 1, 1800.00, 0.00),
    (4, 7, 1, 850.00, 50.00),
    (4, 10, 1, 220.00, 0.00),
    -- Order 5 (1 Zinger Burger + 1 Pepsi)
    (5, 1, 1, 550.00, 0.00),
    (5, 8, 1, 180.00, 0.00),
    -- Order 6 (1 Chicken Biryani - Cancelled Order)
    (6, 4, 1, 380.00, 0.00),
    -- Order 7 (1 Reshmi Kabab + 1 Gulab Jamun)
    (7, 7, 1, 850.00, 0.00),
    (7, 10, 2, 220.00, 0.00);
-- ---------------------------------------------
-- 10. SEED DATA FOR: payments
-- (1:1 with Orders - Mapped to order_id 1 to 5)
-- ---------------------------------------------
INSERT INTO payments (order_id, payment_date, amount, payment_method)
VALUES 
    -- Order 1 Payment (850 - 50 + 180 = 980)
    (1, '2026-09-01 19:35:00', 980.00, 'Credit Card'),
    -- Order 2 Payment (2*380 + 150 = 910)
    (2, '2026-09-02 13:16:00', 910.00, 'Cash on Delivery'),
    -- Order 3 Payment (2*550 - 100 + 650 = 1650)
    (3, '2026-09-05 21:02:00', 1650.00, 'Mobile Wallet'),
    -- Order 4 Payment (1800 + 850 - 50 + 220 = 2820)
    (4, '2026-09-10 20:05:00', 2820.00, 'Credit Card'),
    -- Order 5 Payment (550 + 180 = 730)
    (5, '2026-09-15 20:32:00', 730.00, 'Cash on Delivery');

-- ---------------------------------------------
-- 11. SEED DATA FOR: deliveries
-- (Tracking Fulfillment for Orders)
-- ---------------------------------------------
INSERT INTO deliveries (order_id, rider_id, delivery_status, delivery_address, picked_up_at, delivered_at)
VALUES 
    -- Order 1 Delivery (Tariq - Delivered)
    (1, 1, 'Delivered', 'Flat 4B, Block 13D, Gulshan-e-Iqbal, Karachi', '2026-09-01 19:45:00', '2026-09-01 20:12:00'),
    -- Order 2 Delivery (Usman - Delivered)
    (2, 2, 'Delivered', 'House 12, Line Area, Saddar, Karachi', '2026-09-02 13:30:00', '2026-09-02 13:55:00'),
    -- Order 3 Delivery (Tariq - Delivered)
    (3, 1, 'Delivered', 'Street 5, Phase 5, DHA, Karachi', '2026-09-05 21:15:00', '2026-09-05 21:40:00'),
    -- Order 4 Delivery (Kamran - Delivered)
    (4, 3, 'Delivered', 'Villa 88, Do Darya, Karachi', '2026-09-10 20:25:00', '2026-09-10 20:55:00'),
    -- Order 5 Delivery (Usman - Delivered)
    (5, 2, 'Delivered', 'Flat 4B, Block 13D, Gulshan-e-Iqbal, Karachi', '2026-09-15 20:45:00', '2026-09-15 21:10:00'),
    -- Order 7 Delivery (Kamran - Out for Delivery / In Progress)
    (7, 3, 'Out for Delivery', 'House 12, Line Area, Saddar, Karachi', '2026-09-20 21:40:00', NULL);

-- ---------------------------------------------
-- 12. SEED DATA FOR: reviews
-- (Customer Ratings and Feedback)
-- ---------------------------------------------
INSERT INTO reviews (customer_id, order_id, rating, comment, review_date)
VALUES 
    -- Haider reviewing Order 1
    (1, 1, 5, 'Food was hot and delivered super fast! Great Zinger.', '2026-09-01 20:30:00'),
    -- Muzayyan reviewing Order 2
    (2, 2, 4, 'Biryani taste was awesome, but packaging could be better.', '2026-09-02 14:30:00'),
    -- Ali reviewing Order 3
    (3, 3, 5, 'KFC wings were crispy as expected.', '2026-09-05 22:00:00'),
    -- Sara reviewing Order 4
    (4, 4, 5, 'Kababjees Karahi was amazing! Excellent service.', '2026-09-10 21:30:00');