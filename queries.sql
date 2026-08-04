-- ============================================================
-- E-Commerce SQL Analytics — 100 Practice Queries
-- Run schema.sql first to create and populate the database.
-- ============================================================

-- 🟢 Basic Level (1-15)

-- 1 Display all customers.

SELECT * FROM customers;

-- 2.Show only customer_name and city.

SELECT customer_name,city FROM customers;


-- 3.Find all female customers.

SELECT*FROM customers
where gender="Female";

-- 4.List all products with price greater than 500.

SELECT * FROM products
where price>500
order by price desc

-- 5.Display products whose category is 'Electronics'.

SELECT * FROM products
WHERE category="Electronics"

-- 6.Find all orders placed after 2025-05-01.

SELECT * FROM orders
where order_date="2025-05-01";

-- 7.Display customers from Hyderabad.

SELECT*FROM customers
where city="Hyderabad"

-- 8.Count the total number of customers.
select count(*) from customers
select distinct(count(*)) from customers

-- 9.Find the maximum product price.
SELECT *FROM products
where price=(select max(price) from products)
-- or
SELECT MAX(price) from products

-- 10.Find the minimum product price.
SELECT *FROM products
where price=(select min(price) from products)
-- or
SELECT min(price) from products

-- 11.Find the average product price.

select avg(price) from products

-- 12.Count how many products are available.
select count(*) from products
group by category

-- 13.Display unique categories.
select category from products
group by category
-- or 
select distinct(category) from products

-- 14.Find products priced between 500 and 2000.
SELECT *
FROM products
WHERE price BETWEEN 500 AND 2000;

SELECT * FROM products
where price>500 and price<2000

-- 15.Find customers whose names start with 'A'.
SELECT *
FROM customers
WHERE customer_name LIKE 'A%';

-- 🟡 Intermediate Level (16-35)

-- 16.Display all orders along with customer names.
select customer_name,order_status from customers join orders
on customers.customer_id=orders.customer_id

-- 17.Show every ordered product with its quantity.
select distinct(product_name),quantity from products join order_items 
on products.product_id=order_items.product_id

-- 18.Find the total quantity sold for each product.

select sum(quantity) from order_items join orders 
on order_items.order_id=orders.order_id
where order_status="Delivered"

-- 19.Display all customers who have placed at least one order.

SELECT DISTINCT Customers.*
FROM Customers
JOIN Orders
ON Customers.customer_id = Orders.customer_id;

-- 20.Find customers who never placed an order.

SELECT distinct(customer_name),gender from customers left join orders
on customers.customer_id = orders.customer_id
where customers.customer_id not in (select customer_id from orders)

-- or 
SELECT customer_name, gender
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
WHERE orders.customer_id IS NULL;

-- 21.Count the number of orders placed by each customer.
SELECT customer_name, COUNT(order_id) AS total_orders
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customer_name;

-- 22.Find the customer who placed the maximum number of orders.

SELECT customer_name, (COUNT(order_id)) AS total_orders
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customer_name
order by total_orders desc
limit 1;

-- 23.Display the total amount of every order.

SELECT order_item_id,
       quantity,
       unit_price,
       quantity * unit_price AS total_amount
FROM order_items;

SELECT order_id,
       SUM(quantity * unit_price) AS total_amount
FROM order_items
GROUP BY order_id;

-- 24.Find the most expensive product ordered.
SELECT product_name,
       unit_price
FROM Products
JOIN Order_Items
ON Products.product_id = Order_Items.product_id
ORDER BY unit_price DESC
LIMIT 1;

-- 25.Show all orders with their status.

SELECT order_id,order_status from orders;


-- 26.Count orders based on status.

SELECT order_status,count(order_status) from orders
group by order_status;

-- 27.Find the total sales for each product.
select product_name,sum(quantity*unit_price) as total_price from order_items join products
on order_items.product_id=products.product_id
group by order_items.product_id;

-- 28.Find the total sales for each category.
select category,sum(quantity*unit_price) as total_price from order_items join products
on order_items.product_id=products.product_id
group by category;

-- 29.Find products that were never ordered.

select distinct(product_name),products.product_id from products left join order_items
on products.product_id=order_items.product_id
where products.product_id not in (select product_id from order_items);

-- or
SELECT p.product_id,
       p.product_name
FROM Products p
LEFT JOIN Order_Items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


-- 30.Display all orders with more than or equal to three items.

select order_id,count(order_id) as orders_count from order_items
group by order_id
having orders_count>=3;

-- 31.Find customers who ordered more than five products in total.

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity) AS total_products
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
JOIN Order_Items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING SUM(oi.quantity) > 5;

-- 32.Display the latest order of every customer.

select orders.customer_id,customer_name,max(order_date) from customers join orders 
on customers.customer_id=orders.customer_id
group by orders.customer_id;

SELECT order_id,
       customer_id,
       customer_name,
       order_date
FROM (
    SELECT o.order_id,
           o.customer_id,
           c.customer_name,
           o.order_date,
           ROW_NUMBER() OVER (
               PARTITION BY o.customer_id
               ORDER BY o.order_date DESC
           ) AS rn
    FROM Orders o
    JOIN Customers c
    ON o.customer_id = c.customer_id
) t
WHERE rn = 1;

-- 33.Find customers who ordered products from multiple categories.

SELECT DISTINCT c.customer_name,
                p.category
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Items oi
ON o.order_id = oi.order_id
JOIN Products p
ON oi.product_id = p.product_id;

-- 34.Find the cheapest product in each category.
select category,min(price) from products
group by category;

-- 35.Find the costliest product in each category.
select category,max(price) from products
group by category;

-- 36.Find the average product price in each category.
select category,avg(price) from products
group by category;

-- 37.Count products in every category.
select category,count(*) from products
group by category;

-- 38.Find total revenue generated by each category.

select category,sum(price) from products
group by category;

-- 39.Find cities with more than five customers.
select city,count(customer_name) as count_name from customers
group by city
having count_name>5;

-- 40.Display total quantity sold by each category.
select category,sum(quantity) as total_quantity from products join order_items 
on products.product_id=order_items.product_id
group by category;

-- 🟠 Advanced Level (41-80)

-- 41.Find the average order value.

SELECT round(AVG(order_total),2) AS average_order_value
FROM (
    SELECT order_id,
           SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS t;


-- 42.Find the highest order value.
SELECT MAX(order_total) AS highest_order
FROM (
    SELECT order_id,
           SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS t;

-- 43.Find the lowest order value.

SELECT MIN(order_total) AS highest_order
FROM (
    SELECT order_id,
           SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS t;

-- 44.Display customers whose total spending exceeds ₹10,000.

SELECT c.customer_name,
       SUM(oi.quantity * oi.unit_price) AS spending_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(oi.quantity * oi.unit_price) > 10000;

-- 45.Find categories generating more than ₹50,000 revenue.

select category,sum(quantity*unit_price) as revenue from products join order_items
on products.product_id=order_items.product_id
group by category
having revenue>50000;

-- 46.Find customers who placed more than two orders.

select customer_name,count(orders.customer_id) as placed_orders from customers join orders
on customers.customer_id = orders.customer_id
group by orders.customer_id
having placed_orders>2;

-- 47.Display months having the highest number of orders.
SELECT MONTHNAME(order_date) AS month,
       COUNT(*) AS total_orders
FROM Orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY total_orders DESC
LIMIT 1;

SELECT MONTHNAME(order_date) AS month,
       COUNT(*) AS total_orders
FROM Orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
HAVING COUNT(*) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM Orders
        GROUP BY MONTH(order_date)
    ) AS t
);

-- 48.Find the average quantity ordered per product.

SELECT p.product_name,
       AVG(oi.quantity) AS avg_quantity
FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- 49.Find products ordered more than 100 times.

select product_name,sum(quantity) as product_quantity from products p join order_items oi
on p.product_id=oi.product_id
group by oi.product_id
having product_quantity>100;

-- or 
SELECT p.product_name,
       SUM(oi.quantity) AS product_quantity
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) > 100;


-- 50.Find the top three categories by sales.

select category,sum(quantity*unit_price) as total_sales from products p join order_items oi
on p.product_id=oi.product_id
group by category
order by total_sales desc
limit 3;

-- 51.Display customer name, order ID, and order date.

select customer_name,order_id,order_date from customers c join orders o
on c.customer_id=o.customer_id;

-- 52.Display customer name, product name, and quantity purchased.

select customer_name ,product_name,quantity from customers c join orders o
on c.customer_id=o.customer_id join order_items oi
on o.order_id = oi.order_id join products p 
on oi.product_id = p.product_id;

-- 53.Show all products with customer names who purchased them.

select customer_name,product_name from customers c join orders o
on c.customer_id=o.customer_id join order_items oi
on o.order_id=oi.order_id join products p
on oi.product_id=p.product_id;

-- 54.Display order status along with customer city.

select city,order_status from customers c join orders o
on c.customer_id=o.customer_id;

-- 55.Show products ordered by customers from Hyderabad.

select customer_name,product_name from customers c join orders o
on c.customer_id=o.customer_id join order_items oi
on o.order_id=oi.order_id join products p
on oi.product_id=p.product_id
where city="Hyderabad";

-- 56.Display customers who purchased Electronics products.

select distinct(customer_name),category from customers c join orders o
on c.customer_id=o.customer_id join order_items oi
on o.order_id=oi.order_id join products p
on oi.product_id=p.product_id
where category="Electronics";

-- 57.Find customers who bought more than one product in a single order.

SELECT c.customer_name,
       o.order_id,
       COUNT(oi.product_id) AS no_products
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, o.order_id
HAVING COUNT(oi.product_id) > 1;

-- 58.Find orders containing products from different categories.

SELECT oi.order_id,
       COUNT(DISTINCT p.category) AS category_count
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY oi.order_id
HAVING COUNT(DISTINCT p.category) > 1;

-- 59.Find the total value of each customer's purchases.

SELECT c.customer_name,
       SUM(oi.quantity * oi.unit_price) AS total_purchase_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name;

-- 60.Show every product with the number of customers who bought it

SELECT p.product_name,
       COUNT(DISTINCT o.customer_id) AS no_of_customers
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN orders o
ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name;

-- 61.Find the customer who spent the most.
select (customer_name), sum(quantity*unit_price) as max_spent from customers  c join orders o
on c.customer_id=o.customer_id join order_items oi
on o.order_id=oi.order_id
group by customer_name,o.customer_id
order by max_spent desc
limit 1;

SELECT c.customer_name,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- 62.Find the product generating the highest revenue.

select product_name,sum(quantity*unit_price) as highest_revenue from products p join order_items oi
on p.product_id=oi.product_id
group by product_name,oi.product_id
order by highest_revenue desc
limit 1;

-- 63.Find the city generating the highest revenue.

select city, sum(quantity*unit_price) as city_revenue from customers c join orders o
on c.customer_id=o.customer_id join order_items oi
on o.order_id=oi.order_id
group by city
order by city_revenue desc
limit 1;

-- 64.Display customers and the categories they purchased.

select customer_name,category from customers c join orders o
on c.customer_id=o.customer_id join order_items oi
on o.order_id=oi.order_id join products p
on oi.product_id=p.product_id;

-- 65.Find customers who bought every product in a category.

SELECT c.customer_name
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
WHERE p.category = 'Electronics'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*)
    FROM products
    WHERE category = 'Electronics'
);

-- 66.Find products priced above the average price.
SELECT product_name, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

-- 67.Find customers who spent more than the average customer.
SELECT customer_name,
       total_spent
FROM (
    SELECT c.customer_id,
           c.customer_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_spending
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(oi.quantity * oi.unit_price) AS total_spent
        FROM customers c
        JOIN orders o
        ON c.customer_id = o.customer_id
        JOIN order_items oi
        ON o.order_id = oi.order_id
        GROUP BY c.customer_id
    ) AS avg_spending
);

-- 68.Find products that have never been purchased.

select product_name,product_id from products
where product_id not in (select product_id from order_items
group by product_id);

SELECT product_name, product_id
FROM products
WHERE product_id NOT IN (
    SELECT product_id
    FROM order_items
);

SELECT p.product_name,
       p.product_id
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 69.Find customers whose first order was in 2025.

SELECT c.customer_name,
       MIN(o.order_date) AS first_order
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING YEAR(MIN(o.order_date)) = 2025;

-- 70.Find products with price greater than the average price of their category.

SELECT p1.product_name,
       p1.category,
       p1.price
FROM products p1
WHERE p1.price > (
    SELECT AVG(p2.price)
    FROM products p2
    WHERE p2.category = p1.category
);


-- 71.Find customers who purchased the most expensive product.

select customer_name,price from customers c join orders o
on c.customer_id=o.customer_id join order_items oi
on o.order_id=oi.order_id join products p 
on oi.product_id=p.product_id
where p.price=(select max(price) from products);


-- 72.Find orders having value greater than the average order value

SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS order_value
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > (
    SELECT AVG(order_value)
    FROM (
        SELECT SUM(quantity * unit_price) AS order_value
        FROM order_items
        GROUP BY order_id
    ) AS t
);


-- 73.Find products purchased only once.

select product_name,count(oi.product_id) from products p join order_items oi
on p.product_id=oi.product_id
group by oi.product_id
having count(oi.product_id)=1;

SELECT product_name
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM order_items
    GROUP BY product_id
    HAVING COUNT(*) = 1
);

-- 74.Find customers who ordered exactly one product.

SELECT c.customer_name
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_name
HAVING COUNT(oi.product_id) = 1;


-- 75.Find customers who ordered all categories.

SELECT c.customer_name
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.category) = (
    SELECT COUNT(DISTINCT category)
    FROM products
);

-- 76.Find the second highest-priced product.

select max(price) from products
where price<(select max(price) from products);


-- 77.Find the third highest revenue-generating product.

select sum(quantity*unit_price) as total_revenue from products p join order_items oi
on p.product_id=oi.product_id
group by product_name
order by total_revenue desc
limit 2,1;

-- 78.Find customers whose spending is below average.

SELECT customer_name,
       total_spent
FROM (
    SELECT c.customer_id,
           c.customer_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_spending
WHERE total_spent < (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(quantity * unit_price) AS total_spent
        FROM orders o
        JOIN order_items oi
        ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) AS avg_spending
);

-- 79.Find the latest product ordered.

SELECT p.product_name
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_date = (
    SELECT MAX(order_date)
    FROM orders
);

-- 80.Find customers who bought the cheapest product.

select distinct(customer_name),product_name from customers c join orders o 
on c.customer_id=o.customer_id join order_items oi 
on o.order_id=oi.order_id join products p 
on oi.product_id=p.product_id
where p.price=(select min(price) from  products);

-- 🔵 Window Functions & Analytics (81-100)

-- 81.Rank products by price.

select product_name,price,
rank() over (order by price desc) as rank_
from products;


-- 82.Dense rank customers based on total spending.

SELECT c.customer_name,
       SUM(oi.quantity * oi.unit_price) AS total_spent,
       DENSE_RANK() OVER (
           ORDER BY SUM(oi.quantity * oi.unit_price) DESC
       ) AS spending_rank
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name;

-- 83.Find the top three customers by revenue.
SELECT *
FROM (
    SELECT c.customer_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent,
           DENSE_RANK() OVER (
               ORDER BY SUM(oi.quantity * oi.unit_price) DESC
           ) AS spending_rank
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
) AS t
WHERE spending_rank <= 3;

-- 84.Rank categories by revenue.

SELECT p.category,
       SUM(oi.quantity * oi.unit_price) AS revenue,
       RANK() OVER (
           ORDER BY SUM(oi.quantity * oi.unit_price) DESC
       ) AS rn
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category;

-- 85.Show cumulative sales for each product.

SELECT product_id,
       quantity,
       unit_price,
       quantity * unit_price AS sales,
       SUM(quantity * unit_price) OVER (
           PARTITION BY product_id
           ORDER BY order_id
       ) AS cumulative_sales
FROM order_items;


-- 86.Show running revenue by order date.

SELECT o.order_date,
       SUM(oi.quantity * oi.unit_price) AS daily_revenue,
       SUM(SUM(oi.quantity * oi.unit_price)) OVER (
           ORDER BY o.order_date
       ) AS running_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- 87.Display previous order date for each customer.

SELECT c.customer_name,
       o.order_date,
       LAG(o.order_date) OVER (
           PARTITION BY c.customer_id
           ORDER BY o.order_date
       ) AS previous_order_date
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;

-- 88.Display next order date for each customer.

SELECT c.customer_name,
       o.order_date,
       lead(o.order_date) OVER (
           PARTITION BY c.customer_id
           ORDER BY o.order_date
       ) AS next_order_date
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;

-- 89.Find the difference between current and previous order amount.

SELECT customer_id,
       order_id,
       order_date,
       order_amount,
       order_amount -
       LAG(order_amount) OVER (
           PARTITION BY customer_id
           ORDER BY order_date
       ) AS difference
FROM (
    SELECT c.customer_id,
           o.order_id,
           o.order_date,
           SUM(oi.quantity * oi.unit_price) AS order_amount
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY c.customer_id, o.order_id, o.order_date
) AS t;

-- 90.Find the first order of every customer.

SELECT order_id,
       order_date,
       o.customer_id,
       ROW_NUMBER() OVER (
           PARTITION BY o.customer_id
           ORDER BY order_date ASC
       ) AS first_order
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;

-- 91.Find the last order of every customer.
SELECT order_id,
       order_date,
       o.customer_id,
       ROW_NUMBER() OVER (
           PARTITION BY o.customer_id
           ORDER BY order_date desc
       ) AS last_order
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;

SELECT *
FROM (
    SELECT order_id,
           order_date,
           customer_id,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY order_date DESC
           ) AS rn
    FROM orders
) AS t
WHERE rn = 1;

-- 92.Display row numbers for products within each category

select product_name,
row_number() over (partition by category order by product_name) as rnk
from products;

-- 93.Find the highest-priced product in every category using window functions

SELECT product_name, category, price
FROM (
    SELECT product_name,
           category,
           price,
           ROW_NUMBER() OVER (
               PARTITION BY category
               ORDER BY price DESC
           ) AS rn
    FROM products
) AS t
WHERE rn = 1;

-- 94.Find the lowest-priced product in every category using window functions.

SELECT product_name, category, price
FROM (
    SELECT product_name,
           category,
           price,
           ROW_NUMBER() OVER (
               PARTITION BY category
               ORDER BY price asc
           ) AS rn
    FROM products
) AS t
WHERE rn = 1;

-- 95.Display each customer's percentage contribution to total revenue

SELECT customer_name,
       revenue,
       ROUND(
           revenue / SUM(revenue) OVER () * 100,
           2
       ) AS percentage_contribution
FROM (
    SELECT c.customer_id,
           c.customer_name,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
) AS t;

-- 96.Find the customer who generated the highest revenue in each city.

SELECT customer_name, city, revenue
FROM (
    SELECT c.customer_id,
           c.customer_name,
           c.city,
           SUM(oi.quantity * oi.unit_price) AS revenue,
           ROW_NUMBER() OVER (
               PARTITION BY c.city
               ORDER BY SUM(oi.quantity * oi.unit_price) DESC
           ) AS rn
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name, c.city
) AS t
WHERE rn = 1;

-- 97.Find the most sold product in every category.

SELECT product_name, category, total_quantity
FROM (
    SELECT p.product_name,
           p.category,
           SUM(oi.quantity) AS total_quantity,
           ROW_NUMBER() OVER (
               PARTITION BY p.category
               ORDER BY SUM(oi.quantity) DESC
           ) AS rn
    FROM products p
    JOIN order_items oi
    ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category
) AS t
WHERE rn = 1;

-- 98.Find products purchased together most frequently.

SELECT 
    p1.product_name AS product1,
    p2.product_name AS product2,
    COUNT(*) AS times_purchased_together
FROM order_items oi1
JOIN order_items oi2
    ON oi1.order_id = oi2.order_id
   AND oi1.product_id < oi2.product_id
JOIN products p1
    ON oi1.product_id = p1.product_id
JOIN products p2
    ON oi2.product_id = p2.product_id
GROUP BY oi1.product_id, oi2.product_id,
         p1.product_name, p2.product_name
ORDER BY times_purchased_together DESC
LIMIT 1;

-- 99.Find customers who have ordered on consecutive days.

SELECT DISTINCT customer_name
FROM (
    SELECT c.customer_name,
           o.order_date,
           LAG(o.order_date) OVER (
               PARTITION BY c.customer_id
               ORDER BY o.order_date
           ) AS previous_order_date
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
) AS t
WHERE DATEDIFF(order_date, previous_order_date) = 1;

-- 100.Find the longest gap between two orders for every customer.
SELECT customer_name,
       MAX(gap_days) AS longest_gap
FROM (
    SELECT c.customer_name,
           DATEDIFF(
               o.order_date,
               LAG(o.order_date) OVER (
                   PARTITION BY c.customer_id
                   ORDER BY o.order_date
               )
           ) AS gap_days
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
) AS t
GROUP BY customer_name;