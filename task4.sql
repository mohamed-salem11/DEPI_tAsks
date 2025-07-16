use StoreDB;
SELECT COUNT(*) AS total_products FROM production.products;

SELECT AVG(list_price) AS avg_price, MIN(list_price) AS min_price, MAX(list_price) AS max_price FROM production.products;

SELECT category_id, COUNT(*) AS product_count FROM production.products GROUP BY category_id;

SELECT store_id, COUNT(*) AS total_orders FROM sales.orders GROUP BY store_id;

SELECT UPPER(first_name) AS first_name_upper, LOWER(last_name) AS last_name_lower FROM sales.customers ORDER BY customer_id OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT product_name, LEN(product_name) AS name_length FROM production.products ORDER BY product_id OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT customer_id, LEFT(phone, 3) AS area_code FROM sales.customers ORDER BY customer_id OFFSET 0 ROWS FETCH NEXT 15 ROWS ONLY;

SELECT TOP 10 
    GETDATE() AS [Current Date],
    order_id AS [Order ID],
    YEAR(order_date) AS [Order Year],
    MONTH(order_date) AS [Order Month]
FROM sales.orders
ORDER BY order_id;


SELECT p.product_name, c.category_name
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
ORDER BY p.product_id OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_date
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT p.product_name, ISNULL(b.brand_name, 'No Brand') AS brand_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id;

SELECT product_name, list_price FROM production.products
WHERE list_price > (SELECT AVG(list_price) FROM production.products);

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS customer_name
FROM sales.customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM sales.orders);

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       (SELECT COUNT(*) FROM sales.orders o WHERE o.customer_id = c.customer_id) AS order_count
FROM sales.customers c;

CREATE VIEW easy_product_list AS
SELECT p.product_name, c.category_name, p.list_price
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id;

SELECT * FROM easy_product_list WHERE list_price > 100;

CREATE VIEW customer_info AS
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name, email, CONCAT(city, ', ', state) AS location
FROM sales.customers;

SELECT * FROM customer_info WHERE location LIKE '%, CA';

SELECT product_name, list_price FROM production.products
WHERE list_price BETWEEN 50 AND 200
ORDER BY list_price ASC;

SELECT state, COUNT(*) AS customer_count
FROM sales.customers
GROUP BY state
ORDER BY customer_count DESC;

SELECT c.category_name, p.product_name, p.list_price
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);

SELECT s.store_name, s.city, COUNT(o.order_id) AS order_count
FROM sales.stores s
LEFT JOIN sales.orders o ON s.store_id = o.store_id
GROUP BY s.store_id, s.store_name, s.city;
