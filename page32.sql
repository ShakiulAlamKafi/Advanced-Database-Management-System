create database two
use two

create table Worker (
WORKER_ID int primary key not null identity,
FIRST_NAME varchar(125),
LAST_NAME varchar(125),
SALARY int,
DEPARTMENT varchar(125),
JOINING_DATE datetime
);


insert into Worker ( FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT, JOINING_DATE)
values
( 'Rana', 'Hamid', 100000, 'HR', '2014-02-20 09:00:00'),
( 'Sanjoy', 'Saha', 80000, 'Admin', '2014-06-11 09:00:00'),
( 'Mahmudul', 'Hasan', 300000, 'HR', '2014-02-20 09:00:00'),
( 'Asad', 'Zaman', 500000, 'Admin', '2014-02-20 09:00:00'),
( 'Sajib', 'Mia', 500000, 'Admin', '2014-06-11 09:00:00'),
( 'Alamgir', 'Kabir', 200000, 'Account', '2014-06-11 09:00:00'),
( 'Foridul', 'Islam', 75000, 'Account', '2014-01-20 09:00:00'),
( 'Keshob', 'Ray', 90000, 'Admin', '2014-04-11 09:00:00');

select * from Worker

--1
select substring(FIRST_NAME,1,3) as FirstName from Worker
	--or
select left(FIRST_NAME,3) as FirstName from Worker

--2
select * from Worker where JOINING_DATE>='2014-02-01' and JOINING_DATE<='2014-03-01'
	--or
select * from Worker where JOINING_DATE between '2014-02-01' and '2014-03-01'

--3
select * from Worker where datediff(MONTH, JOINING_DATE, GETDATE())>=6
	--or
select * from Worker where datediff(month,JOINING_DATE,CURRENT_TIMESTAMP) > 6;

--4
update Worker set SALARY=7000000 where DEPARTMENT='Manager'

--5
update Worker
set SALARY=case
	when JOINING_DATE< '2014-04-11 09:00:00'
		then SALARY*1.1
	else
		SALARY*1.05
	end
where DEPARTMENT='Admin'

--7
select * from Worker where FIRST_NAME in ('Rana','Sajib')

--8
select * from Worker where FIRST_NAME not in ('Rana','Sajib')

--9
select * from Worker where FIRST_NAME like '%a%'

--10
select * from Worker where FIRST_NAME like 'k%'

--11
select * from Worker where FIRST_NAME like '%______r';
	--or
select * from Worker where FIRST_NAME like '%r'and len(FIRST_NAME)=7

--12
select CHARINDEX('n',FIRST_NAME) as position from Worker where FIRST_NAME='Sanjoy'

--13
select DEPARTMENT, avg(SALARY) as Average_Salary from Worker group by DEPARTMENT

--14
select * from Worker inner join
(select max(SALARY) as maximum, min(SALARY) as minimum, DEPARTMENT from Worker group by DEPARTMENT) as temp
on(Worker.SALARY=temp.maximum or Worker.SALARY=temp.minimum)
where Worker.DEPARTMENT=temp.DEPARTMENT

--15
select CHARINDEX('r',FIRST_NAME) as position from Worker where FIRST_NAME='Rana'

--16
select rtrim(FIRST_NAME) as FirstName from Worker

--17
select distinct FIRST_NAME as FirstName, len(FIRST_NAME) as LengthofFirstName from Worker

--18
select REPLACE(FIRST_NAME, 'a', 'A') as ReplacedName from Worker