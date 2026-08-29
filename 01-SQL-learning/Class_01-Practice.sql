CREATE DATABASE Store;
GO

USE Store;

CREATE SCHEMA Productions;
GO

CREATE TABLE Productions.products(
prod_id INT PRIMARY KEY,
prod_name VARCHAR(25),
category VARCHAR(25),
price INT NOT NULL,
stock_quantity INT
);

INSERT INTO Productions.products
VALUES
(1,'Wireless Mouse', 'Electronics', 25, 50),
(2,'Gaming Headset', 'Electronics', 50, 10),
(3,'Mechanical Keyboard', 'Electronics', 120, 100),
(4,'Cotton T-Shirt', 'Apparel', 200, 70);

INSERT INTO Productions.products (prod_id, prod_name, category, price, stock_quantity) VALUES
(5, 'USB-C Cable', 'Electronics', 15, 120),
(6, 'Bluetooth Speaker', 'Electronics', 85, 30),
(7, '4K Monitor', 'Electronics', 350, 12),
(8, 'Webcam 1080p', 'Electronics', 45, 45),
(9, 'Denim Jacket', 'Apparel', 120, 25),
(10, 'Casual Hoodie', 'Apparel', 65, 50),
(11, 'Graphic Tee', 'Apparel', 25, 80),
(12, 'Leather Belt', 'Apparel', 30, 40),
(13, 'Office Chair', 'Furniture', 210, 15),
(14, 'Wooden Desk', 'Furniture', 180, 8),
(15, 'Bookshelf', 'Furniture', 95, 20),
(16, 'Desk Lamp', 'Furniture', 35, 60),
(17, 'Stainless Water Bottle', 'Accessories', 20, 150),
(18, 'Backpack', 'Accessories', 55, 40),
(19, 'Sunglasses', 'Accessories', 40, 75),
(20, 'Wrist Watch', 'Accessories', 150, 18),
(21, 'Gaming Mousepad', 'Electronics', 18, 90),
(22, 'Power Bank 20000mAh', 'Electronics', 50, 35),
(23, 'Sneakers', 'Apparel', 90, 22),
(24, 'Notebook Pack', 'Accessories', 12, 200);

SELECT * FROM Productions.products;
--DROP TABLE IF EXISTS Productions.products;
--DROP SCHEMA IF EXISTS Productions;
--DROP DATABASE IF EXISTS Store;

-- Query 1: Un products ke prod_name, category, aur price dikhao jin ki category 'Furniture' ho YA 'Accessories' ho.
SELECT prod_name, category, price FROM Productions.products WHERE category = 'Furniture' or category = 'Accessories';

-- Query 2: Un products ke naam aur price dikhao jin ka stock_quantity 30 se kam ( < 30 ) hai AUR unki price 50 se ziada ( > 50 ) hai.
SELECT prod_name, price FROM Productions.products WHERE (price > 50) AND (stock_quantity < 30);

-- Query 3: Un tamam products ko dhoondo jin ke naam (prod_name) mein kahin bhi 'Desk' ka word aata ho.
SELECT * FROM Productions.products WHERE   prod_name LIKE '%Desk%';


-- Task 1: Ek query likho jo sab se saste 3 products (price ASC) dikhaye using TOP.
SELECT TOP 3 * FROM Productions.products;

-- Task 2: Ek query likho jo prod_id ke hisaab se sorted ho, pehli 10 rows skip kare aur uske baad ki 5 rows dikhaye using OFFSET-FETCH.
SELECT * FROM PRODUCTIONS.PRODUCTS 
ORDER BY (prod_id)
OFFSET 5 ROWS FETCH NEXT 10  ROWS ONLY;