create database college ;
USE college;

CREATE TABLE student (id INT PRIMARY KEY, name VARCHAR(50));

INSERT INTO student (id, name) VALUES
(101, "adam"),
(102, "bob"),
(103, "casey");

CREATE TABLE course(  id INT PRIMARY KEY, course VARCHAR(50));

INSERT INTO course (id, course) VALUES
(102, "english"),
(105, "math"),
(103, "science"),
(107, "computer science");

select *
from student ;

select * 
from course ;

select *
from student as s
right join  course as c
on s.id = c.id
where s.id is null;

use rr ;

select o.customerID , Name , count(distinct p.orderID) as to_no_of_order , sum(Amount) as total_amount
from customers as c
inner join orders as o
on c.customerID = o.customerID
inner join payments as p
on o.orderID = p.orderID
where p.status = "success" 
group by customerID , Name
having total_amount > 50000
order by total_amount desc;

select oi.productID, productName, categoryname, supplierName,
count(orderID) as num_of_records, sum(quantity) as total_quantiy,
sum(total) as total_sales, avg(oi.sellingprice) as vag_sel_price
from products as p
inner join order_items as oi
on p.productID = oi.productID
inner join categories as c
on p.categoryID = c.categoryID
inner join suppliers as s 
on p.supplierID = s.supplierID
group by productID, productName, categoryname, supplierName
having total_sales > 100000
order by total_sales desc
limit 10;

select c.categoryID, categoryName, count(*) as num_of_qual_products,
round(avg(mrp), 2) as avg_mrp, max(mrp) as mx_mrp, min(mrp) as mn_mrp
from products as p 
inner join categories as c
on p.categoryID = c.categoryID
where mrp > 2000
group by categoryID, categoryName
order by avg_mrp desc ;

select c.customerID, name, city, name
from customers as c
left join orders as o
on c.customerID = o.customerID
where o.customerID is null
order by name ;

select s.supplierID, supplierName, count(p.productID) as num_of_suppli,
avg(mrp) as avg_mrp, coalesce(sum(total) , 0) as total_sales, sum(quantity) as to_qnt
from suppliers as s
left join products as p
on p.supplierID = s.supplierID
left join order_items as oi
on p.productID = oi.productID
group by supplierID, supplierName
order by total_sales desc ;

select o.warehouseID, warehouse, count(distinct o.orderID) as num_of_order,
sum(quantity) as total_quantity, sum(total) as total_sales
from warehouses as w 
left join orders as o
on w.warehouseId = o.warehouseID
left join order_items as oi
on o.orderId = oi.orderID
group by warehouseID, warehouse
having total_sales > 200000
order by total_sales desc;

select c.customerID, Name, sum(total) as total_spend 
from customers as c
inner join orders as o
on c.customerID = o.customerID
inner join order_items as oi
on o.orderID = oi.orderID
group by customerID, Name
having total_spend  > (select sum(total)/count(distinct customerID)  as avg
					   from orders as o
                       inner join order_items as oi
                       on o.orderID = oi.orderId) 
order by total_spend desc;

select oi.productID, productName, categoryName,
sum(total) as total_sales
from products as p
inner join order_items as oi 
on p.productID = oi.productId
inner join categories as c
on p.categoryID= c.categoryID
group by productID, productName, categoryName
having total_sales > (select sum(total)/count(distinct oi.productID)
					  from products as p
                      inner join order_items as oi
                      on p.productID = oi.productID
                      inner join categories as c
                      on p.categoryID = c.categoryID )
order by total_sales desc ;

select oi.orderID, o.orderdate,
name, sum(total) as total,
case 
when sum(total) >= 50000 then "High value"
when sum(total) >= 20000 and sum(total) <= 49999 then "mideum value"
when sum(total) > 20000 then "low value"
end as category
from orders as o
inner join order_items as oi 
on o.orderId = oi.orderID
inner join customers as cu
on cu.customerID = o.customerID
group by orderID, orderdate, name
order by total desc ;

select c.categoryID, categoryName, count(*) as num_of_pd,
count(distinct p.productID) as num_diff_pd,
sum(quantity) as total_quantity,
sum(total) as total_sales, avg(oi.sellingPrice) as avg_sellinfPrice
from products as p 
inner join order_items as oi 
on p.productID = oi.productID
inner join categories as c
on p.categoryID = c.categoryID
where oi.sellingPrice > 10000
group by categoryID, categoryName
having total_sales > 500000
order by total_sales desc ;

select customerID, Name,
case 
when age >= 18 and age <= 20 then "genG"
when age >= 21 and age <= 40 then "adult"
else "siniour"
end as age_group 
from customers;

select customerID, Name, gender, case 
when gender = "f" then "female"
else "male"
end as gender
from customers ;

use rr ; 

select customerID, name,
case 
when age >= 18 and age <= 20 then "genG"
when age >= 21 and age <= 40 then "adult"
when age >= 41 then "sinior citizen"
end as age_group
from customers;

select customerID, name,
case 
when gender = "F"then "female"
else "male"
end as gender
from customers;

select p.categoryID,  categoryName,
count(distinct oi.productID) as num_of_productID,
sum(quantity) as total_quantity,
sum(total) as total_sales, round(avg(oi.sellingPrice), 2)as avg_sellingprice
from categories as c
inner join products as p
on p.categoryID = c.categoryID
inner join order_items as oi 
on p.productID = oi.productID
where oi.sellingPrice > 1000
group by categoryID, categoryName
having total_sales > 5000
order by total_sales desc ;  

select p.productID, p.productName, c.categoryname,
((mrp - p.sellingprice)/mrp)*100 as percentage,
sum(total) as total_sales, p.mrp, oi.sellingPrice
from products as p
inner join categories as c
on p.categoryID = c.categoryID
inner join order_items as oi 
on p.productID = oi.productID
where mrp > 15000 and ((mrp - p.sellingprice)/mrp)*100 > 20
group by productID, productName, categoryname, p.mrp, oi.sellingPrice, percentage
having total_sales > 75000
order by percentage desc ;

use rr ;

select o.employeeID, name, department,
count(distinct o.orderID) as num_of_or_hand,
sum(total) as total_sales
from employees as  e
inner join orders as o
on e.employeeID = o.employeeID
inner join order_items as oi 
on o.orderID = oi.orderID
group by o.employeeID, name, department
having num_of_or_hand >= 5
order by total_sales desc ;

select e.employeeID, name, department,
count(distinct orderID) as num_of_order,
count(distinct customerID) as num_of_customer
from employees as e
inner join orders as o
on e.employeeId = o.employeeID
group by employeeID, name, department
having num_of_order >= 5
order by num_of_order  desc ;

select city, count(distinct c.customerId) as num_of_customer, 
count(distinct oi.orderId) as num_order,
avg(total) as avg_order_item,
sum(total) as total_sales
from customers as c 
inner join orders as o 
on c.customerID = o.customerID
inner join order_items as oi 
on o.orderID = oi.orderID
group by city
having total_sales > 300000
order by total_sales desc ;

select p.productID, productName,
count(distinct oi.productID) as num_of_pd,
sum(quantity) as total_quantity,
avg(oi.sellingPrice) as avg_sellingPrice
from products as p
inner join order_items as oi 
on p.productID = oi.productID
group by productID, productName
having avg_sellingPrice > 1500
order by avg_sellingPrice desc ;

select categoryname, count(distinct productID) as num_of_pd,
max(mrp) as mx_mrp, min(mrp) as mn_mrp,
max(mrp) - min(mrp) as diffrence
from products as p 
inner join categories as c
on p.categoryID = c.categoryID 
group by  categoryname 
having diffrence > 100 ;

select method, count(status) as num_of_success,
sum(amount) as total_amount,
round(avg(amount),2) as avg_amount, 
max(amount) as mx_amount
from payments 
where status = "success"
group by method 
having num_of_success > 10
order by avg_amount desc ;

SELECT oi.productID, productName, categoryName,
sum(quantity) as total_quantity,
sum(total) as total_sales
FROM PRODUCTS as p
inner join categories as c
on p.categoryID = c.categoryID
inner join order_items as oi
on p.productId = oi.productID
group by productID, productName, categoryName
order by total_quantity desc
limit 15 ; 

select i.warehouseID, warehouse,
count(distinct i.warehouseID) as num_of_in_rec,
sum(stock) as total_stock,
round(avg(stock),2) as avg_stock,
max(stock) as highest_stock
from warehouses as w
inner join inventory as i
on w.warehouseID = i.warehouseID
group by warehouseID, warehouse
having avg_stock > 100
order by total_stock desc ;

select i.productID, productName, supplierID,
count(i.warehouseID) as num_of_int_rec,
sum(stock) as total_stock
from products as p
left  join order_items as oi
on p.productID = oi.productID
inner join inventory as i
on p.productID = i.productID
where oi.productID is null
group by i.productID, productName, supplierID
order by total_stock desc ;

select supplierName, count(p.productID) as num_of_pd,
avg(mrp) as avg_mrp,
max(mrp) as mx_mrp,
min(mrp) as mn_mrp,
case 
when avg(mrp) >= 30000 then "premium_supp"
when avg(mrp) >= 15000 then "mid_range_supp"
when avg(mrp) < 15000 then "budget_supp"
end as supp_group
from products as p 
inner join suppliers as s
on s.supplierID = p.supplierID 
group by p.supplierID, supplierName
order by avg_mrp desc;

select c.customerID, Name,
sum(oi.total) as total_value,
count(distinct o.orderID ) as num_of_fail_order
from customers as c 
inner join orders as o
on c.customerID = o.customerID
inner join payments as p 
on o.orderID = p.orderID
inner join order_items as oi 
on o.orderID = oi.orderID
where p.status = "success"
group by customerID, Name
order by total_value desc ;

select e.employeeID, Name ,
count(distinct o.orderID) as num_of_order,
sum(total) as total_value,
round(avg(total), 2) as avg_value
from employees as e
inner join orders as o
on o.employeeID = e.employeeID 
inner join order_items as oi 
on o.orderID = oi.orderID 
group by e.employeeID, Name 
having total_value > 75000
order by total_value desc ;

use rr ;

select w.warehouseID, warehouse,
sum(stock) as total_stock,
round(avg(stock),2) as avg_stock,
case 
when sum(stock) >= 5000 then "high_stock"
when sum(stock) >= 2500 then "medium_stock"
else "low_stock"
end as stock_category
from warehouses as w
inner join inventory as i 
on w.warehouseID = i.warehouseID
group by warehouseID, warehouse ;

select c.customerID, name,
count(distinct orderdate) as num_of_diff_ord_date,
count(distinct o.orderID) as total_order,
sum(quantity) as total_quantity
from customers as c
inner join orders as o
on c.customerID = o.customerID 
inner join order_items as oi 
on o.orderID = oi.orderID 
group by customerID, name
having num_of_diff_ord_date > 2
order by num_of_diff_ord_date desc ;

select categoryname, productID, productname,
max(mrp) as highest_mrp
from products as p 
inner join categories as c
on p.categoryID = p.categoryID 
where mrp in (
			select 
			max(mrp) as highest_mrp
			from products as p2
			where p2.categoryID = p.categoryID 
			group by p.categoryID
                    )
group by categoryname, productID, productname
order by categoryname desc ;

select 
max(mrp) as highest_mrp
from products as p 
inner join categories as c
on p.categoryID = p.categoryID 
group by p.categoryID ;

select productID, sum(total) as total_sales
from order_items 
group by productID ;

select productID, orderitemID, sellingprice,
avg(sellingprice) over(partition by productID) as avg_sellingprice
from order_items ;

select productID, orderID,
count(*) over(partition by productID) as num_of_order
from order_items ;

select productID, orderID, total,
sum(total) over() as _sales
from order_items ;

use rr ;

select productID, sellingprice, OrderID,
avg(sellingprice) over(partition by productID) as avg_selling_price
from order_items;

select orderID, productID, total,
row_number() over(order by total desc ) as sales_rank
from order_items ;

select max(total)
from order_items ;

select productID, orderID, total,
row_number() over(partition by productID order by  total desc ) as sales_rank
from order_items ;

select *
from order_items 
where productId = "P001" ;

select sum(total), productID
from order_items 
where productId = "P003" ;

select productID, orderID,
sum(total) over w as sales_sales,
row_number() over w as sales_rank
from order_items
window w as (partition by productID) ; 

select productID, total_sales,
dense_rank() over(order by total_sales desc) as sales_rank
from(select productID,
sum(total) as total_sales
from order_items 
group by productID ) as sales_table ;

select c.customerID, name ,
count(orderID) as count_of_order
from customers as c 
left  join orders as o
on c.customerID = o.customerID
group by customerID, name  
order by count_of_order desc;

select Name, productName, categoryName, quantity, oi.sellingprice, total
from customers as c
inner join orders as o
on c.customerID = o.customerID
inner join order_items as oi
on o.orderID = oi.orderID
inner join products as p
on oi.productID = p.productID
inner join categories as ca
on p.categoryID = ca.categoryID ;

select categoryName, supplierName,
sum(total) as total_sales
from products as p
inner join categories as cat
on p.categoryID = cat.categoryID
inner join suppliers as s
on p.supplierID = s.supplierID
inner join order_items as oi
on oi.productID = p.productID
group by categoryName, supplierName
order by total_sales desc ;

select c.customerID, Name, count(distinct oi.productID) as diff_pd
from customers as c
inner join orders as o
on c.customerID = o.customerID
inner join order_items as oi
on o.orderID = oi.orderID
group by customerID, Name
order by diff_pd desc ;

select c.categoryID, categoryName, 
sum(total) as total_sales,
count(distinct oi.productID) as num_of_diff_pd_sold
from products as p
inner join order_items as oi 
on p.productID = oi.productID
inner join categories as c
on p.categoryID = c.categoryID
group by c.categoryID, categoryName
having total_sales > 100000
order by total_sales desc ;

select c.customerID, Name, city,
sum(total) as total_spent
from customers as c
inner join orders as o
on o.customerID = c.customerID
inner join order_items as oi 
on o.orderID = oi.orderID
group by c.customerID, Name, city
having total_spent > 50000
order by total_spent desc ;

select s.supplierID, supplierName,
count(distinct p.productID) as num_of_pd,
sum(total) as total_sales
from products as p
inner join suppliers as s
on p.supplierID = s.supplierID
inner join order_items as oi
on p.productID = oi.ProductID
group by s.supplierID, supplierName
having total_sales > 200000
order by total_sales desc ;

select customerID, orderId, orderDate,
row_number() over(partition by customerID order by orderdate desc)
from orders ;

select warehouseID, productId, stock,
case 
when stock >= 200 then " high_stock"
when stock >= 50 then " medium_stock"
else "low_stock"
end as stocK_status 
from inventory
order by warehouseID, stock desc ;

select c.customerID, Name,
count(p.paymentID) as num_of_succ_at,
sum(p.amount) as total_amount
from customers as c
inner join orders as o
on c.customerID = o.customerID
INNER JOIN PAYMENTS AS P 
on o.orderID = p.orderID
where p.status = "success"
group by customerID, Name
having total_amount > 50000
order by total_amount desc ;

select c.categoryID, categoryname,
count(p.productID) as num_pd,
avg(mrp) as avg_mrp,
avg(sellingprice) as avg_sp
from products as p
inner join categories as c
on p.categoryID = c.categoryID
group by c.categoryID, categoryname
having num_pd >= 5 ;

select s.supplierName, 
count(distinct p.productID) as num_of_pd,
count(orderitemID) as num_of_odit,
coalesce(sum(total), 0) as total_sales,
coalesce(sum(quantity), 0) as total_quantity
from products as p
left join suppliers as s
on p.supplierId = s.supplierID
left join order_items as oi
on p.productID = oi.productId
group by supplierName
order by total_sales desc ;

select warehouse,
count(orderID) as num_order,
sum(stock) as total_inventory_stock,
round(avg(stock), 2) as total_inventory_stock
from warehouses as w
left join inventory as i
on w.WarehouseID = i.warehouseId
left join orders as o
on o.warehouseID = i.warehouseId
group by warehouse ;

select c.categoryID, categoryName,
round(avg(sellingprice), 2) as avg_sellingprice
from products as p
inner join categories as c
on p.categoryID = c.categoryID
group by c.categoryID, categoryName
order by avg_sellingprice desc
LIMIT 1 ;

SELECT supplierName, productName,
rank()  over(partition by s.supplierID order by sellingprice DESC) as selling_rank
from products as p
inner join suppliers as s
on p.supplierID = s.supplierID ;

select * 
from customers
where signupdate >= date_sub(now(), interval 1000 day );

select orderID, orderDate,
extract(year from orderdate ) as year_date,
extract(month from orderdate ) as month_date,
extract(day from orderdate ) as day_date
from orders
order by orderdate  ;

select
extract(year from orderdate ) as order_year,
extract(month from orderdate ) as order_month,
count(*) as count_of_order
from orders
group by order_year, order_month ;

select orderDate,
date_format(orderdate, "%M") as month
from orders ;

select sum(oi.total) as total_sales,
extract(month from o.orderdate) as order_month
from orders as o
inner join order_items as oi 
on o.orderId = oi.orderID
group by order_month ;

select  dayName(orderdate) as day_name,
count(*) as num_order
from orders 
where dayofweek(orderDate) in(1, 7)
group by day_name ;

select  dayName(orderdate) as day_name,
count(*) as num_order
from orders 
group by day_name ;

select monthname(signupdate) as name_of_month,
count(*) as num_of_customer
from customers
group by name_of_month ;
                                                                                                                                                                   
select case 
when month(orderdate) >= 7 then "second_half_year"
else "first_half_year"
end as part_of_year, 
count(*) as num_order
from orders
group by part_of_year  ;

select case 
when month(orderdate) >= 7 then "second_half_year"
else "first_half_year"
end as part_of_year,
count(*) as num_order,
sum(total) as total_sales
from orders as o
inner join order_items as oi
on o.orderID = oi.orderId 
group by part_of_year ;

select dayname(signupdate) as day_of_week,
dayofweek(signupdate) as num_of_week,
count(*) as num_of_customer
from customers
group by day_of_week , num_of_week
order by num_of_customer desc 
 limit 1  ;
 
 select monthName(orderdate) as name_of_month,
 count(*) as cuctomer_count
 from orders 
 group by name_of_month
 order by name_of_month ;
 
 select date_format(signupdate, "%Y-%m-01") as signupmonth,
 count(o.orderID) as num_of_customer
 from orders as o
 inner join customers as c
 on o.customerID = c.customerID
 group by  signupmonth 
 order by signupmonth ;
 
 select monthName(signupdate) as signupmonth,
 sum(oi.total) as total_sales
 from customers as c
 left join orders as o
 on c.customerID = o.customerID
 left join order_items as oi
 on o.orderID = oi.orderID
 group by signupmonth ;

create database data ;
use data ;

CREATE TABLE Customers (
    customer_id INT,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO Customers VALUES
(1,'Rahul','Delhi'),
(2,'Priya','Mumbai'),
(3,'Aman','Delhi'),
(4,'Neha','Pune'),
(5,'Vikas','Bangalore'),
(6,'Sneha','Chennai'),
(7,'Rohit','Jaipur'),
(8,'Anjali','Delhi'),
(9,'Pooja','Mumbai'),
(10,'Karan','Pune');

CREATE TABLE Products (
    product_id INT,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price INT
);

INSERT INTO Products VALUES
(101,'Laptop','Electronics',60000),
(102,'Mobile','Electronics',25000),
(103,'Headphones','Electronics',3000),
(104,'Shoes','Fashion',4000),
(105,'Watch','Accessories',5000),
(106,'Bag','Accessories',2000),
(107,'T-Shirt','Fashion',1000),
(108,'Tablet','Electronics',20000);

CREATE TABLE Orders (
    order_id INT,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE
);

INSERT INTO Orders VALUES
(1001,1,101,1,'2024-01-10'),
(1002,2,102,2,'2024-01-11'),
(1003,3,103,3,'2024-01-12'),
(1004,1,104,2,'2024-01-15'),
(1005,4,101,1,'2024-01-18'),
(1006,5,105,2,'2024-02-01'),
(1007,6,108,1,'2024-02-03'),
(1008,7,104,1,'2024-02-05'),
(1009,8,102,1,'2024-02-08'),
(1010,9,103,4,'2024-02-10'),
(1011,10,106,3,'2024-02-15'),
(1012,2,101,1,'2024-02-20'),
(1013,1,102,1,'2024-03-01'),
(1014,3,107,5,'2024-03-03'),
(1015,5,108,1,'2024-03-05'),
(1016,6,105,2,'2024-03-06'),
(1017,7,101,1,'2024-03-10'),
(1018,8,106,2,'2024-03-12'),
(1019,9,104,3,'2024-03-15'),
(1020,10,102,1,'2024-03-20'),
(1021,1,103,2,'2024-04-01'),
(1022,2,104,1,'2024-04-05'),
(1023,3,105,2,'2024-04-10'),
(1024,4,101,1,'2024-04-15'),
(1025,5,102,1,'2024-04-18'),
(1026,6,103,3,'2024-04-20'),
(1027,7,108,1,'2024-04-22'),
(1028,8,104,2,'2024-04-25'),
(1029,9,101,1,'2024-04-27'),
(1030,10,105,1,'2024-04-30');

use data ;
# question no 1
select (quantity * price) as total_revenue
from orders as o
inner join products as p
on o.product_id = p.product_id ;

# question no 2
select customer_id, sum(total) as total_spend 
from (select o.customer_id, quantity * price as total
from customers as c
inner join orders as o
on c.customer_id = o.customer_id
inner join products as p
on o.product_id = p.product_id) as revenue
group by customer_id 
order by total_spend desc 
limit 5 ;

# question no 3
select product_name, sum(quantity) as total_quantity_sold
from orders as o
inner join products as p
on o.product_id = p.product_id
group by product_name ;

# question no 4
select product_name, sum(total) as total_revenue
from (select product_name, (quantity * price) as total
from orders as o
inner join products as p
on o.product_id = p.product_id ) as deta
group by product_name 
order by total_revenue desc
limit 1 ;

# question no 5
select product_name, sum(total) as total_revenue
from (select product_name, (quantity * price) as total
from orders as o
inner join products as p
on o.product_id = p.product_id ) as deta
group by product_name ;

# question no 6
select city, sum(total) as revenue
from (select city, (quantity * price) as total
from orders as o
inner join products as p
on o.product_id = p.product_id 
inner join customers as c 
on o.customer_id = c.customer_id ) as deta 
group by city ;

# question no 7
select customer_name, sum(total) as total_spend 
from (select c.customer_name, quantity * price as total
from customers as c
inner join orders as o
on c.customer_id = o.customer_id
inner join products as p
on o.product_id = p.product_id) as revenue
group by customer_name
order by total_spend desc 
limit 3 ;

# question no 8
select c.customer_id, count(order_id) as total_order
from customers as c
inner join orders as o
on c.customer_id = o.customer_id
group by c.customer_id ;

# question no 9
select sum((quantity * price))/count(*) as avg
from orders as o
inner join products as p
on o.product_id = p.product_id ;

use data ;

# question no 10
select product_name, sum(quantity) as total_product
from orders as o
inner join products as p
on o.product_id = p.product_id
group by product_name ;

# question no 11
select city, customer_name, total_spend
from (select customer_name,  city, total_spend, row_number() over(partition by city order by total_spend desc) as row_num
from (select customer_name, city, sum(total) over(partition by customer_name) as total_spend
from (select customer_name, city, (quantity * price) as total
from orders as o
inner join products as p
on o.product_id = p.product_id 
inner join customers as c 
on o.customer_id = c.customer_id ) as deta1) as deta2 ) as deta3
where row_num = 1 ;

# question no 12
select customer_name, sum(total) as total_spend
from(select customer_name, (quantity * price) as total
from orders as o
inner join products as p
on o.product_id = p.product_id 
inner join customers as c 
on o.customer_id = c.customer_id ) as deta1
group by customer_name  
order by total_spend desc 
limit 1 , 1 ; 

# question no 13
select customer_name, max(order_date) as latest_order
from customers as c 
inner join orders as o
on c.customer_id = o.customer_id
group by customer_name ;

# question no 14
select product_name, sum(total) as total_revenue,
rank() over(order by sum(total) desc) as sales_rank
from (select product_name, (quantity * price) as total
from orders as o
inner join products as p
on o.product_id = p.product_id ) as deta1
group by product_name ;

# question no 15
select order_id, revenue, sum(revenue) over(order by revenue, order_id) as running_revenue
from (select order_id, (price * quantity) as revenue
from orders as o
inner join products as p
on o.product_id = p.product_id ) as deta1 ;

# question no 16
select order_id, revenue, (previous_revenue - revenue) as pre_rv_and_rv_diff
from (select order_id,  revenue,
lag(revenue, 1, 0) over(order by order_id) as previous_revenue
from(select order_id, (price * quantity) as revenue
from orders as o
inner join products as p
on o.product_id = p.product_id  ) as deta1) as deta2 ;

 # some more practice on date time function 
 
 use rr ;
 
select now() as today ;

select curdate() as ajj ;

select Name , Gender,  Age ,SignupDate
from customers 
where SignupDate >=  date_sub( signupDate, interval 1000 day) ;

select orderID,  orderDate,
extract(year from orderDate) as year
from orders ;

select orderID,  orderDate,
year(orderDate) as year
from orders ;

select orderID,  orderDate,
year(orderDate) as year,
month(orderDate) as month,
day(orderDate) as day
from orders ;
 
 select orderID,  orderDate,
extract(year from orderDate) as year,
extract(month from orderDate) as month,
extract(day from orderDate) as day
from orders ;

select count(*),
month(orderDate) as month
from orders 
group by month 
order by month desc;

select count(*),
year(orderDate) as year,
month(orderDate) as month
from orders 
group by year, month 
order by year,month ;

select curdate() - interval day(curdate()) - 1 day as today ;


select orderDate, orderDate - interval day(orderDate) - 1 day as first_month
from orders  ;

select orderDate, makedate(year(orderDate), 32) as first_year
from orders  ;

select orderDate - interval day(orderDate) - 1 day as sales_month,
sum(Total) as total_sales
from orders as o
inner join order_items as oi 
on o.orderID = oi.orderID
group by sales_month
order by sales_month ;

select month(orderDate) as sales_month,
sum(Total) as total_sales
from orders as o
inner join order_items as oi 
on o.orderID = oi.orderID
group by sales_month
order by sales_month ;

select orderDate,
datediff(curdate(), orderDate) as day
from orders ;

select dayname(curdate()) as day_name ;
select curdate() as today ;

select dayofweek(curdate() - 1) as today ;

select dayname(orderDate) as day_name,
count(*) as num_of_order
from orders 
where dayname(orderDate) in ("Sunday", "Saturday")
group by day_name ;

select case
when dayofweek(orderDate) in (1, 7) then "weekend"
else "weekday"
end as day_type ,
count(*) as num_of_order
from orders
group by day_type ;

select monthname(orderDate) as month_name,
count(*) as num_of_order
from orders
group by month_name ;

select case
when month(orderDate) <= 6 then "first_half"
else "second_half"
end as year_type,
count(*) as num_of_order
from orders
group by year_type ;

select case
when month(orderDate) <= 6 then "first_half"
else "second_half"
end as year_type,
sum(Total) as total_sales
from orders as o
inner join 
order_items as oi 
on o.orderID = oi.orderID
group by year_type ;

select dayofweek(SignupDate) as day_of_week,
dayname(signupdate) as day_name,
count(*) as num_of_customer
from customers 
group by day_of_week, day_name
order by num_of_customer desc  ;

select day(orderDate) as day,
count(*) as num_of_order
from orders 
where day(orderDate) <= 7
group by day 
order by day ;

select month(first_order) as month, year(first_order) as year
from (select o.customerID, min(o.orderDate) as first_order
from customers as c
inner join orders as o
on c.customerID = o.customerID
group by o.customerID) as data
group by year, month ;

select o.customerID, min(o.orderDate) as first_order
from customers as c
inner join orders as o
on c.customerID = o.customerID
group by o.customerID  ;

use ipl_project ;

select *
from ipl_matches as m
inner join ipl_deliveries as d
on m.match_id = d.match_id
limit 5 ;

select out_type, count(*) as total_wicket,
round(count(*) * 100/sum(count(*)) over() , 2) as wickets_percentage
from ipl_deliveries
where is_wicket = 1
group by out_type 
order by total_wicket desc ;

select fielder, count(*) as total_caught
from ipl_deliveries
where out_type = "caught"
group by fielder
order by total_caught desc 
limit 10;

select fielder, count(*) as total_stumped,
round(count(*) * 100 / sum(count(*)) over(), 2) as percentage
from ipl_deliveries
where out_type = "stumped"
group by fielder
order by total_stumped desc ;

select toss_decision, count(*) as total_matches,
sum(case when toss_winner = winner then 1 else 0 end) as won_matches,
round((sum(case when toss_winner = winner then 1 else 0 end) / count(*)) * 100, 2) as win_percentage
from ipl_matches 
group by toss_decision ;

select batter, sum(batsman_runs) as runs,
sum(case when extras_type = "wides" then 0 else 1 end) as balls,
round((sum(batsman_runs) / sum(case when extras_type = "wides" then 0 else 1 end)) * 100, 2) as strike_rate
from ipl_deliveries
where `over` >= 15
group by batter
having balls >= 300
order by strike_rate desc 
limit 10 ;

select batter, sum(batsman_runs) as runs,
sum(case when extras_type = "wides" then 0 else 1 end) as balls,
round((sum(batsman_runs) / sum(case when extras_type = "wides" then 0 else 1 end)) * 100, 2) as strike_rate
from ipl_deliveries
group by batter
having balls >= 500
order by strike_rate desc ;

select bowler, count(*) as total_wicket 
from ipl_deliveries 
where is_wicket = 1
group by bowler
order by total_wicket desc ;

select stadium_name, winner, count(*) as wins
from ipl_matches
where winner not in ("no_result")
group by stadium_name, winner 
order by wins desc ;

select batter, count(distinct m.match_id) as matches,
sum(batsman_runs) as total_runs
from ipl_matches as m
inner join ipl_deliveries as d
on m.match_id = d.match_id
where match_type not in ("3rd Place Play-Off", "League")
group by batter
order by total_runs desc
limit 10  ;

select bowler, count(distinct m.match_id) as matches, 
sum(is_wicket) as total_wicket
from ipl_matches as m
inner join ipl_deliveries as d
on m.match_id = d.match_id
where match_type not in ("3rd Place Play-Off", "League") and is_wicket = 1
group by bowler
order by total_wicket desc
limit 10  ;

select stadium_name, sum(total_runs) as total_runs
from ipl_matches as m
inner join ipl_deliveries as d
on m.match_id = d.match_id
group by stadium_name
order by total_runs desc ;

select stadium_name, d.match_id,
sum(total_runs) as match_runs
from ipl_matches as m
inner join ipl_deliveries as d
on m.match_id = d.match_id
group by stadium_name, d.match_id
order by match_runs desc
limit 10 ;