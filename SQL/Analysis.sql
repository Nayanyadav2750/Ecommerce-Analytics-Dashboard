select sum(total_amount) as Total_revenue
from e_sales;

select sum(profit_margin) as Total_profit 
from e_sales;

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM e_sales;

SELECT 
    SUM(total_amount) / COUNT(DISTINCT order_id) AS average_order_value
FROM e_sales;

SELECT 
    COUNT(DISTINCT CASE 
        WHEN returned = 'Yes' THEN order_id
    END)
    / COUNT(DISTINCT order_id) * 100 AS return_rate
FROM e_sales;


select category,  sum(total_amount) 
from e_sales
group by category

select category,  sum(profit_margin) 
from e_sales
group by category

select region , COUNT(DISTINCT order_id) 
from e_sales 
group by region

select region , sum(total_amount) 
from e_sales 
group by region 

select category , sum(total_amount) 
from e_sales 
group by category  
order by  sum(total_amount)  desc 
limit 1 

select category,
	 COUNT(DISTINCT CASE 
        WHEN returned = 'Yes' THEN order_id
    END) as return_order_count 
from e_sales 
group by category


select region ,
	 COUNT(DISTINCT CASE 
        WHEN returned = 'Yes' THEN order_id
    END)
    / COUNT(DISTINCT order_id) * 100 AS return_rate 
from e_sales 
group by region 

select region,
	SUM(total_amount) / COUNT(DISTINCT order_id)  as avg_order 
from e_sales
GROUP BY region


select payment_method , sum(profit_margin) as profit 
from e_sales 
group by payment_method

select customer_id , sum(total_amount) as total_spending 
from e_sales 
group by customer_id 
order by total_spending desc 
limit 5

select customer_id, 
	round(sum(total_amount),0) as Total_revenue 
from e_sales 
group by customer_id 
order by Total_revenue desc 
limit 10 ;

select product_id, 
	sum(quantity) as total_quantity
from e_sales
group by product_id 
order by total_quantity desc 
limit 10 ;

select category,
	round(sum(total_amount) / count(distinct order_id),2) as avg_order 
from e_sales
group by category;

select category , avg(discount)
from e_sales
group by category;

select region,  AVG(delivery_time_days) AS avg_delivery_days
from e_sales
group by region ;

select customer_id, sum(profit_margin) as total_profit
from e_sales
group by customer_id
order by total_profit desc
limit 5;

select  
	(sum(profit_margin)/sum(total_amount))*100 as Profit_margin
from e_sales;

select payment_method ,
	count(distinct case 
	when returned = "yes" then order_id
end) as return_order_count
from e_sales
group by payment_method;

select customer_id, total_revenue 
from ( select customer_id , sum(total_amount) as total_revenue 
		from e_sales
		group by customer_id )  AS customer_sales
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT 
            customer_id,
            SUM(total_amount) AS total_revenue
        FROM e_sales
        GROUP BY customer_id
    ) AS avg_customer_sales
);

SELECT MAX(total_unit)
FROM (
    SELECT product_id, SUM(quantity) AS total_unit
    FROM e_sales
    GROUP BY product_id
) x;;

select region , sum(profit_margin) as total_profit 
from e_sales
group by region 
order by total_profit desc
limit 1 


SELECT 
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS month,
    SUM(total_amount) AS total_revenue
FROM e_sales
GROUP BY MONTH(STR_TO_DATE(order_date, '%d-%m-%Y'))
ORDER BY month;

select 
	month(str_to_date(order_date, '%d-%m-%Y')) as month,
    count(distinct order_id) as total_order 
from e_sales
group by month(str_to_date(order_date, '%d-%m-%Y')) 
order by month;


SELECT 
    region,
    category,
    SUM(profit_margin) AS total_profit
FROM e_sales
GROUP BY region, category;

select payment_method,
	sum(total_amount)/count(distinct order_id) as avg_order_value 
from e_sales
group by payment_method;

select 
	month(STR_TO_DATE(order_date,'%d-%m-%Y')) as month ,
    sum(total_amount) as total_revenue 
from e_sales 
group by month(STR_TO_DATE(order_date,'%d-%m-%Y'))
order by total_revenue desc 
limit 1 ;


select customer_id,  sum(total_amount) as total_revenue, 
	CASE
		WHEN SUM(total_amount) > 5000 THEN 'High Value'
		WHEN SUM(total_amount) < 2000 THEN 'Low Value'
		ELSE 'Medium Value'
	END as category_type 
from e_sales
group by customer_id;


select product_id , total_revenue 
from( select product_id , sum(total_amount) as total_revenue
		from e_sales 
		group by product_id 
        ) as product_sales 
where total_revenue > (
	select avg(total_revenue)
    from ( select product_id , sum(total_amount) as total_revenue
		from e_sales 
		group by product_id ) as avg_product_sales 
);
        
WITH monthly_revenue AS (
    SELECT
        MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS month,
        SUM(total_amount) AS total_revenue
    FROM e_sales
    GROUP BY MONTH(STR_TO_DATE(order_date, '%d-%m-%Y'))
)
SELECT
    AVG(total_revenue) AS average_monthly_revenue
FROM monthly_revenue;

WITH TRY AS (
    SELECT
        product_id,
        SUM(total_amount) AS total_revenue,
        DENSE_RANK() OVER (
            ORDER BY SUM(total_amount) DESC
        ) AS revenue_rank
    FROM e_sales
    GROUP BY product_id
)
SELECT
    product_id,
    total_revenue,
    revenue_rank
FROM TRY; 

with TRY as (select region,customer_id, sum(total_amount) as total_revenue, 
			dense_rank() 
            over(partition by region 
            order by sum(total_amount)desc
            ) as revenue_rank 
            from e_sales
            GROUP BY region, customer_id) 
select region,customer_id, total_revenue, revenue_rank 
from TRY ;
		