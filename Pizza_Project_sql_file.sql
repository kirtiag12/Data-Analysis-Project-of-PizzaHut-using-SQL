create database pizzahut;
use pizzahut;
select*from orders;
select*from order_details;
select*from pizza_types;
select*from pizzas;

## Q-1 Retrieve the total number of orders placed.
select count(order_id) as Total_No__of_Orders from orders;

## Q-2 Calculate the total revenue generated from pizza sales.
select round(sum(o.quantity*p.price),2) as Total_Revenue
from order_details o
inner join  pizzas p
on o.pizza_id = p.pizza_id;

## Q-3 Identify the highest-priced pizza.
select p.pizza_id , pt.name, p.price 
from pizzas p
inner join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
order by p.price desc limit 1;

## Q-4 Identify the most common pizza size ordered.
select p.size, count(o.order_details_id) most_common_pizza
from order_details o
inner join pizzas p
on o.pizza_id = p.pizza_id
group by p.size
order by most_Common_pizza desc;

## Q-5 List the top 5 most ordered pizza types along with their quantities.
select p.pizza_type_id , pt.name , sum(o.quantity) as Total_Quantity
from order_details o
inner join pizzas p
on o.pizza_id = p.pizza_id
inner join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by p.pizza_type_id , pt.name
order by total_quantity desc limit 5;

## Intermediate Level Question:- 

## Q-6 Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category , sum(o.quantity)
from order_details o 
inner join pizzas p
on o.pizza_id = p.pizza_id
inner join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category ;

## Q-7 Determine the distribution of orders by hour of the day.
select hour(o.time) ,count(order_id) from orders o group by hour(o.time);

## Q-8 Join relevant tables to find the category-wise distribution of pizzas.
select category , count(name) from pizza_types group by category;

## Q-9 Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) as avg_pizza_ordered_per_day from
(select o.date , sum(ot.quantity) as quantity
from orders o
inner join order_Details ot
on o.order_id = ot.order_id
group by o.date) dt;

## Q-10 Determine the top 3 most ordered pizza types based on revenue.
select pt.name , sum(o.quantity*p.price) as revenue
from order_details o
inner join pizzas p
on o.pizza_id = p.pizza_id
inner join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by revenue desc limit 3;

## Advanced
## Q-11 Calculate the percentage contribution of each pizza type to total revenue.

## select dt.name , (dt.revenue/sum(dt.revenue))*100 as percentafe_distribution from
select pt.category , round((sum(o.quantity*p.price)/ ( select round(sum(o.quantity*p.price),2) as total_sales
from order_details o join pizzas p on p.pizza_id = o.pizza_id))*100,2) as revenue
from order_details o
inner join pizzas p
on o.pizza_id = p.pizza_id
inner join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category;

## Q- 12 Analyze the cumulative revenue generated over time.

select dt.date , sum(dt.revenue) over (order by dt.date) as cum_revenue from
(select o.date , sum(od.quantity * p.price) as revenue
from orders o 
inner join order_details od
on o.order_id = od.order_id
inner join pizzas p
on od.pizza_id = p.pizza_id
group by o.date) dt;


## Q-13 Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select dt1.name , dt1.revenue , dt1.rn from
(select dt.category , dt.name , dt.revenue, rank() over (partition by dt.category order by dt.revenue ) as rn from 
(select pt.name , pt.category,sum(o.quantity*p.price) as revenue
from order_details o
inner join pizzas p
on o.pizza_id = p.pizza_id
inner join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.name , pt.category) dt) dt1
where rn<=3;