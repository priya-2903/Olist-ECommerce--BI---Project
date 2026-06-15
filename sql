
/*olist brazilian ecommerce data analysis*/

/*cleansing*/
SELECT count( * ) AS total_rows,
       count( * ) - count(order_id) AS null_order_id,
       count( * ) - count(customer_id) AS null_customer_id,
       count( * ) - count(order_status) AS null_order_status,
       count( * ) - count(order_purchase_timestamp) AS null_order_purchase_timestamp,
       count( * ) - count(order_delivered_customer_date) AS null_order_id,
       count( * ) - count(order_estimated_delivery_date) AS null_order_id
  FROM orders;

SELECT count( * ) AS total_rows,
       count( * ) - count(customer_id) AS null_customer_id,
       count( * ) - count(customer_unique_id) AS null_unique_id,
       count( * ) - count(customer_zip_code_prefix) AS null_fix,
       count( * ) - count(customer_city) AS null_city,
       count( * ) - count(customer_state) AS null_state
  FROM customers;

SELECT count( * ) AS total_rows,
       count( * ) - count(order_id) AS null_order_id,
       count( * ) - count(order_item_id) AS null_order_item_id,
       count( * ) - count(product_id) AS null_product,
       count( * ) - count(seller_id) AS null_seller_id,
       count( * ) - count(shipping_limit_date) AS null_shipping_limit_date,
       count( * ) - count(freight_value) AS null_freight_value
  FROM orderitems;

SELECT count( * ) AS total_rows,
       count( * ) - count(order_id) AS null_order_id,
       count( * ) - count(payment_sequential) AS null_payment_squential,
       count( * ) - count(payment_type) AS null_payment_type,
       count( * ) - count(payment_installments) AS null_payment_installments,
       count( * ) - count(payment_value) AS null_payment_value
  FROM orderpayments;
  SELECT count( * ) AS total_rows,
      count( * ) - count(review_id) AS null_review_id,
       count( * ) - count(order_id) AS null_order_id,
       count( * ) - count(review_score) AS null_review_score,
       count( * ) - count(review_comment_title) AS review_comment_title,
       count( * ) - count(review_comment_message) AS null_review_comment_message,
       count( * ) - count(review_creation_date) AS null_review_creation_date,
       count( * ) - count(review_answer_timestamp) AS null_review_answer_timestamp
       
  FROM orderReviews;
  SELECT count( * ) AS total_rows,
      count( * ) - count(product_category_name) AS null_product_category_name,
      count( * ) - count(product_category_name_english) AS null_product_category_name_english
   FROM product_category;
  SELECT count( * ) AS total_rows,
      count( * ) - count(product_id) AS null_product_id,
       count( * ) - count(product_category_name) AS null_product_category_name,
       count( * ) - count(product_name_length) AS null_product_name_length,
       count( * ) - count(product_description_length) AS null_product_description_length,
       count( * ) - count(product_photos_qty) AS null_product_photos_qty,
       count( * ) - count(product_weight_g) AS null_product_weight_g,
       count( * ) - count(product_length_cm) AS null_product_length_cm,
        count( * ) - count(product_height_cm) AS null_product_height_cm,
       count( * ) - count(product_width_cm) AS null_product_width_cm
       
  FROM products; 
  
 SELECT count( * ) AS total_rows,
      count( * ) - count(seller_id) AS null_seller_id,
       count( * ) - count(seller_zip_code_prefix) AS null_seller_zip_code_prefix,
       count( * ) - count(seller_city) AS null_seller_city,
      count( * ) - count(seller_state) AS null_seller_state
       
  FROM sellers; 
 
  

-- Business_health

SELECT 'orders' AS olist_categories,
       count( * ) AS total_counts
  FROM orders
UNION ALL
SELECT 'customers',
       count( * ) 
  FROM customers
UNION ALL
SELECT 'sellers',
       count( * ) 
  FROM sellers
UNION ALL
SELECT 'products' AS tables,
       count( * ) 
  FROM products
UNION ALL
SELECT 'product_category',
       count( * ) 
  FROM product_category
UNION ALL
SELECT 'orderitems',
       count( * ) 
  FROM orderItems
UNION ALL
SELECT 'geolocation' AS tables,
       count( * ) 
  FROM geolocation
UNION ALL
SELECT 'orderpayments',
       count( * ) 
  FROM orderPayments
UNION ALL
SELECT 'orderReviews',
       count( * ) 
  FROM orderReviews;
  
-- total orders and total revenuee

SELECT count(DISTINCT o.order_id) AS total_orders,
       sum(payment_value) AS total_revenue
  FROM orders AS o
       JOIN
       orderPayments AS op ON o.order_id = op.order_id;
--monthly order trends
SELECT strftime('%Y-%m', order_purchase_timestamp) AS month_orders,
       count(order_id) AS orders_count
  FROM orders
 GROUP BY month_orders
 ORDER BY month_orders;

-- order_status

select
order_status, 
count(order_id) as count_of_orders
from orders
group by order_status
order by count_of_orders desc; 

--revenue growth month by month

SELECT 
strftime('%Y-%m', order_purchase_timestamp) AS month_orders,
sum(payment_value) as monthly_revenue
       FROM orders as o 
  join orderPayments as op
  on o.order_id = op.order_id
  group by month_orders
  order by month_orders;
  
-- total unique customers
  
select
distinct count( customer_id)
from customers;

-- top 10 customers by spending

select
distinct c.customer_id,
sum(op.payment_value) as total_spent
from orders as o
join customers as c
on o.customer_id= c.customer_id
join orderpayments as op
on o.order_id = op.order_id
group by c.customer_id
order by total_spent desc
limit 10;

--avg order value per customer

select
distinct c.customer_id,
avg(op.payment_value) as avg_spent
from orders as o
join customers as c
on o.customer_id= c.customer_id
join orderpayments as op
on o.order_id = op.order_id
group by c.customer_id
order by avg_spent desc;


select
round(avg(count_of_items),2) as avg_items
from(
select
count(order_item_id) as count_of_items
from orderitems
group by order_id
);

--revenue by state

select
customer_state,
round(sum(payment_value),2) as total_revenue
from customers as c
join orders as o using(customer_id )
join orderpayments  as op using(order_id)
group by customer_state
order by total_revenue desc;

--top 10 cities by orders

select
c.customer_city,
count(o.order_id) as orders
from customers as c
join orders as o using(customer_id)
group by customer_city
order by orders desc 
limit 10; 

--customer distribution across states

select
customer_state,
count(distinct customer_id) as customers
from
customers
group by customer_state;

-- top 10 best selling products

select
p.product_id,
count(oi.order_item_id) as product_quantity
from products as p
join orderitems as oi using(product_id)
group by p.product_id
order by  product_quantity desc
limit 10;

-- top 10 product categories by revenue

select
product_category_name,
sum(price) as revenue
from products as p
join orderitems as o using(product_id)
join orderPayments as op using(order_id)
group by product_category_name
order by revenue desc
limit 10;

--worst performing categories

select
product_category_name,
sum(price) as revenue
from products as p
join orderitems as o using(product_id)
group by product_category_name
order by revenue asc
limit 10;

-- avg product price by category

select
product_category_name,
round(avg(price),2) as avg_price
from products as p
join orderitems as o using(product_id)
group by product_category_name
order by avg_price asc
limit 10;

-- avg revenue per seller

select
seller_id,
sum(price) as revenue
from orderitems 
group by  seller_id
order by revenue desc
limit 10;

--top 10 sellers by orders

select
s.seller_id,
count(distinct oi.order_id) as total_orders
from sellers as s
join orderitems as oi using(seller_id)
group by  s.seller_id
order by total_orders desc
limit 10;

--worst performing sellers

select
s.seller_id,
count(distinct oi.order_id) as total_orders
from sellers as s
join orderitems as oi using(seller_id)
group by  s.seller_id
order by total_orders asc
limit 10;

-- avg revenue per seller

select
seller_id,
round(avg(price),2) as avg_revenue
from orderitems 
group by  seller_id
order by avg_revenue desc
limit 10;

--most popular payment method

select
payment_type,
count(payment_type) as usage_percentsge
from orderPayments
group by payment_type
order by usage_percentsge desc;

-- avg payment value by method

select
payment_type,
round(avg(payment_value),2) as avg_paymentvalue
from orderPayments
group by payment_type;

--installment usage analysis

select
round(avg(payment_installments),2) as averege_installments,
count(case when payment_installments >1 then 1 else 0 end) as instalment_users,
count(*) as total_payments
from
orderpayments;

--avg delivery time

select
round(avg(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)),2) as avg_delivery_days
from orders
where order_status = 'delivered'
;

--on time vs delayed deliveries

select
count(case when order_delivered_customer_date <=order_estimated_delivery_date then 1 end) as ontime ,
count(case when order_delivered_customer_date > order_estimated_delivery_date then 1 end) as delay
from orders
where order_status = 'delivered';

--sates  eith worst delivery time

select
customer_state,
count(case when order_delivered_customer_date > order_estimated_delivery_date then 1 end) as delay
from customers as c 
join orders as o using(customer_id)
where order_status = 'delivered'
group by customer_state
order by delay desc;

--estimated vs actual delivery differenc

select
round(avg(julianday(order_delivered_customer_date) -julianday(order_estimated_delivery_date)),2) as avg_days_diff
from orders
where order_status = 'delivered';

--avge reviwe_score

select
round(avg(review_score),2) as avg_review_score from orderreviews;

--review_score distribution

SELECT
  review_score,
  COUNT(*) AS total_reviews,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orderReviews), 2) AS percentage
FROM orderReviews
GROUP BY review_score
ORDER BY review_score ASC;

-- products with worst reviews
select
product_id,
review_score as worst_review
from orderitems
join orderreviews  using(order_id)
group by product_id
order by worst_review asc;

-- correlation between delivery delay and review_score

SELECT
  CASE 
    WHEN order_delivered_customer_date > order_estimated_delivery_date 
    THEN 'Delayed'
    ELSE 'On Time'
  END AS delivery_status,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  COUNT(*) AS total_orders
FROM orders AS o
JOIN orderReviews AS r USING(order_id)
WHERE order_status = 'delivered'
GROUP BY delivery_status;









