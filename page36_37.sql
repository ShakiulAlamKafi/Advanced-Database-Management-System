create database three
use three

CREATE TABLE Worker2 (
    WORKER_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    SALARY INT,
    DEPARTMENT VARCHAR(50),
    JOINING_DATE DATETIME
);

INSERT INTO Worker2 VALUES
(1,'Rana','Hamid',100000,'HR','2024-02-20'),
(2,'Sanjoy','Saha',80000,'Admin','2024-06-11'),
(3,'Mahmudul','Hasan',300000,'HR','2024-02-20'),
(4,'Asad','Zaman',500000,'Admin','2024-02-20'),
(5,'Sajib','Mia',500000,'Admin','2024-06-11'),
(6,'Alamgir','Kabir',200000,'Account','2024-06-11'),
(7,'Foridul','Islam',75000,'Account','2024-01-20'),
(8,'Keshob','Ray',90000,'Admin','2024-04-11');

select * from Worker2

CREATE TABLE Bonus (
    WORKER_REF_ID INT,
    BONUS_DATE DATETIME,
    BONUS_AMOUNT INT
);

INSERT INTO Bonus VALUES
(1,'2019-02-20',5000),
(2,'2019-06-11',3000),
(3,'2019-02-20',4000),
(4,'2019-02-20',4500),
(5,'2019-06-11',3500),
(6,'2019-06-12',NULL);

CREATE TABLE Title (
    WORKER_REF_ID INT,
    WORKER_TITLE VARCHAR(50),
    AFFECTED_FROM DATETIME
);

INSERT INTO Title VALUES
(1,'Manager','2019-02-20'),
(2,'Executive','2019-06-11'),
(8,'Executive','2019-06-11'),
(5,'Manager','2019-06-11'),
(4,'Asst. Manager','2019-06-11'),
(7,'Executive','2019-06-11'),
(6,'Lead','2019-06-11'),
(3,'Lead','2019-06-11');

--1
select Worker2.* from Worker2 inner join Title
on Worker2.WORKER_ID=Title.WORKER_REF_ID
where WORKER_TITLE not in('Manager','Asst. Manager')

--2
select Worker2.* from Worker2 inner join Title
on Worker2.WORKER_ID=Title.WORKER_REF_ID
where Worker2.JOINING_DATE>'2024-04-30'
order by Title.WORKER_TITLE asc

--3
select count(*) as TotalEmployee from Worker2 where DEPARTMENT='Admin'

--4
select FIRST_NAME+' '+LAST_NAME as FullName from Worker2 where SALARY>=50000 and SALARY<=100000
 --or
 select FIRST_NAME+' '+LAST_NAME as FullName from Worker2 where SALARY between 50000 and 100000

--5
select DEPARTMENT, count(*) as TotalEmployee from Worker2 group by DEPARTMENT order by TotalEmployee desc

--6
select Worker2.* from Worker2 inner join Title
on Worker2.WORKER_ID=Title.WORKER_REF_ID
where Title.WORKER_TITLE='Manager'

--7
select Worker2.* from Worker2 where WORKER_ID%2=1

--8
select Worker2.* from Worker2 where WORKER_ID%2=0

--9
select * into Worker_copy from Worker2

--10
select GETDATE()

--11
select top 10 Worker2.FIRST_NAME, Worker2.LAST_NAME, Worker2.DEPARTMENT from Worker2
inner join Title
on Worker2.WORKER_ID=Title.WORKER_REF_ID

--12
select distinct SALARY from Worker2
order by SALARY DESC
OFFSET 4 ROWS FETCH NEXT 1 ROW ONLY

--13
select * from Worker2
where SALARY in(
select SALARY from Worker2
group by SALARY having count(*)>1)

--14
select distinct SALARY from Worker2
order by SALARY DESC
OFFSET 1 ROW FETCH NEXT 1 ROW ONLY

--15
select top (select count(*)/2 from Worker2) * from Worker2

--16
select DEPARTMENT,count(*) from Worker2 group by DEPARTMENT having count(*)<5

--17
select DEPARTMENT,count(*) from Worker2 group by DEPARTMENT

--18
select top 1 * from Worker2 order by Worker_ID desc

--19
select top 1 * from Worker2 order by Worker_ID asc

--20
select top 5 * from Worker2 order by Worker_ID desc

--21
select DEPARTMENT, FIRST_NAME+' '+LAST_NAME as FULL_NAME
from Worker2 where SALARY in (select max(SALARY) from Worker2 group by DEPARTMENT)

--22
select distinct TOP 3 SALARY from Worker2
order by SALARY DESC