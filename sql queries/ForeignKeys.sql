USE Olist;

--assigning foreign keys

SELECT TOP 10 * FROM dbo.olist_customers;
SELECT TOP 10 * FROM dbo.olist_order_items;
SELECT TOP 10 * FROM dbo.olist_order_payments;
SELECT TOP 10 * FROM dbo.olist_order_reviews;
SELECT TOP 10 * FROM dbo.olist_orders;
SELECT TOP 10 * FROM dbo.olist_products;
SELECT TOP 10 * FROM dbo.olist_sellers;
SELECT top 10 * from dbo.product_category_name_translation;

ALTER TABLE dbo.olist_orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES dbo.olist_customers (customer_id);

ALTER TABLE dbo.olist_order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES dbo.olist_orders (order_id);

ALTER TABLE dbo.olist_order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id)
REFERENCES dbo.olist_products (product_id);

ALTER TABLE dbo.olist_order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES dbo.olist_sellers (seller_id);

ALTER TABLE dbo.olist_order_payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES dbo.olist_orders (order_id);

ALTER TABLE dbo.olist_order_reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES dbo.olist_orders (order_id);

