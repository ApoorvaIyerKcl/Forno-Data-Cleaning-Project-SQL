USE restaurant_sales;
DROP TABLE menu_items;
CREATE TABLE menu_items( 
 menu_item_id VARCHAR(10),
 menu_item_name VARCHAR (50),
 menu_category VARCHAR (50),
 veg_non_veg_flag VARCHAR (50),
 sauce_base	VARCHAR (50),
 pasta_type VARCHAR (50),
 base_selling_price DECIMAL (10,2),
 is_chef_special VARCHAR (50),
 is_seasonal VARCHAR (50),
 is_active VARCHAR (50)
 );

LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/RS- menu_items.csv'
INTO TABLE menu_items
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;


DROP TABLE bills;
CREATE TABLE bills(
bill_id VARCHAR (50),
customer_id VARCHAR (50),
restaurant_location VARCHAR (50),
order_date TEXT,
order_time TIME,
day_name VARCHAR (50),
month_name VARCHAR (50),
quarter VARCHAR (50),
service_time_bucket VARCHAR (50),
order_type VARCHAR (50),
payment_method VARCHAR (50),
order_status VARCHAR (50),
refund_reason VARCHAR (50),
total_quantity_ordered INT,
bill_subtotal_amount DECIMAL (10,2),
tax_amount DECIMAL (10,2),
total_bill_amount DECIMAL (10,2)
);

LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/RS- bills.csv'
INTO TABLE bills
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;


SELECT * FROM bills_duplicate1; 
UPDATE bills_duplicate1
SET order_date = DATE_FORMAT(STR_TO_DATE(order_date, '%Y-%m-%d'), '%d-%m-%Y')
WHERE order_date IS NOT NULL AND order_date <> '';


UPDATE bills_duplicate1
SET DATE_FORMAT(order_date, '%d-%m-%Y') AS order_date;
FROM bills_duplicate1;



DROP TABLE bill_items;
CREATE TABLE bill_items(
order_item_id VARCHAR (50),
bill_id VARCHAR (50),
restaurant_location VARCHAR (50),
menu_item_id VARCHAR (50),
menu_category VARCHAR (50),
quantity_ordered INT,
unit_selling_price DECIMAL (10,2),
item_subtotal_amount INT,
preparation_time_minutes INT,
item_notes VARCHAR (50),
beverage_temperature VARCHAR (50)
);

LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/RS- bill_items.csv'
INTO TABLE bill_items
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- CREATE DUPLICATE TABLES

-- TABLE bill_items
SELECT * FROM bill_items;
CREATE TABLE bill_items_duplicate
LIKE bill_items;

INSERT bill_items_duplicate
SELECT * FROM bill_items;

-- TABLE billS

SELECT * FROM bills;
CREATE TABLE bills_duplicate
LIKE bills;

INSERT bills_duplicate
SELECT * FROM bills;

SELECT * FROM bills_duplicate;

-- TABLE menu_items

CREATE TABLE menu_items_duplicate
LIKE menu_items;

INSERT menu_items_duplicate
SELECT * FROM menu_items;

SELECT * FROM menu_items_duplicate;
SELECT * FROM bill_items_duplicate;

-- FINDING and REMOVING DUPLICATES

-- Finding and removing DUPLICATES from bill_items_duplicate

SELECT * FROM bill_items_duplicate;

SELECT * FROM ( SELECT *, ROW_NUMBER() OVER ( PARTITION BY order_item_id, bill_id, restaurant_location, menu_item_id, menu_category,
quantity_ordered, unit_selling_price, item_subtotal_amount, preparation_time_minutes, item_notes, beverage_temperature) AS row_number_value
FROM bill_items_duplicate) AS rank_value
WHERE row_number_value > 1;

CREATE TABLE `bill_items_duplicate1` (
  `order_item_id` varchar(50) DEFAULT NULL,
  `bill_id` varchar(50) DEFAULT NULL,
  `restaurant_location` varchar(50) DEFAULT NULL,
  `menu_item_id` varchar(50) DEFAULT NULL,
  `menu_category` varchar(50) DEFAULT NULL,
  `quantity_ordered` int DEFAULT NULL,
  `unit_selling_price` decimal(10,2) DEFAULT NULL,
  `item_subtotal_amount` int DEFAULT NULL,
  `preparation_time_minutes` int DEFAULT NULL,
  `item_notes` varchar(50) DEFAULT NULL,
  `beverage_temperature` varchar(50) DEFAULT NULL,
  `row_number_value` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * FROM bill_items_duplicate;
SELECT * FROM bill_items_duplicate1;

INSERT INTO  bill_items_duplicate1
SELECT *, 
ROW_NUMBER () OVER (
PARTITION BY order_item_id, bill_id, restaurant_location, menu_item_id, menu_category, quantity_ordered, unit_selling_price, 
item_subtotal_amount, preparation_time_minutes, item_notes, beverage_temperature) AS row_number_value 
FROM bill_items_duplicate;

SELECT * FROM bill_items_duplicate1
WHERE row_number_value >1;

DELETE 
FROM bill_items_duplicate1
WHERE row_number_value >1;

-- Finding and removing DUPLICATES from bills_duplicate

SELECT * FROM ( SELECT *, ROW_NUMBER () OVER (PARTITION BY bill_id, customer_id, restaurant_location, order_date, order_time, day_name, 
month_name, quarter, service_time_bucket, order_type, payment_method, order_status, refund_reason, total_quantity_ordered, bill_subtotal_amount,
tax_amount, total_bill_amount) AS row_number_value FROM bills_duplicate) bills_rank
WHERE row_number_value >1;

CREATE TABLE `bills_duplicate2` (
  `bill_id` varchar(50) NOT NULL,
  `customer_id` varchar(50) DEFAULT NULL,
  `restaurant_location` varchar(50) DEFAULT NULL,
  `order_date` text,
  `order_time` time DEFAULT NULL,
  `day_name` varchar(50) DEFAULT NULL,
  `month_name` varchar(50) DEFAULT NULL,
  `quarter` varchar(50) DEFAULT NULL,
  `service_time_bucket` varchar(50) DEFAULT NULL,
  `order_type` varchar(50) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `order_status` varchar(50) DEFAULT NULL,
  `refund_reason` varchar(50) DEFAULT NULL,
  `total_quantity_ordered` int DEFAULT NULL,
  `bill_subtotal_amount` decimal(10,2) DEFAULT NULL,
  `tax_amount` decimal(10,2) DEFAULT NULL,
  `total_bill_amount` decimal(10,2) DEFAULT NULL,
  `row_number_value` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO bills_duplicate2
SELECT *, ROW_NUMBER () OVER (PARTITION BY bill_id, customer_id, restaurant_location, order_date, order_time, day_name, 
month_name, quarter, service_time_bucket, order_type, payment_method, order_status, refund_reason, total_quantity_ordered, bill_subtotal_amount,
tax_amount, total_bill_amount) AS row_number_value FROM bills_duplicate;

ALTER TABLE bills_duplicate2 RENAME bills_duplicate1;

SELECT * FROM bills_duplicate1;

DELETE 
FROM bills_duplicate1
WHERE row_number_value >1;


-- Finding and removing DUPLICATES from menu_items_duplicate

SELECT * FROM ( SELECT *, ROW_NUMBER () OVER (PARTITION BY menu_item_id, menu_item_name, menu_category, veg_non_veg_flag, sauce_base, pasta_type, base_selling_price, 
is_chef_special, is_seasonal, is_active) AS row_number_value FROM menu_items_duplicate) rank_value
WHERE row_number_value >1;

SELECT * FROM menu_items_duplicate;

-- STANDARDISING DATA

-- Standardising data for bill_items_duplicate1
SELECT * FROM bill_items_duplicate1;

UPDATE bill_items_duplicate1 
SET order_item_id = COALESCE(order_item_id, 'Not Available'), 
bill_id = COALESCE(bill_id, 'Not Available'), 
restaurant_location = COALESCE(LOWER(NULLIF(TRIM(restaurant_location), '')), 'Not Available'), 
menu_item_id = COALESCE(LOWER(NULLIF(TRIM(menu_item_id), '')), 'Not Available'), 
menu_category = COALESCE(LOWER(NULLIF(TRIM(menu_category), '')), 'Not Available'), 
quantity_ordered = COALESCE(quantity_ordered, 0), 
unit_selling_price = COALESCE(unit_selling_price, 0), 
item_subtotal_amount = COALESCE(item_subtotal_amount, 0),
preparation_time_minutes = COALESCE(preparation_time_minutes, 0), 
item_notes = COALESCE(LOWER(NULLIF(TRIM(item_notes), '')), 'Not Available'), 
beverage_temperature = COALESCE(LOWER(NULLIF(TRIM(beverage_temperature), '')), 'Not Available');


-- Standardising data for bills_duplicate1
SELECT * FROM bills_duplicate1;


UPDATE bills_duplicate1 
SET bill_id = COALESCE(bill_id, 'Not Available'), 
customer_id = COALESCE(customer_id, 'Not Available'),
restaurant_location = COALESCE(LOWER(NULLIF(TRIM(restaurant_location), '')), 'Not Available'), 
order_date = COALESCE(order_date, NULL), 
order_time = COALESCE(order_time, NULL), 
day_name = COALESCE(LOWER(NULLIF(TRIM(day_name), '')), 'Not Available'),
month_name = COALESCE(LOWER(NULLIF(TRIM(month_name), '')), 'Not Available'), 
quarter = COALESCE(LOWER(NULLIF(TRIM(quarter), '')), 'Not Available'), 
service_time_bucket = COALESCE(LOWER(NULLIF(TRIM(service_time_bucket), '')), 'Not Available'), 
order_type = COALESCE(LOWER(NULLIF(TRIM(order_type), '')), 'Not Available'), 
payment_method = COALESCE(LOWER(NULLIF(TRIM(payment_method), '')), 'Not Available'), 
order_status = COALESCE(LOWER(NULLIF(TRIM(order_status), '')), 'Not Available'), 
refund_reason = COALESCE(LOWER(NULLIF(TRIM(refund_reason), '')), 'Not Available'), 
total_quantity_ordered = COALESCE(total_quantity_ordered, NULL), 
bill_subtotal_amount = COALESCE(bill_subtotal_amount, NULL), 
tax_amount = COALESCE(tax_amount, NULL), total_bill_amount = COALESCE(total_bill_amount, NULL);

-- Standardising data for menu_items_duplicate
SELECT * FROM menu_items_duplicate;

UPDATE menu_items_duplicate 
SET menu_item_id = COALESCE(menu_item_id, 'Not Available'), 
menu_item_name = COALESCE(LOWER(NULLIF(TRIM(menu_item_name), '')), 'Not Available'), 
menu_category = COALESCE(LOWER(NULLIF(TRIM(menu_category), '')), 'Not Available'), 
veg_non_veg_flag = COALESCE(LOWER(NULLIF(TRIM(veg_non_veg_flag), '')), 'Not Available'), 
sauce_base = COALESCE(LOWER(NULLIF(TRIM(sauce_base), '')), 'Not Available'), 
pasta_type = COALESCE(LOWER(NULLIF(TRIM(pasta_type), '')), 'Not Available'), 
base_selling_price = COALESCE(base_selling_price, 0), 
is_chef_special = COALESCE(is_chef_special, FALSE),
is_seasonal = COALESCE(is_seasonal, FALSE),
is_active = COALESCE(is_active, FALSE);

-- DATA QUAITY VERIFICATION

-- Verification for bill_items_duplicate1

SELECT * FROM bill_items_duplicate1;

SELECT COUNT(*) AS rows_with_issues
FROM bill_items_duplicate1
WHERE order_item_id IS NULL
OR bill_id IS NULL
OR restaurant_location IS NULL OR TRIM(restaurant_location) = ''
OR menu_item_id IS NULL OR TRIM(menu_item_id) = ''
OR menu_category IS NULL OR TRIM(menu_category) = ''
OR quantity_ordered IS NULL
OR unit_selling_price IS NULL
OR item_subtotal_amount IS NULL
OR preparation_time_minutes IS NULL
OR item_notes IS NULL
OR beverage_temperature IS NULL;

-- Verification for bills_duplicate1
SELECT * FROM bills_duplicate1;
SELECT COUNT(*) AS rows_with_issues
FROM bills_duplicate1
WHERE bill_id IS NULL
OR customer_id IS NULL
OR restaurant_location IS NULL OR TRIM(restaurant_location) = ''
OR order_date IS NULL
OR order_time IS NULL
OR day_name IS NULL OR TRIM(day_name) = ''
OR month_name IS NULL OR TRIM(month_name) = ''
OR quarter IS NULL OR TRIM(quarter) = ''
OR service_time_bucket IS NULL OR TRIM(service_time_bucket) = ''
OR order_type IS NULL OR TRIM(order_type) = ''
OR payment_method IS NULL OR TRIM(payment_method) = ''
OR order_status IS NULL OR TRIM(order_status) = ''
OR refund_reason IS NULL OR TRIM(refund_reason) = ''
OR total_quantity_ordered IS NULL
OR bill_subtotal_amount IS NULL
OR tax_amount IS NULL
OR total_bill_amount IS NULL;

-- Verification for menu_items_duplicate
SELECT * FROM menu_items_duplicate;
SELECT COUNT(*) AS rows_with_issues
FROM menu_items_duplicate
WHERE menu_item_id IS NULL OR TRIM(menu_item_id) = ''
OR menu_item_name IS NULL OR TRIM(menu_item_name) = ''
OR menu_category IS NULL OR TRIM(menu_category) = ''
OR veg_non_veg_flag IS NULL OR TRIM(veg_non_veg_flag) = ''
OR sauce_base IS NULL OR TRIM(sauce_base) = ''
OR pasta_type IS NULL OR TRIM(pasta_type) = '';

SELECT * FROM bills_duplicate1;
SELECT * FROM bill_items_duplicate1;
SELECT * FROM menu_items_duplicate;
