create database one
use one
--Lab Assignment 1
	--1
	create table Worker(
	WORKER_ID int not null,
	FIRST_NAME varchar(15),
	LAST_NAME varchar(15),
	SALARY int,
	DEPT_NAME varchar(10)
	);
	--2
	alter table Worker add JOINING_DATE datetime;
	--3
	alter table Worker alter column SALARY decimal(10,2);
	--4
	exec sp_rename 'Worker.DEPT_NAME','DEPARTMENT','COLUMN';
	--5
	alter table Worker alter column DEPARTMENT varchar(20);
--Lab Assignment 2
	--1
	alter table Worker alter column FIRST_NAME varchar(15) null;
	alter table Worker alter column LAST_NAME varchar(15) null;
	alter table Worker alter column SALARY decimal(10,2) null;
	alter table Worker alter column DEPARTMENT varchar(20) null;
	alter table Worker alter column JOINING_DATE datetime null;
	--2
	alter table Worker add constraint ck_worker_salary check(SALARY>100);
	--3
	alter table Worker add constraint uq_worker_firstname unique(FIRST_NAME);
	--4
	alter table Worker add constraint pk_worker primary key(WORKER_ID);
--Lab Assignment 3
	--1
	INSERT INTO Worker VALUES
(1,'Rana','Hamid',100000,'HR','2014-02-20 09:00:00'),
(2,'Sanjoy','Saha',80000,'Admin','2014-06-11 09:00:00'),
(3,'Mahmudul','Hasan',300000,'HR','2014-02-20 09:00:00'),
(4,'Asad','Zaman',500000,'Admin','2014-02-20 09:00:00'),
(5,'Sajib','Mia',500000,'Admin','2014-06-11 09:00:00'),
(6,'Alamgir','Kabir',200000,'Account','2014-06-11 09:00:00'),
(7,'Foridul','Islam',75000,'Account','2014-01-20 09:00:00'),
(8,'Keshob','Ray',90000,'Admin','2014-04-11 09:00:00'),
(9,'Imran','Hossain',120000,'HR','2015-01-01 09:00:00'),
(10,'Rakib','Ahmed',110000,'Admin','2016-03-15 09:00:00');

	--2
	SELECT * FROM Worker;
	--3
	select top 5 WORKER_ID,FIRST_NAME+' '+LAST_NAME as FULL_NAME,
	SALARY,DEPARTMENT,JOINING_DATE from Worker order by WORKER_ID;
	--4
	select * from Worker where DEPARTMENT='Admin';
	--5
	select FIRST_NAME+' '+LAST_NAME as FULL_NAME, SALARY from Worker 
	where SALARY>10000;
	--6
	select FIRST_NAME+' '+LAST_NAME as FULL_NAME, SALARY from Worker 
	where SALARY>(select SALARY from Worker where FIRST_NAME='Sanjoy');
	--7
	update Worker set SALARY=95000 where WORKER_ID=8
	--8
	delete from Worker where FIRST_NAME='Asad';