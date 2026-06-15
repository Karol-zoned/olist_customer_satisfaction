CREATE DATABASE Olist;

USE Olist;

SELECT TOP 10 * FROM dbo.olist_orders;
EXEC sp_help 'dbo.olist_orders';

SELECT TOP 10 * FROM dbo.olist_customers;
EXEC sp_help 'dbo.olist_customers';

SELECT count(distinct(customer_id)) from dbo.olist_customers;
SELECT count(distinct(customer_unique_id)) from dbo.olist_customers;-- checking which one is a better choice for the primary key, ultimately customer_id

--checking for NULLs and duplicates
SELECT customer_id, count(*) total from dbo.olist_customers group by customer_id Having count(*) > 1; -- no dupes
SELECT count(*) as nulls from dbo.olist_customers where customer_id IS NULL;
--no dupes or nulls, can be a PK

ALTER TABLE dbo.olist_customers
ADD CONSTRAINT PK_olist_customers
PRIMARY KEY (customer_id);

SELECT TOP 10 * FROM dbo.olist_products;
EXEC sp_help 'dbo.olist_products';

select distinct product_photos_qty from dbo.olist_products;

ALTER TABLE dbo.olist_products
ALTER COLUMN product_photos_qty INT;

SELECT TOP 10 * FROM dbo.olist_sellers;
EXEC sp_help 'dbo.olist_sellers';

SELECT TOP 10 * FROM dbo.olist_order_items;
EXEC sp_help 'dbo.olist_order_items';
SELECT order_id from dbo.olist_order_items where order_id is null;
SELECT order_item_id from dbo.olist_order_items where order_item_id is null;

Alter table dbo.olist_order_items
add constraint PK_order_items
primary key (order_id, order_item_id);


SELECT TOP 10 * FROM dbo.olist_order_payments;
EXEC sp_help 'dbo.olist_order_payments';

SELECT
    order_id,
    payment_sequential,
    COUNT(*)
FROM dbo.olist_order_payments
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;

Alter table dbo.olist_order_payments
add constraint PK_order_payments
primary key (order_id, payment_sequential);


EXEC sp_rename 'dbo.[dbo.olist_order_reviews]', 'olist_order_reviews';

SELECT TOP 10 * FROM dbo.olist_order_reviews;
EXEC sp_help 'dbo.olist_order_reviews';
select * from dbo.olist_order_reviews where review_id is null;

select review_id, count(*) from dbo.olist_order_reviews group by review_id having count(*) > 1;

SELECT
    COUNT(*) AS rows_count,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM dbo.olist_order_reviews;


ALTER TABLE dbo.olist_order_reviews
ADD CONSTRAINT PK_order_reviews
PRIMARY KEY (review_id, order_id);

SELECT TOP 10 * FROM dbo.olist_geolocation;
EXEC sp_help 'dbo.olist_geolocation';

select count(*) from dbo.olist_geolocation;
select count(*) from (select distinct geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state from dbo.olist_geolocation)x;

SELECT
    geolocation_zip_code_prefix,
    AVG(geolocation_lat) AS avg_lat,
    AVG(geolocation_lng) AS avg_lng,
    MIN(geolocation_city) AS city,
    MIN(geolocation_state) AS state
INTO dim_geolocation_zip
FROM dbo.olist_geolocation
GROUP BY geolocation_zip_code_prefix;

ALTER TABLE dim_geolocation_zip
ADD CONSTRAINT PK_dim_geolocation_zip
PRIMARY KEY (geolocation_zip_code_prefix);

SELECT TOP 10 * FROM dbo.product_category_name_translation;
EXEC sp_help 'dbo.product_category_name_translation';

SELECT count(*) from dbo.product_category_name_translation;
select count(*) from (select distinct original from dbo.product_category_name_translation)x;
alter table dbo.product_category_name_translation
add constraint PK_product_category
primary key (original);

EXEC sp_rename 'dbo.product_category_name_translation.column1', 'original', 'COLUMN';
EXEC sp_rename 'dbo.product_category_name_translation.column2', 'translation', 'COLUMN';

SELECT
    order_id,
    COUNT(*) AS review_count,
    COUNT(DISTINCT review_id) AS distinct_reviews,
    MIN(review_score) AS min_score,
    MAX(review_score) AS max_score
FROM dbo.olist_order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_count DESC;

SELECT
    (SELECT COUNT(*) FROM dbo.olist_order_reviews) AS all_rows,
    (SELECT COUNT(*)
     FROM (
        SELECT DISTINCT order_id, review_id
        FROM dbo.olist_order_reviews
     ) AS unique_pairs
    ) AS unique_order_review_pairs;

SELECT *
FROM dbo.olist_order_reviews
WHERE review_id IN (
    SELECT review_id
    FROM dbo.olist_order_reviews
    GROUP BY review_id
    HAVING COUNT(DISTINCT order_id) > 1
)
ORDER BY review_id, order_id;

SELECT
    review_id,
    COUNT(DISTINCT order_id) AS orders_count,
    COUNT(DISTINCT review_score) AS score_versions,
    COUNT(DISTINCT review_comment_message) AS comment_versions,
    MIN(review_creation_date) AS first_review_date,
    MAX(review_creation_date) AS last_review_date
FROM dbo.olist_order_reviews
GROUP BY review_id
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY orders_count DESC;

SELECT *
FROM dbo.olist_order_reviews
WHERE review_id = '08528f70f579f0c830189efc523d2182';

SELECT r.*, o.customer_id
FROM dbo.olist_order_reviews as r
LEFT JOIN dbo.olist_orders as o
ON r.order_id = o.order_id
WHERE review_id = '08528f70f579f0c830189efc523d2182'; -- one review has different order_id and customer_id in every instance

SELECT
    COUNT(*) AS rows_count,
    COUNT(DISTINCT review_id) AS distinct_review_ids,
    COUNT(DISTINCT order_id) AS distinct_order_ids
FROM dbo.olist_order_reviews;

SELECT
    COUNT(*)
FROM (
    SELECT review_id
    FROM dbo.olist_order_reviews
    GROUP BY review_id
    HAVING COUNT(DISTINCT order_id) > 1
) x; /*There are 789 cases of a single review having multiple order_id assigned to it.
Since this represents a small fraction of the dataset, analyses were performed at the order level.*/

SELECT
    COUNT(*) AS orders_without_review
FROM dbo.olist_orders o
LEFT JOIN dbo.olist_order_reviews r
    ON o.order_id = r.order_id
WHERE r.order_id IS NULL;