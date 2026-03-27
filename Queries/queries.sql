-- ============================================
-- Q1: Total Revenue Per Country After Discounts
-- Business Question: Which countries generate 
-- the most revenue after applying discounts?
-- Formula: unit_price * quantity * (1 - discount)
-- ============================================
with revenue_per_line as 
(
	select od.order_id,
	od.unit_price * od.quantity * (1-od.discount) as line_revenue
	from order_details od
)

select o.ship_country,
	round(sum(rpl.line_revenue),2) as total_revenue
	from orders o
join revenue_per_line rpl on o.order_id= rpl.order_id
group by o.ship_country
order by total_revenue Desc




-- ============================================
-- Q2: Monthly Revenue Trend
-- Business Question: Is revenue growing or 
-- declining month over month?
-- ============================================

with monthly_revenue as (

select 
	date_trunc('month', o.order_date) as order_month,
	Sum(od.unit_price * od.quantity * (1-od.discount)) as total_revenue
	from orders o
	join order_details od on o.order_id = od.order_id
	group by  date_trunc('month', o.order_date)
)

select 
	To_Char(order_month, 'YYYY-MM') as month,
	round(total_revenue::Numeric,2) as total_revenue
from monthly_revenue 
order by total_revenue desc


-- ============================================
-- Q3: Top 10 Customers
-- Business Question: Who are the top 10 customers
-- with the most revenue
-- ============================================

with customer_revenue as (
	select
		o.customer_id,
		sum(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue
	from orders o
	join order_details od on o.order_id = od.order_id
	group by o.customer_id
)

select 
	customer_id,
	round(total_revenue:: Numeric, 2) as total_revenue
from customer_revenue
order by total_revenue desc
limit 10

-- ============================================
-- Q4: Percentage of revenue by country
-- Business Question: What percentage of total revenue does 
--each country contribute?
-- ============================================

with country_wise_revenue as
( 
Select
	o.ship_country,
	Sum(od.unit_price * od.quantity * (1- od.discount)) as country_revenue
	from orders o
	join order_details od on o.order_id= od.order_id
	group by o.ship_country
)

select ship_country,
		round(country_revenue::Numeric, 2) as total_revenue,
		round((country_revenue / sum(country_revenue) over() *100)::Numeric, 2) as revenue_per
from country_wise_revenue
order by revenue_per desc


-- ============================================
-- Q5: What were the top 10 sold products
-- Business Question:  Top 10 most sold products by quantity
-- and revenue

-- ============================================
--by revenue

select 
	od.product_id,
	sum(od.quantity) as total_quan,
	sum(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue
from order_details od
group by od.product_id
order by total_revenue desc
limit 10

--by quantity

select 
	od.product_id,
	sum(od.quantity) as total_quan,
	sum(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue
from order_details od
group by od.product_id
order by total_quan desc
limit 10

-- ============================================
-- Q6: What was the average order value per customer
-- Business Question:  Find out the average revenue of each 
-- customer
-- ============================================

with total_order as 
(
	select 
	od.order_id,
	sum(od.unit_price*od.quantity*(1-od.discount)) as total_revenue
	from order_details od
	group by order_id
)

select o.customer_id,
	count(o.order_id) as total_orders,
	round(avg(too.total_revenue::numeric),2) as ave_order
	from orders o
join total_order too on o.order_id=too.order_id
group by o.customer_id
order by ave_order desc
limit 10


-- ============================================
-- Q7: What order had the highesh discount applied and how much was lost.
-- Business Question:  which order would have made a lot of difference 
-- 
-- ============================================


with order_revenue as 
( select
	od.order_id,
	round(sum(od.unit_price * od.quantity),1) as total_price,
	round(sum(od.unit_price * od.quantity * (1 - od.discount)),1) as discounted_price
from order_details od
	group by od.order_id
)

select order_id,
		total_price,
		discounted_price,
		round(total_price - discounted_price, 1) as difference
	from order_revenue
order by difference desc
limit 10

-- ============================================
-- Q8: What was the revenue difference because of discount
-- Business Question:  How much revenue did we lose  
-- 
-- ============================================

with revenue_comp as(
	select 
		round(sum(unit_price * quantity),1) as total_revenue,
		round(sum(unit_price * quantity * (1-discount)),1) as discounted_price
		from order_details
)

select total_revenue,
		discounted_price,
		round(total_revenue - discounted_price,1) as total_revenue_loss
from revenue_comp


-- ============================================
-- Q9: Which employees handle the most orders and generate the most revenue?
-- Business Question:  which employee was  the most active   
-- 
-- ============================================

with employee_count as (
	Select
		o.employee_id,
		count(distinct o.order_id) as total_orders_taken,
		round(sum(od.unit_price * od.quantity * (1-od.discount))::Numeric,2) as total_revenue
	from orders o
	join order_details od on o.order_id= od.order_id
	group by employee_id
)

select employee_id,
		total_orders_taken,
		total_revenue
from employee_count
order by total_revenue desc


-- ============================================
-- Q10: Average order value per employee
-- Business Question: what was the average order value of employee
-- 
-- ============================================


with total_order as 
(
	select 
	od.order_id,
	sum(od.unit_price*od.quantity*(1-od.discount)) as total_revenue
	from order_details od
	group by order_id
)

select o.employee_id,
	round(avg(too.total_revenue::numeric),2) as ave_order
	from orders o
join total_order too on o.order_id=too.order_id
group by o.employee_id
order by ave_order desc

-- ============================================
-- Q11: Customers At Churn Risk
-- Business Question: Which customers have not
-- placed an order in the last 6 months?
-- ============================================

with customer_last_order as (
select 
	customer_id,
	max(order_date) as last_order_date
from orders
group by customer_id

),
cutoff as (
	select 
	max(order_date) - Interval '6 months' as cutoff_date
	from orders
)
select
	c.customer_id,
	c.last_order_date
	
from customer_last_order c
cross join cutoff ct
where c.last_order_date < ct.cutoff_date

-- ============================================
-- Q12: Month Over Month Revenue Growth Rate
-- Business Question: Is revenue growing or
-- declining each month using LAG()
-- ============================================


with monthly_revenue as (
	select 
	date_trunc('month', o.order_date) as order_month,
	Sum(od.unit_price * od.quantity * (1-od.discount)) as total_revenue
	from orders o
	join order_details od on o.order_id = od.order_id
	group by  date_trunc('month', o.order_date)
),

revenue_with_lag as (
	select 
		order_month,
		total_revenue,
		lag(total_revenue) over(order by order_month) as prev_month_revenue
	from monthly_revenue
)

select 
	to_char(order_month, 'YYYY-MM') as month,
	round(total_revenue::Numeric, 2) as total_revenue,
	round(prev_month_revenue::Numeric,2) as prev_month_revenue,
	round(((total_revenue - prev_month_revenue) / prev_month_revenue * 100)::Numeric, 2) as growth_rate_pct
from revenue_with_lag
order by order_month asc


-- ============================================
-- Q13: Rank customers by revenue within each country
-- Business Question: Identify top-performing customers in every country
-- ============================================

with monthly_revenue as (
	select o.customer_id,
		o.ship_country,
		sum(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue
	from orders o
	join order_details od on o.order_id = od.order_id
	group by o.customer_id, o.ship_country
)

select
	customer_id,
	ship_country,
	round(total_revenue,2),
	rank() over(partition by ship_country order by total_revenue desc) as ranking
from monthly_revenue


-- ============================================

-- Q14: Cumulative revenue over time (running total)
-- Business Question: How does total revenue accumulate month by month?

-- ============================================

with monthly_revenue as (
	select 
	date_trunc('month', o.order_date) as order_month,
	Sum(od.unit_price * od.quantity * (1-od.discount)) as total_revenue
	from orders o
	join order_details od on o.order_id = od.order_id
	group by  date_trunc('month', o.order_date)
),

revenue_growth as (
	select 
		order_month,
		total_revenue,
		sum(total_revenue) over(order by order_month) as total_overall_revenue
	from monthly_revenue
)

select 
	to_char(order_month, 'YYYY-MM') as month,
	round(total_revenue::Numeric, 2) as total_revenue,
	round(total_overall_revenue::Numeric,2) as total_overall_revenue
from revenue_growth
order by order_month asc


-- ============================================

-- Q15: Customers above average revenue
-- Business Question: Which customers generate more revenue 
--than the average customer?
-- ============================================

with customer_revenue as (
	select
		o.customer_id,
		sum(od.unit_price * od.quantity * (1-od.discount)) as total_revenue
	from orders o
join order_details od on o.order_id = od.order_id
group by o.customer_id
)

select 
	customer_id,
	total_revenue,
	round(avg(total_revenue) over(),2) as avg_revenue
from customer_revenue
where total_revenue > (select avg(total_revenue) from customer_revenue)
order by total_revenue desc
