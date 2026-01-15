USE restaurant_sales;
DROP TABLE menu_items;
CREATE TABLE menu_items( 
 menu_item_id VARCHAR(10) PRIMARY KEY,
 menu_item_name VARCHAR (50),
 menu_category VARCHAR (50),
 veg_non_veg_flag VARCHAR (50),
 sauce_base	VARCHAR (50),
 pasta_type VARCHAR (50),
 base_selling_price DECIMAL (10,2),
 is_chef_special BOOLEAN,
 is_seasonal BOOLEAN,
 is_active BOOLEAN
 );

DROP TABLE bills;
CREATE TABLE bills(
bill_id INT PRIMARY KEY,
customer_id INT,
restaurant_location VARCHAR (50),
order_date DATE,
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

DROP TABLE bill_items;
CREATE TABLE bill_items(
order_item_id INT,
bill_id INT,
restaurant_location VARCHAR (50),
menu_item_id VARCHAR (50) PRIMARY KEY,
menu_category VARCHAR (50),
quantity_ordered INT,
unit_selling_price DECIMAL (10,2),
item_subtotal_amount INT,
preparation_time_minutes INT,
item_notes INT,
beverage_temperature DECIMAL (10,2)
);


--CREATE DUPLICATE TABLES--
TABLE 1
SELECT * FROM bill_items;
CREATE TABLE bill_items_duplicate
LIKE bill_items;

INSERT bill_items_duplicate
SELECT * FROM bill_items;

TABLE 2
SELECT * FROM bills;
CREATE TABLE bills_duplicate
LIKE bills;

INSERT bills_duplicate
SELECT * FROM bills;

SELECT * FROM bills_duplicate;

TABLE 3
CREATE TABLE menu_items_duplicate
LIKE menu_items;

INSERT menu_items_duplicate
SELECT * FROM menu_items;

---FINDING and REMOVING DUPLICATES---

--Finding and removing DUPLICATES from bill_items_duplicate--

SELECT * FROM (
SELECT *, ROW_NUMBER () OVER (PARTITION BY order_item_id, bill_id, restaurant_location, menu_item_id, menu_category, quantity_ordered, unit_selling_price, 
item_subtotal_amount, preparation_time_minutes, item_notes, beverage_temperature) AS row_number_value FROM bill_items_duplicate) rank_value
WHERE row_number_value >1; 

CREATE TABLE `bill_items_duplicate1` (
  `order_item_id` text,
  `bill_id` text,
  `restaurant_location` text,
  `menu_item_id` text,
  `menu_category` text,
  `quantity_ordered` int DEFAULT NULL,
  `unit_selling_price` int DEFAULT NULL,
  `item_subtotal_amount` int DEFAULT NULL,
  `preparation_time_minutes` int DEFAULT NULL,
  `item_notes` text,
  `beverage_temperature` text,
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

--- Finding and removing DUPLICATES from bills_duplicate---

SELECT * FROM ( SELECT *, ROW_NUMBER () OVER (PARTITION BY bill_id, customer_id, restaurant_location, order_date, order_time, day_name, 
month_name, quarter, service_time_bucket, order_type, payment_method, order_status, refund_reason, total_quantity_ordered, bill_subtotal_amount,
tax_amount, total_bill_amount) AS row_number_value FROM bills_duplicate) bills_rank
WHERE row_number_value >1;

CREATE TABLE `bills_duplicate2` (
  `bill_id` text,
  `customer_id` text,
  `restaurant_location` text,
  `order_date` text,
  `order_time` text,
  `day_name` text,
  `month_name` text,
  `quarter` text,
  `service_time_bucket` text,
  `order_type` text,
  `payment_method` text,
  `order_status` text,
  `refund_reason` text,
  `total_quantity_ordered` int DEFAULT NULL,
  `bill_subtotal_amount` int DEFAULT NULL,
  `tax_amount` double DEFAULT NULL,
  `total_bill_amount` double DEFAULT NULL,
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

--Finding and removing DUPLICATES from menu_items_duplicate--

SELECT * FROM ( SELECT *, ROW_NUMBER () OVER (PARTITION BY menu_item_id, menu_item_name, menu_category, veg_non_veg_flag, sauce_base, pasta_type, base_selling_price, 
is_chef_special, is_seasonal, is_active) AS row_number_value FROM menu_items_duplicate) rank_value
WHERE row_number_value >1;

---STANDARDISING DATA ---

--- Standardising data for bill_items_duplicate1 ---
SELECT * FROM bill_items_duplicate1;
UPDATE bill_items_duplicate1
SET order_item_id = COALESCE(order_item_id, 0),
bill_id = COALESCE(bill_id, 0),
restaurant_location = COALESCE(NULLIF(TRIM(restaurant_location), ''), 'Not Available'),
menu_item_id = COALESCE(NULLIF(TRIM(menu_item_id), ''), 'Not Available'),
menu_category = COALESCE(NULLIF(TRIM(menu_category), ''), 'Not Available'),
quantity_ordered = COALESCE(quantity_ordered, 0),
unit_selling_price = COALESCE(unit_selling_price, 0),
item_subtotal_amount = COALESCE(item_subtotal_amount, 0),
preparation_time_minutes = COALESCE(preparation_time_minutes, 0),
item_notes = COALESCE(NULLIF(TRIM(item_notes), ''), 'Not Available'),
beverage_temperature = COALESCE(NULLIF(TRIM(beverage_temperature), ''), 'Not Available');

--- Standardising data for bills_duplicate1 ---
SELECT * FROM bills_duplicate1;
UPDATE bills_duplicate1
SET bill_id = COALESCE(bill_id, 0),
customer_id = COALESCE(customer_id, 0),
restaurant_location = COALESCE(NULLIF(TRIM(restaurant_location), ''), 'Not Available'),
order_date = COALESCE(order_date, '1900-11-01'),
order_time = COALESCE(order_time, '00:00:00'),
day_name = COALESCE(NULLIF(TRIM(day_name), ''), 'Not Available'),
month_name = COALESCE(NULLIF(TRIM(month_name), ''), 'Not Available'),
quarter = COALESCE(NULLIF(TRIM(quarter), ''), 'Not Available'),
service_time_bucket = COALESCE(NULLIF(TRIM(service_time_bucket), ''), 'Not Available'),
order_type = COALESCE(NULLIF(TRIM(order_type), ''), 'Not Available'),
payment_method = COALESCE(NULLIF(TRIM(payment_method), ''), 'Not Available'),
order_status = COALESCE(NULLIF(TRIM(order_status), ''), 'Not Available'),
refund_reason = COALESCE(NULLIF(TRIM(refund_reason), ''), 'Not Available'),
total_quantity_ordered = COALESCE(total_quantity_ordered, 0),
bill_subtotal_amount = COALESCE(bill_subtotal_amount, 0),
tax_amount = COALESCE(tax_amount, 0),
total_bill_amount = COALESCE(total_bill_amount, 0);

--- Standardising data for menu_items_duplicate ---
SELECT * FROM menu_items_duplicate;
UPDATE menu_items_duplicate
SET menu_item_id = COALESCE(menu_item_id, 0),
menu_item_name = COALESCE(NULLIF(TRIM(menu_item_name), ''), 'Not Available'),
menu_category = COALESCE(NULLIF(TRIM(menu_category), ''), 'Not Available'),
veg_non_veg_flag = COALESCE(NULLIF(TRIM(veg_non_veg_flag), ''), 'Not Available'),
sauce_base = COALESCE(NULLIF(TRIM(sauce_base), ''), 'Not Available'),
pasta_type = COALESCE(NULLIF(TRIM(pasta_type), ''), 'Not Available'),
base_selling_price = COALESCE(base_selling_price, 0),
is_chef_special = COALESCE(is_chef_special, FALSE),
is_seasonal = COALESCE(is_seasonal, FALSE),
is_active = COALESCE(is_active, FALSE);

---REPLACE NULL VALUES---

UPDATE bill_items_duplicate1
SET
item_notes= COALESCE(NULLIF(item_notes, ''), 'Not Available'),
beverage_temperature = COALESCE (NULLIF(beverage_temperature, ''), 'Not Available');

UPDATE bills_duplicate1
SET refund_reason = COALESCE(NULLIF(refund_reason, ''), 'Not Available');

UPDATE bills_duplicate1
SET order_type = REPLACE( order_type,'Dine-in', 'Dine In')
WHERE order_type = 'Dine-In';

UPDATE bill_items_duplicate1
SET menu_item_id = REPLACE(menu_item_id, '16-02-2024', 'Not Available');

UPDATE bills_duplicate1
SET service_time_bucket = REPLACE (service_time_bucket , 'Pre-Lunch', 'Brunch')
WHERE service_time_bucket = 'Pre-Lunch';

UPDATE bills_duplicate1
SET order_date = str_to_date() AS order_date;

UPDATE menu_items_duplicate
SET
sauce_base = COALESCE(NULLIF(sauce_base, ''), 'Not Available'),
pasta_type = COALESCE(NULLIF(sauce_base, ''), 'Not Available'),
veg_non_veg_flag = REPLACE (veg_non_veg_flag, 'Non-Veg' , 'Non Veg');


--- Data Quality Verification---

--- Verification for bill_items_duplicate1 ---
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

--- Verification for bills_duplicate1 ---
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

--- Verification for menu_items_duplicate ---
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
