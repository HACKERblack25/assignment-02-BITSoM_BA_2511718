-- Q1: List all customers along with the total number of orders they have placed
SELECT 
    c.customer_name, 
    COUNT(o.order_id) as total_orders
FROM 'datasets/customers.csv' c
LEFT JOIN 'datasets/orders.json' o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- Q2: Find the top 3 customers by total order value
-- Note: Joining Orders (JSON) and Products (Parquet) to get prices
SELECT 
    c.customer_name, 
    SUM(o.quantity * p.price) as total_value
FROM 'datasets/customers.csv' c
JOIN 'datasets/orders.json' o ON c.customer_id = o.customer_id
JOIN 'datasets/products.parquet' p ON o.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_value DESC
LIMIT 3;

-- Q3: List all products purchased by customers from Bangalore
SELECT DISTINCT 
    p.product_name
FROM 'datasets/products.parquet' p
JOIN 'datasets/orders.json' o ON p.product_id = o.product_id
JOIN 'datasets/customers.csv' c ON o.customer_id = c.customer_id
WHERE c.city = 'Bangalore';

-- Q4: Join all three files to show: customer name, order date, product name, and quantity
SELECT 
    c.customer_name, 
    o.order_date, 
    p.product_name, 
    o.quantity
FROM 'datasets/customers.csv' c
JOIN 'datasets/orders.json' o ON c.customer_id = o.customer_id
JOIN 'datasets/products.parquet' p ON o.product_id = p.product_id;