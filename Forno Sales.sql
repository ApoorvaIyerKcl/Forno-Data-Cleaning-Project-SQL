 1. Which menu items contribute the highest revenue across the restaurant chain?
SELECT md.menu_item_name, md.menu_category, SUM(bid.item_subtotal_amount) AS total_revenue 
FROM bill_items_duplicate1 bid 
JOIN menu_items_duplicate md 
ON bid.menu_item_id = md.menu_item_id 
GROUP BY md.menu_item_name, md.menu_category 
ORDER BY total_revenue DESC;

2. Which restaurant locations have high order volume but low average bill value?
SELECT bd.restaurant_location, COUNT(bd.bill_id) AS total_orders, ROUND(AVG(bd.total_bill_amount),2) AS average_bill_value 
FROM bills_duplicate1 bd 
BY bd.restaurant_location 
ORDER BY total_orders DESC;

3. What are the peak service time buckets by day of week?
SELECT bd.day_name, bd.service_time_bucket, COUNT(bd.bill_id) AS order_count 
FROM bills_duplicate1 bd 
GROUP BY bd.day_name, bd.service_time_bucket 
ORDER BY order_count DESC;

 4. Which menu categories generate the highest revenue and total quantity sold?
SELECT md.menu_category, SUM(bid.item_subtotal_amount) AS category_revenue, SUM(bid.quantity_ordered) AS total_quantity_sold 
FROM bill_items_duplicate1 bid 
JOIN menu_items_duplicate md 
ON bid.menu_item_id = md.menu_item_id 
GROUP BY md.menu_category 
ORDER BY category_revenue DESC;

5. How does the number of items per bill impact the total bill amount?
SELECT bd.bill_id, SUM(bid.quantity_ordered) AS total_items_in_bill, bd.total_bill_amount 
FROM bills_duplicate1 bd 
JOIN bill_items_duplicate1 bid 
ON bd.bill_id = bid.bill_id 
GROUP BY bd.bill_id, bd.total_bill_amount 
ORDER BY total_items_in_bill DESC;

6. How does spending differ between repeat customers and one-time customers?
SELECT customer_type, COUNT(DISTINCT customer_id) AS customer_count, ROUND(AVG(total_bill_amount),2) AS average_bill_value 
FROM (SELECT bd.customer_id, bd.total_bill_amount, 
CASE WHEN COUNT(bd.bill_id) OVER (PARTITION BY bd.customer_id) > 1 
THEN 'Repeat Customer' 
ELSE 'One-Time Customer' 
END AS customer_type 
FROM bills_duplicate1 bd) customer_data 
GROUP BY customer_type;

7. Which locations and order types have the highest cancellations or refunds?
SELECT bd.restaurant_location, bd.order_type, COUNT(bd.bill_id) AS cancelled_orders 
FROM bills_duplicate1 bd 
WHERE bd.order_status IN ('Cancelled','Refunded') 
GROUP BY bd.restaurant_location, bd.order_type 
ORDER BY cancelled_orders DESC;

8. Which menu items perform consistently across different restaurant locations?
SELECT md.menu_item_name, bd.restaurant_location, SUM(bid.item_subtotal_amount) AS item_revenue 
FROM bill_items_duplicate1 bid 
JOIN bills_duplicate1 bd ON bid.bill_id = bd.bill_id 
JOIN menu_items_duplicate md ON bid.menu_item_id = md.menu_item_id 
GROUP BY md.menu_item_name, bd.restaurant_location 
ORDER BY item_revenue DESC;

9. Do items with longer preparation time generate higher revenue?
SELECT md.menu_item_name, ROUND(AVG(bid.preparation_time_minutes),2) AS avg_preparation_time, SUM(bid.item_subtotal_amount) AS total_revenue 
FROM bill_items_duplicate1 bid 
JOIN menu_items_duplicate md 
ON bid.menu_item_id = md.menu_item_id 
GROUP BY md.menu_item_name 
ORDER BY avg_preparation_time DESC;

10. What are the monthly and quarterly sales trends across the year?
SELECT bd.quarter, bd.month_name, COUNT(bd.bill_id) AS total_orders, SUM(bd.total_bill_amount) AS total_revenue 
FROM bills_duplicate1 bd 
GROUP BY bd.quarter, bd.month_name 
ORDER BY bd.quarter, bd.month_name;
