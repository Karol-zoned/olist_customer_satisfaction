--OLIST ORDERS 

exec sp_help 'olist_orders';
--NUMBER OF ROWS AND UNIQUE ROWS
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_rows
FROM olist_orders;

 --CHECKING FOR MISSING VALUES
SELECT COUNT(*) as missing_status
FROM olist_orders
WHERE order_status IS NULL;

SELECT COUNT(*) as missing_customer_del_date
FROM olist_orders
WHERE order_status = 'delivered' and
order_delivered_customer_date is null;

SELECT COUNT(*) as missing_carrier_del_date
FROM olist_orders
WHERE order_status = 'delivered' and
order_delivered_carrier_date is null;

SELECT COUNT(*) as missing_del_date
FROM olist_orders
WHERE order_status = 'delivered' and
order_delivered_customer_date is null and order_delivered_carrier_date is null;

SELECT COUNT(*) as missing_approval_date
FROM olist_orders
WHERE order_status <> 'delivered' and
order_approved_at is null;


--ORDER STATUS AND COUNTS
SELECT order_status,
count(*) as total
FROM olist_orders
group by order_status;

--DESCRIPTIVE STATS
--DELIVERED ORDERS BY CARRIER DATE
SELECT COUNT(*) as delivered_orders,
AVG(delivery_time) avg_delivery_time,
MIN(delivery_time) min_delivery_time,
MAX(delivery_time) max_delivery_time
FROM
(SELECT datediff("day", order_approved_at,order_delivered_customer_date) delivery_time
FROM olist_orders
WHERE order_status = 'delivered' AND
order_approved_at is not null and
order_delivered_customer_date is not null)t;

--DELIVERED ORDERS BY CUSTOMER DATE
SELECT COUNT(*) as delivered_orders,
AVG(delivery_time) avg_delivery_time,
MIN(delivery_time) min_delivery_time,
MAX(delivery_time) max_delivery_time
FROM
(SELECT datediff("day", order_purchase_timestamp,order_delivered_customer_date) delivery_time
FROM olist_orders
WHERE order_status = 'delivered' AND
order_approved_at is not null and
order_delivered_customer_date is not null)t;


-- Detect impossible delivery times
select * from olist_orders where datediff("day",order_approved_at,order_delivered_customer_date) < 0;

--checking the distribution, working on dates so the dates are split into categories
--CHECKING THE DISTRIBUTION, SINCE IM WORKING ON DATES I SPLIT THEM INTO CATEGORIES
SELECT 
CASE
    WHEN delivery_time <= 3 THEN '0-3 days'
    WHEN delivery_time <= 7 THEN '4-7 days'
    WHEN delivery_time <= 14 THEN '8-14 days'
    WHEN delivery_time <= 22 THEN '15-22 days'
    ELSE '22+ days'
END as delivery_time_cat,
COUNT(*) as total
FROM 
(SELECT datediff("day", order_approved_at,order_delivered_customer_date) delivery_time
FROM olist_orders
WHERE order_status = 'delivered' AND
order_approved_at is not null and
order_delivered_customer_date is not null)t
GROUP BY 
CASE
    WHEN delivery_time <= 3 THEN '0-3 days'
    WHEN delivery_time <= 7 THEN '4-7 days'
    WHEN delivery_time <= 14 THEN '8-14 days'
    WHEN delivery_time <= 22 THEN '15-22 days'
    ELSE '22+ days'
END
ORDER BY MIN(delivery_time);

-- Preliminary outlier inspection
-- Formal outlier detection (IQR) will be performed in Python

SELECT TOP 20 *
FROM
(SELECT datediff("day", order_approved_at,order_delivered_customer_date) delivery_time
FROM olist_orders
WHERE order_status = 'delivered' AND
order_approved_at is not null and
order_delivered_customer_date is not null)t
ORDER BY delivery_time desc;

SELECT TOP 20 *
FROM
(SELECT datediff("day", order_approved_at,order_delivered_customer_date) delivery_time
FROM olist_orders
WHERE order_status = 'delivered' AND
order_approved_at is not null and
order_delivered_customer_date is not null)t
ORDER BY delivery_time asc;


-----------------------------------------------------------------------------------------------------
--OLIST CUSTOMERS

--NUMBER OF ROWS AND UNIQUE ROWS
exec sp_help 'olist_customers';
SELECT 
    COUNT(*) total_rows,
    COUNT(DISTINCT customer_id) AS unique_rows
FROM dbo.olist_customers;

--CHECKING FOR MISSING VALUES

SELECT count(*) as missing_city
from olist_customers
where customer_city is null;

SELECT count(*) as missing_state
from olist_customers
where customer_state is null;

SELECT count(*) as missing_zip
from olist_customers
where customer_zip_code_prefix is null;


--customer state distribution
select customer_state,
count(*) state_customers
from olist_customers
group by customer_state
order by state_customers desc;

select top 20 customer_city,
count(*) city_customers
from olist_customers
group by customer_city
order by city_customers desc;

--counting cities and states
select count(distinct customer_state)number_states from olist_customers; --26 states and one federal district
select count(distinct customer_city)city_numbers from olist_customers;

-----------------------------------------------------------------------
--OLIST_ORDER_ITEMS

exec sp_help 'dbo.olist_order_items';
SELECT
(SELECT COUNT(*) FROM dbo.olist_order_items) total_rows,
(SELECT COUNT(*) AS unique_combin
FROM (SELECT DISTINCT
order_id,
order_item_id
FROM dbo.olist_order_items) as distinct_pairs) unique_pairs;

--olist_order_reviews

exec sp_help 'dbo.olist_order_reviews';
SELECT
(SELECT COUNT(*) FROM dbo.olist_order_reviews) total_rows,
(SELECT COUNT(*) AS unique_combin
FROM (SELECT DISTINCT
review_id,
order_id
FROM dbo.olist_order_reviews) as distinct_pairs) unique_pairs;

--olist_order_payments

exec sp_help 'dbo.olist_order_payments';
SELECT 
(SELECT COUNT(*) FROM dbo.olist_order_payments) total_rows,
(SELECT COUNT (*) FROM
(SELECT DISTINCT order_id, payment_sequential
FROM dbo.olist_order_payments
GROUP BY order_id, payment_sequential) as distinct_pairs) unique_pairs;

--olist_products

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_rows
FROM olist_products;

SELECT
    COUNT(*) AS missing_product_category
FROM olist_products
WHERE product_category_name IS NULL;

--olist_sellers

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_rows
FROM olist_sellers;

