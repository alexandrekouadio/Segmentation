CREATE TABLE "products" (
	"product_id"	TEXT,
	"product_category_name"	TEXT,
	"product_name_lenght"	REAL,
	"product_description_lenght"	REAL,
	"product_photos_qty"	REAL,
	"product_weight_g"	REAL,
	"product_length_cm"	REAL,
	"product_height_cm"	REAL,
	"product_width_cm"	REAL,
	"product_category_name_english"	TEXT,
	PRIMARY KEY("product_id")
)
;
CREATE TABLE "items" (
	"order_id"	TEXT NOT NULL,
	"order_item_id"	INTEGER,
	"product_id"	TEXT,
	"seller_id"	TEXT,
	"shipping_limit_date"	TEXT,
	"price"	REAL,
	"freight_value"	REAL,
	FOREIGN KEY("order_id") REFERENCES "orders"("order_id"),
	FOREIGN KEY("product_id") REFERENCES "products"("product_id")

)

CREATE TABLE "orders" (
	"order_id"	TEXT NOT NULL,
	"customer_id"	TEXT, NOT NULL,
	"order_status"	TEXT,
	"order_purchase_timestamp"	TEXT,
	"order_approved_at"	TEXT,
	"order_delivered_carrier_date"	TEXT,
	"order_delivered_customer_date"	TEXT,
	"order_estimated_delivery_date"	TEXT
	PRIMARY KEY("order_id"),
	FOREIGN KEY("customer_id") REFERENCES "customer"("customer_id")
)


CREATE TABLE "customer" (
	"customer_id"	TEXT NOT NULL,
	"customer_unique_id"  TEXT,
	"customer_zip_code_prefix"	INTEGER,
	"customer_city"	TEXT,
	"customer_state"	TEXT,
	PRIMARY KEY("customer_id")
)

## CUSTOMERS

### 2.1. Amout of Sales by customers 
SELECT orders.customer_id, ROUND(SUM(items.price + items.freight_value),3) AS sales
FROM orders
INNER JOIN items 
ON items.order_id = orders.order_id
GROUP BY 
customer_id

### 2.2. Top customers by Amount of Sales

SELECT orders.customer_id, SUM(items.price + items.freight_value) AS sales
FROM orders
INNER JOIN items 
ON items.order_id = orders.order_id
GROUP BY 
customer_id
ORDER BY sales DESC

### Numbers of articles by customers

SELECT orders.customer_id, SUM(order_item_id) AS order_nb
FROM orders
INNER JOIN items 
ON items.order_id = orders.order_id
GROUP BY 
customer_id

### Numbers of orders by customers
SELECT orders.customer_id, SUM(order_item_id) AS order_nb
FROM orders
INNER JOIN items 
ON items.order_id = orders.order_id
GROUP BY 
customer_id
ORDER BY order_nb DESC

### Number of customer by state
SELECT customer_state,  COUNT(customer_id) AS nb_customer
FROM customer 
GROUP BY customer_state

### 3. Numbers of repeaters 
SELECT orders.customer_id, COUNT(items.order_id) as nb_orders 
FROM orders
INNER JOIN items ON orders.order_id = items.order_id 
GROUP BY customer_id
HAVING  nb_orders > 1

## sales
### 1. Average_ BASKET
SELECT  products.product_category_name, ROUND(AVG(items.price + items.freight_value), 2) AS avg_basket
FROM items 
INNER JOIN products ON items.product_id = products.product_id
GROUP BY products.product_category_name
ORDER BY avg_basket DESC 

### 2. Most popular product
SELECT product_category_name, COUNT(product_category_name) AS most_product
FROM products
GROUP BY product_category_name
ORDER BY most_product DESC 

### 3. what products