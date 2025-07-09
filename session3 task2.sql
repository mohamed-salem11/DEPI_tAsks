-- create db
CREATE DATABASE StoreDB
go

USE StoreDB
go

-- create schemas
CREATE SCHEMA production;
go

CREATE SCHEMA sales;
go

-- create tables
CREATE TABLE production.categories (
 category_id INT IDENTITY (1, 1) PRIMARY KEY,
 category_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.brands (
 brand_id INT IDENTITY (1, 1) PRIMARY KEY,
 brand_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.products (
 product_id INT IDENTITY (1, 1) PRIMARY KEY,
 product_name VARCHAR (255) NOT NULL,
 brand_id INT NOT NULL,
 category_id INT NOT NULL,
 model_year SMALLINT NOT NULL,
 list_price DECIMAL (10, 2) NOT NULL,
 FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sales.customers (
 customer_id INT IDENTITY (1, 1) PRIMARY KEY,
 first_name VARCHAR (255) NOT NULL,
 last_name VARCHAR (255) NOT NULL,
 phone VARCHAR (25),
 email VARCHAR (255) NOT NULL,
 street VARCHAR (255),
 city VARCHAR (50),
 state VARCHAR (25),
 zip_code VARCHAR (5)
);

CREATE TABLE sales.stores (
 store_id INT IDENTITY (1, 1) PRIMARY KEY,
 store_name VARCHAR (255) NOT NULL,
 phone VARCHAR (25),
 email VARCHAR (255),
 street VARCHAR (255),
 city VARCHAR (255),
 state VARCHAR (10),
 zip_code VARCHAR (5)
);

CREATE TABLE sales.staffs (
 staff_id INT IDENTITY (1, 1) PRIMARY KEY,
 first_name VARCHAR (50) NOT NULL,
 last_name VARCHAR (50) NOT NULL,
 email VARCHAR (255) NOT NULL UNIQUE,
 phone VARCHAR (25),
 active tinyint NOT NULL,
 store_id INT NOT NULL,
 manager_id INT,
 FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (manager_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sales.orders (
 order_id INT IDENTITY (1, 1) PRIMARY KEY,
 customer_id INT,
 order_status tinyint NOT NULL,
 -- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
 order_date DATE NOT NULL,
 required_date DATE NOT NULL,
 shipped_date DATE,
 store_id INT NOT NULL,
 staff_id INT NOT NULL,
 FOREIGN KEY (customer_id) REFERENCES sales.customers (customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (staff_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sales.order_items (
 order_id INT,
 item_id INT,
 product_id INT NOT NULL,
 quantity INT NOT NULL,
 list_price DECIMAL (10, 2) NOT NULL,
 discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
 PRIMARY KEY (order_id, item_id),
 FOREIGN KEY (order_id) REFERENCES sales.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE production.stocks (
 store_id INT,
 product_id INT,
 quantity INT,
 PRIMARY KEY (store_id, product_id),
 FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);



INSERT INTO production.categories (category_name) VALUES 
('Laptops'),
('Phones'),
('Accessories');

INSERT INTO production.brands (brand_name) VALUES 
('Apple'),
('Samsung'),
('Dell'),
('HP');

INSERT INTO production.products (product_name, brand_id, category_id, model_year, list_price) VALUES
('iPhone 14', 1, 2, 2023, 999.99),
('Galaxy S22', 2, 2, 2023, 899.99),
('Dell XPS 13', 3, 1, 2022, 1299.99),
('HP Pavilion', 4, 1, 2021, 799.99),
('Apple Watch', 1, 3, 2023, 399.99);

INSERT INTO sales.customers (first_name, last_name, phone, email, street, city, state, zip_code) VALUES
('Ahmed', 'Ali', '01001234567', 'ahmed@example.com', '123 Nile St', 'Cairo', 'EG', '11311'),
('Sara', 'Hassan', '01007654321', 'sara@example.com', '456 Tahrir St', 'Giza', 'EG', '12556');

INSERT INTO sales.stores (store_name, phone, email, street, city, state, zip_code) VALUES
('Main Branch', '022345678', 'main@store.com', '15 Downtown St', 'Cairo', 'EG', '11111'),
('Giza Branch', '023456789', 'giza@store.com', '22 Pyramids Rd', 'Giza', 'EG', '12222');

INSERT INTO sales.staffs (first_name, last_name, email, phone, active, store_id, manager_id)
VALUES ('Ali', 'Manager', 'manager1@store.com', '0100999888', 1, 1, NULL);


INSERT INTO sales.staffs (first_name, last_name, email, phone, active, store_id, manager_id)

INSERT INTO sales.orders (customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id) VALUES
(1, 2, '2025-07-01', '2025-07-05', '2025-07-03', 1, 2),
(2, 1, '2025-07-02', '2025-07-06', NULL, 2, 2);

INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount) VALUES
(1, 1, 1, 1, 999.99, 0.00),
(1, 2, 5, 2, 399.99, 0.05),
(2, 1, 2, 1, 899.99, 0.00);

INSERT INTO production.stocks (store_id, product_id, quantity) VALUES
(1, 1, 10),
(1, 3, 5),
(2, 2, 8),
(2, 5, 6);



SELECT * FROM sales.staffs WHERE active = 0;

SELECT TOP 5 * FROM production.products ORDER BY list_price DESC;

SELECT TOP 10 * FROM sales.orders ORDER BY order_date DESC;

SELECT TOP 3 * FROM sales.customers ORDER BY last_name ASC;

SELECT * FROM sales.customers WHERE phone IS NULL OR phone = '';

SELECT * FROM sales.staffs WHERE manager_id IS NOT NULL;

SELECT category_id, COUNT(*) AS product_count FROM production.products GROUP BY category_id;

SELECT state, COUNT(*) AS customer_count FROM sales.customers GROUP BY state;

SELECT brand_id, AVG(list_price) AS avg_price FROM production.products GROUP BY brand_id;

SELECT staff_id, COUNT(*) AS order_count FROM sales.orders GROUP BY staff_id;

SELECT customer_id FROM sales.orders GROUP BY customer_id HAVING COUNT(*) > 2;

SELECT * FROM production.products WHERE list_price BETWEEN 500 AND 1500;

SELECT * FROM sales.customers WHERE city LIKE 'S%';

SELECT * FROM sales.orders WHERE order_status IN (2, 4);

SELECT * FROM production.products WHERE category_id IN (1, 2, 3);

SELECT * FROM sales.staffs WHERE store_id = 1 OR phone IS NULL OR phone = '';

SELECT product_id, SUM(quantity) AS total_quantity FROM production.stocks GROUP BY product_id;

SELECT store_id, COUNT(*) AS staff_count FROM sales.staffs GROUP BY store_id;

SELECT category_id, MAX(list_price) AS max_price FROM production.products GROUP BY category_id;

SELECT customer_id, SUM(quantity * list_price * (1 - discount)) AS total_spent
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY customer_id;

SELECT product_id, COUNT(*) AS order_count FROM sales.order_items GROUP BY product_id;

