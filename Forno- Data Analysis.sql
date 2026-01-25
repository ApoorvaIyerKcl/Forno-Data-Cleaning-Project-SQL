USE restaurant_sales;
PRIMARY BUSINESS QUESTIONS

-- 1: Identify menu categories whose total revenue is higher than the average revenue across all categories
SELECT menu_category,
SUM(item_subtotal_amount) AS total_revenue
FROM bill_items
GROUP BY menu_category
HAVING SUM(item_subtotal_amount) >
(
SELECT AVG(category_revenue)
FROM
(
SELECT SUM(item_subtotal_amount) AS category_revenue
FROM bill_items
GROUP BY menu_category
) AS category_summary
);

-- 2: Find restaurant locations where average bill value is higher than the overall average bill value
SELECT restaurant_location,
AVG(total_bill_amount) AS average_bill_value
FROM bills
GROUP BY restaurant_location
HAVING AVG(total_bill_amount) >
(
SELECT AVG(total_bill_amount)
FROM bills
);

-- 3: Identify menu items contributing more than 5 percent of total restaurant revenue
SELECT menu_item_id,
SUM(item_subtotal_amount) AS item_revenue
FROM bill_items
GROUP BY menu_item_id
HAVING SUM(item_subtotal_amount) >
(
SELECT SUM(item_subtotal_amount) * 0.05
FROM bill_items
);

-- 4: Find customers whose total spending is higher than the average customer spending
SELECT customer_id,
SUM(total_bill_amount) AS total_spent
FROM bills
GROUP BY customer_id
HAVING SUM(total_bill_amount) >
(
SELECT AVG(customer_total)
FROM
(
SELECT SUM(total_bill_amount) AS customer_total
FROM bills
GROUP BY customer_id
) AS customer_summary
);

-- 5: Identify days where total revenue exceeded the monthly average revenue
SELECT month_name,
day_name,
SUM(total_bill_amount) AS daily_revenue
FROM bills
GROUP BY month_name, day_name
HAVING SUM(total_bill_amount) >
(
SELECT AVG(monthly_revenue)
FROM
(
SELECT SUM(total_bill_amount) AS monthly_revenue
FROM bills
GROUP BY month_name
) AS monthly_summary
);

-- 6: Find menu categories with average preparation time higher than overall average preparation time
SELECT menu_category,
AVG(preparation_time_minutes) AS average_preparation_time
FROM bill_items
GROUP BY menu_category
HAVING AVG(preparation_time_minutes) >
(
SELECT AVG(preparation_time_minutes)
FROM bill_items
);

-- 7: Identify restaurant locations where online orders generate more revenue than dine-in orders
SELECT restaurant_location
FROM bills
GROUP BY restaurant_location
HAVING SUM(CASE WHEN order_type = 'Online' THEN total_bill_amount ELSE 0 END) >
SUM(CASE WHEN order_type = 'Dine-In' THEN total_bill_amount ELSE 0 END);

-- 8: Find menu items ordered in quantities higher than the average item quantity
SELECT menu_item_id,
SUM(quantity_ordered) AS total_quantity
FROM bill_items
GROUP BY menu_item_id
HAVING SUM(quantity_ordered) >
(
SELECT AVG(item_quantity)
FROM
(
SELECT SUM(quantity_ordered) AS item_quantity
FROM bill_items
GROUP BY menu_item_id
) AS quantity_summary
);

-- 9: Identify quarters where revenue growth is higher than the average quarterly revenue
SELECT quarter,
SUM(total_bill_amount) AS quarterly_revenue
FROM bills
GROUP BY quarter
HAVING SUM(total_bill_amount) >
(
SELECT AVG(quarterly_revenue)
FROM
(
SELECT SUM(total_bill_amount) AS quarterly_revenue
FROM bills
GROUP BY quarter
) AS quarterly_summary
);

-- 10: Find menu categories where chef special items generate higher revenue than non-chef specials
SELECT mi.menu_category
FROM menu_items mi
JOIN bill_items bi ON mi.menu_item_id = bi.menu_item_id
GROUP BY mi.menu_category
HAVING SUM(CASE WHEN mi.is_chef_special = 'Yes' THEN bi.item_subtotal_amount ELSE 0 END) >
SUM(CASE WHEN mi.is_chef_special = 'No' THEN bi.item_subtotal_amount ELSE 0 END);
```

---

## 🔹 SECONDARY ANALYTICAL QUESTIONS (10)

```sql
-- 11: Identify restaurant locations with refund rate higher than average
SELECT restaurant_location,
COUNT(refund_reason) / COUNT(bill_id) AS refund_rate
FROM bills
GROUP BY restaurant_location
HAVING COUNT(refund_reason) / COUNT(bill_id) >
(
SELECT AVG(refund_ratio)
FROM
(
SELECT COUNT(refund_reason) / COUNT(bill_id) AS refund_ratio
FROM bills
GROUP BY restaurant_location
) AS refund_summary
);

-- 12: Find menu categories where average item price is higher than overall average item price
SELECT menu_category,
AVG(unit_selling_price) AS average_price
FROM bill_items
GROUP BY menu_category
HAVING AVG(unit_selling_price) >
(
SELECT AVG(unit_selling_price)
FROM bill_items
);

-- 13: Identify service time buckets generating the highest revenue
SELECT service_time_bucket,
SUM(total_bill_amount) AS total_revenue
FROM bills
GROUP BY service_time_bucket
HAVING SUM(total_bill_amount) =
(
SELECT MAX(bucket_revenue)
FROM
(
SELECT SUM(total_bill_amount) AS bucket_revenue
FROM bills
GROUP BY service_time_bucket
) AS revenue_summary
);

-- 14: Find customers ordering more items than the average items per customer
SELECT customer_id,
SUM(total_quantity_ordered) AS total_items
FROM bills
GROUP BY customer_id
HAVING SUM(total_quantity_ordered) >
(
SELECT AVG(customer_quantity)
FROM
(
SELECT SUM(total_quantity_ordered) AS customer_quantity
FROM bills
GROUP BY customer_id
) AS quantity_summary
);

-- 15: Identify menu items with preparation time higher than category average
SELECT bi.menu_item_id,
bi.menu_category,
AVG(bi.preparation_time_minutes) AS average_preparation_time
FROM bill_items bi
GROUP BY bi.menu_item_id, bi.menu_category
HAVING AVG(bi.preparation_time_minutes) >
(
SELECT AVG(category_preparation_time)
FROM
(
SELECT AVG(preparation_time_minutes) AS category_preparation_time
FROM bill_items
WHERE menu_category = bi.menu_category
) AS category_time_summary
);

-- 16: Find months where online orders contributed more than 60 percent of total revenue
SELECT month_name
FROM bills
GROUP BY month_name
HAVING SUM(CASE WHEN order_type = 'Online' THEN total_bill_amount ELSE 0 END) >
SUM(total_bill_amount) * 0.60;

-- 17: Identify menu categories with inactive items still generating revenue
SELECT mi.menu_category
FROM menu_items mi
JOIN bill_items bi ON mi.menu_item_id = bi.menu_item_id
WHERE mi.is_active = 'No'
GROUP BY mi.menu_category;

-- 18: Find restaurant locations where average tax amount is higher than overall average tax
SELECT restaurant_location,
AVG(tax_amount) AS average_tax
FROM bills
GROUP BY restaurant_location
HAVING AVG(tax_amount) >
(
SELECT AVG(tax_amount)
FROM bills
);

-- 19: Identify menu items sold only during specific quarters
SELECT bi.menu_item_id,
b.quarter
FROM bill_items bi
JOIN bills b ON bi.bill_id = b.bill_id
GROUP BY bi.menu_item_id, b.quarter
HAVING COUNT(DISTINCT b.quarter) = 1;

-- 20: Find menu categories where seasonal items generate more revenue than non-seasonal items
SELECT mi.menu_category
FROM menu_items mi
JOIN bill_items bi ON mi.menu_item_id = bi.menu_item_id
GROUP BY mi.menu_category
HAVING SUM(CASE WHEN mi.is_seasonal = 'Yes' THEN bi.item_subtotal_amount ELSE 0 END) >
SUM(CASE WHEN mi.is_seasonal = 'No' THEN bi.item_subtotal_amount ELSE 0 END);

