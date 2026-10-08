-- =============================================
-- Project: Food Delivery Database
-- File: database/01-schema.sql
-- Description: Core table definitions and primary keys
-- =============================================

-- 1. Customers Table
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    phone       VARCHAR(20) UNIQUE NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    city        NVARCHAR(50) NOT NULL,
    state       NVARCHAR(50) NOT NULL,
    created_at  DATETIME2 DEFAULT GETDATE()
);

-- 2. Restaurants Table
CREATE TABLE restaurants (
    restaurant_id   INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    phone           VARCHAR(20) NOT NULL,
    email           VARCHAR(60) NULL,
    city            NVARCHAR(50) NOT NULL,
    state           NVARCHAR(50) NOT NULL,
    created_at      DATETIME2 DEFAULT GETDATE()
);

-- 3. Categories Table
CREATE TABLE categories (
    category_id   INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- 4. Riders Table
CREATE TABLE riders (
    rider_id     INT IDENTITY(1,1) PRIMARY KEY,
    first_name   VARCHAR(50) NOT NULL,
    last_name    VARCHAR(50) NOT NULL,
    phone        VARCHAR(20) UNIQUE NOT NULL,
    email        VARCHAR(100) UNIQUE NULL,
    address      VARCHAR(250) NULL,
    vehicle_no   VARCHAR(30) UNIQUE NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    created_at   DATETIME2 DEFAULT GETDATE()
);

-- 5. Branches Table
CREATE TABLE branches (
    branch_id     INT IDENTITY(1,1) PRIMARY KEY,
    branch_name   VARCHAR(100) NOT NULL,
    restaurant_id INT NOT NULL,
    phone         VARCHAR(20) UNIQUE NOT NULL,
    city          NVARCHAR(50) NOT NULL,
    state         NVARCHAR(50) NOT NULL,
    created_at    DATETIME2 DEFAULT GETDATE()
);

-- 6. Menu Items Table
CREATE TABLE menu_items (
    item_id       INT IDENTITY(1,1) PRIMARY KEY,
    item_name     VARCHAR(100) NOT NULL,
    category_id   INT NOT NULL,
    restaurant_id INT NOT NULL,
    price         DECIMAL(10,2) NOT NULL,
    created_at    DATETIME2 DEFAULT GETDATE()
);

-- 7. Branch Menu Items (Junction Table)
CREATE TABLE branch_menu_items (
    branch_id INT NOT NULL,
    item_id   INT NOT NULL,
    PRIMARY KEY (branch_id, item_id)
);

-- 8. Orders Table
CREATE TABLE orders (
    order_id      INT IDENTITY(1,1) PRIMARY KEY,
    customer_id   INT NOT NULL,
    branch_id     INT NOT NULL,
    order_date    DATETIME2 DEFAULT GETDATE(),
    required_date DATETIME2 NULL,
    order_status  VARCHAR(30) NOT NULL,
    address       NVARCHAR(500) NOT NULL
);

-- 9. Order Items Table
CREATE TABLE order_items (
    order_id INT NOT NULL,
    item_id  INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price    DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0.00,
    PRIMARY KEY (order_id, item_id)
);

-- 10. Payments Table
CREATE TABLE payments (
    payment_id     INT IDENTITY(1,1) PRIMARY KEY,
    order_id       INT NOT NULL UNIQUE, -- 1:1 relationship with orders
    payment_date   DATETIME2 DEFAULT GETDATE(),
    amount         DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL
);

-- 11. Deliveries Table
CREATE TABLE deliveries (
    delivery_id      INT IDENTITY(1,1) PRIMARY KEY,
    order_id         INT NOT NULL UNIQUE, -- 1:1 relationship with orders
    rider_id         INT NOT NULL,
    delivery_status  VARCHAR(30) NOT NULL,
    delivery_address NVARCHAR(500) NOT NULL,
    picked_up_at     DATETIME2 NULL,
    delivered_at     DATETIME2 NULL
);

-- 12. Reviews Table
CREATE TABLE reviews (
    review_id   INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_id    INT NOT NULL UNIQUE, -- 1:0..1 relationship
    rating      INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment     NVARCHAR(1000) NULL,
    review_date DATETIME2 DEFAULT GETDATE()
);