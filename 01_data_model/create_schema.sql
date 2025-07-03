
-- PART 1: OPERATIONAL DATABASE (ERD)


CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_category_id INT,
    FOREIGN KEY (parent_category_id) REFERENCES Category(category_id)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    availability BOOLEAN NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    address TEXT,
    region VARCHAR(100),
    registration_date DATE
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE OrderItem (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Transaction (
    transaction_id INT PRIMARY KEY,
    order_id INT,
    transaction_date DATE NOT NULL,
    payment_method VARCHAR(50),
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- PART 2: ANALYTICAL MODEL (STAR SCHEMA)

CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id)
);

CREATE TABLE dim_category (
    category_id INT PRIMARY KEY,
    name VARCHAR(100),
    parent_category_id INT
);

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(100),
    registration_date DATE
);

CREATE TABLE dim_date (
    date_id DATE PRIMARY KEY,
    day INT,
    week INT,
    month INT,
    quarter INT,
    year INT
);

CREATE TABLE fact_sales (
    order_item_id INT PRIMARY KEY,
    date_id DATE,
    product_id INT,
    customer_id INT,
    category_id INT, -- denormalized for performance
    quantity INT,
    unit_price DECIMAL(10, 2),
    total_price DECIMAL(12, 2),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id)
);
