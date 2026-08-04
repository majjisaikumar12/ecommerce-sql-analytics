# E-Commerce SQL Analytics

A MySQL project analyzing a relational e-commerce database through 100 progressively advanced SQL queries — from basic filtering to window functions and analytics.

## Overview

The project models a typical e-commerce system with customers, products, orders, and order line items, then explores it through queries covering filtering, aggregation, joins, subqueries, and window functions (ranking, running totals, lead/lag).

## Schema

| Table | Description |
|---|---|
| `Customers` | customer_id, customer_name, gender, city, signup_date |
| `Products` | product_id, product_name, category, price |
| `Orders` | order_id, customer_id, order_date, order_status |
| `Order_Items` | order_item_id, order_id, product_id, quantity, unit_price |

**Relationships:** `Orders.customer_id → Customers.customer_id`, `Order_Items.order_id → Orders.order_id`, `Order_Items.product_id → Products.product_id`

## Queries (100, by level)

| Level | Range | Focus |
|---|---|---|
| 🟢 Basic | 1–15 | Filtering, sorting, aggregate basics |
| 🟡 Intermediate | 16–40 | Joins, GROUP BY, HAVING, subqueries |
| 🟠 Advanced | 41–80 | Multi-table joins, correlated subqueries, business metrics |
| 🔵 Window Functions & Analytics | 81–100 | RANK/DENSE_RANK, running totals, LAG/LEAD, top-N per group |

Sample questions include: finding customers who never placed an order, ranking customers by spending, computing running revenue by date, finding products frequently purchased together, and calculating each customer's percentage contribution to total revenue.

## Tech Stack

- MySQL
- Window functions (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `LEAD`)
- CTEs / derived tables, `GROUP BY`/`HAVING`, correlated subqueries

## Usage

```bash
mysql -u root -p < schema.sql
mysql -u root -p ecommerce_db < queries.sql
```

## Files

- `schema.sql` — database and table definitions
- `queries.sql` — all 100 queries, organized by level

## Author

Saikumar — B.Tech ECE, Pragati Engineering College
