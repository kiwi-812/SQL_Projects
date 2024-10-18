Use BickStore;


Select Top (10) * From sales.orders;



SELECT * FROM sales.orders AS o INNER JOIN sales.stores AS s ON o.store_id = s.store_id 
WHERE order_date BETWEEN '2016-01-01' AND '2016-12-31' 
AND s.state = 'NY';


SELECT * FROM production.stocks AS s INNER JOIN production.products AS p 
ON s.product_id = p.product_id 
WHERE s.quantity < 10;



SELECT  s.state , COUNT(DISTINCT o.order_id) as Total_Orders 
FROM sales.orders AS o INNER JOIN sales.stores AS s ON o.store_id = s.store_id 
GROUP BY s.state
order by Total_Orders Desc ;



Select customer_id , count(order_id) as total_orders from sales.orders 
group by customer_id 
having count(order_id) > 2;



Select sum(Quantity * list_price *(1- discount)) as total_revenue ,
min(list_price) as minimum_unite_price ,
max(list_price) as maximum_unite_price 
from sales.order_items



select YEAR(order_date) as "Year" , sum(Quantity * list_price * (1-discount)) as total_revenue 
from sales.order_items as oi join sales.orders as o on oi.order_id = o.order_id
group by YEAR(order_date);




select product_id , count(product_id) as num_of_sales, 
sum(Quantity * list_price * (1-discount)) as total_revenue
from sales.order_items
group by product_id
having count(product_id) > 20;
