create database veu
use veu

-- Create Salesman table
CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(4,2)
);

-- Insert Salesman data
INSERT INTO salesman (salesman_id, name, city, commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', 'Berlin', 0.12),
(5007, 'Paul Adam', 'Rome', 0.13);

-- Create Customer table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT FOREIGN KEY REFERENCES salesman(salesman_id)
);

-- Insert Customer data
INSERT INTO customer (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', 300, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Camero', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007);

-- Create Orders table
CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT FOREIGN KEY REFERENCES customer(customer_id),
    salesman_id INT FOREIGN KEY REFERENCES salesman(salesman_id)
);

-- Insert Orders data
INSERT INTO orders (ord_no, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.50, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.50, '2012-08-17', 3009, 5003),
(70007, 948.50, '2012-09-10', 3005, 5002),
(70005, 2400.60, '2012-07-27', 3007, 5001),
(70008, 5760.00, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.40, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.60, '2012-04-25', 3002, 5001);

-- Fetch all records from Salesman table using view
SELECT * FROM salesman;

-- Fetch all records from Customer table
SELECT * FROM customer;

-- Fetch all records from Orders table
SELECT * FROM orders;

--1
create view one as
select * from salesman where city='New York'

select * from one

--2
create view two as 
select salesman_id, name, city from salesman 

select * from two

--3
create view three as
select * from salesman
where city='New York' and commission>0.13

select * from three

--4
create view four as
select grade,count(*) as total_customer from customer group by grade

select * from four

--5
create view five as
select ord_date,
count(customer_id) as No_of_customer_ordering, 
count(salesman_id) as No_of_salesman_attach,
avg(purch_amt) as average_amount_of_order,
sum(purch_amt) as total_order
from orders
group by ord_date

select * from five

--6
create view six as
select o.ord_no,o.purch_amt,o.ord_date,c.cust_name,s.name
from orders o
inner join customer c on o.customer_id=c.customer_id
inner join salesman s on o.salesman_id=s.salesman_id

select * from six

--7
create view seven as
select o.ord_date, s.name
from orders o
inner join salesman s on o.salesman_id=s.salesman_id
where o.purch_amt in(select max(purch_amt) from orders o2 where o2.ord_date=o.ord_date)

select * from seven

--8
create view eight as
select * from customer where grade in(select max(grade) from customer)

select * from eight

--9
create view nine as
select city, count(*) as no_of_salesman from salesman
group by city

select * from nine

--10
create view ten as
select s.name,avg(o.purch_amt) as average,sum(o.purch_amt) as total from orders o
inner join salesman s on o.salesman_id=s.salesman_id
group by s.name

select * from ten

--11
create view eleven1 as
select s.salesman_id,s.name,count(c.customer_id) as total from salesman s
inner join customer c on s.salesman_id=c.salesman_id
group by s.salesman_id,s.name
having count(c.customer_id)>1

select * from eleven1

--12
create view twelve as
select c.cust_name,s.name,c.city from customer c
inner join salesman s on c.city=s.city

select * from twelve

--13
create view thirteen as
select ord_date, count(*) as total from orders group by ord_date

select * from thirteen

--14
create view fourteen as
select s.name from orders o
inner join salesman s on o.salesman_id=s.salesman_id
where o.ord_date='2012-10-10'

select * from fourteen

--15
CREATE VIEW vw_salesmen_orders_aug_oct AS
SELECT DISTINCT s.name
FROM orders o
JOIN salesman s ON o.salesman_id = s.salesman_id
WHERE o.ord_date IN ('2012-08-17', '2012-10-10');

select * from vw_salesmen_orders_aug_oct