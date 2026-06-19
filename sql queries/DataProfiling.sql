--olist_orders 

SELECT
    COUNT(*) AS rows_count,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM olist_orders;

SELECT 
    COUNT(*) rows_count,
    COUNT(DISTINCT customer_id) AS distinct_orders
FROM dbo.olist_customers;

SELECT COUNT(*) rows_count
FROM dbo.olist_order_items;

SELECT COUNT(*) rows_count
FROM dbo.olist_order_reviews;

SELECT COUNT(*) rows_count
FROM dbo.olist_order_payments;

SELECT COUNT(*) rows_count
FROM dbo.olist_products;

SELECT COUNT(*) rows_count
FROM dbo.olist_sellers;