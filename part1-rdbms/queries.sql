-- Q1: List all customers from Mumbai along with their total order value
SELECT 
    customer_id,
    customer_name,
    SUM(unit_price * quantity) AS total_order_value
FROM orders
WHERE customer_city = 'Mumbai'
GROUP BY customer_id, customer_name;


-- Q2: Find the top 3 products by total quantity sold
SELECT 
    product_id,
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM orders
GROUP BY product_id, product_name
ORDER BY total_quantity_sold DESC
LIMIT 3;


-- Q3: List all sales representatives and the number of unique customers they have handled
SELECT 
    sales_rep_id,
    sales_rep_name,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
GROUP BY sales_rep_id, sales_rep_name;


-- Q4: Find all orders where the total value exceeds 10,000, sorted by value descending
SELECT 
    order_id,
    customer_id,
    (unit_price * quantity) AS total_value
FROM orders
WHERE (unit_price * quantity) > 10000
ORDER BY total_value DESC;


-- Q5: Identify any products that have never been ordered
SELECT 
    p.product_id,
    p.product_name
FROM (
    SELECT DISTINCT product_id, product_name
    FROM orders
) p
LEFT JOIN orders o 
    ON p.product_id = o.product_id
WHERE o.product_id IS NULL;