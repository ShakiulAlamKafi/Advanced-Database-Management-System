create database functionPractice
use functionPractice


CREATE TABLE Tbl_Management (
    Mgt_id VARCHAR(10) PRIMARY KEY,
    Mgt_Name VARCHAR(50),
    Joining_date DATE,
    Salary INT,
    Position VARCHAR(50)
);

INSERT INTO Tbl_Management (Mgt_id, Mgt_Name, Joining_date, Salary, Position)
VALUES 
('M2015', 'Keshob', '2001-01-18', 250000, 'Managing Director'),
('M2016', 'Rana', '2003-01-30', 180000, 'Secretary'),
('M2017', 'Jasim', '2004-04-12', 150000, 'Join secretary'),
('M2018', 'Rajon', '2004-06-18', 140000, 'Join secretary');
select * from Tbl_Management


CREATE TABLE Tbl_Emp (
    Emp_id VARCHAR(10) PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Division VARCHAR(50),
    Joining_Date DATE,
    Salary INT
);

INSERT INTO Tbl_Emp (Emp_id, Emp_Name, Division, Joining_Date, Salary)
VALUES 
('E1001', 'Suman', 'Software', '2003-04-25', 92000),
('E1002', 'Rasel', 'Network', '2004-03-13', 86000),
('E1003', 'Hossain', 'Software', '2004-06-21', 82000),
('E1004', 'Polash', 'Network', '2005-05-05', 98000);
select * from Tbl_Emp

CREATE TABLE Tbl_Project (
    P_id VARCHAR(10) PRIMARY KEY,
    P_Name VARCHAR(100),
    Mgt_id VARCHAR(10),
    E_id VARCHAR(10),
    P_Cost INT,
    Delivery_date DATE,
    FOREIGN KEY (Mgt_id) REFERENCES Tbl_Management(Mgt_id),
    FOREIGN KEY (E_id) REFERENCES Tbl_Emp(Emp_id)
);

INSERT INTO Tbl_Project (P_id, P_Name, Mgt_id, E_id, P_Cost, Delivery_date)
VALUES 
('P3001', 'Office Automation', 'M2016', 'E1001', 2050000, '2016-05-08'),
('P3002', 'Repair Hub', 'M2016', 'E1004', 1200000, '2017-06-14'),
('P3003', 'Server Installation', 'M2018', 'E1001', 1500500, '2018-02-13'),
('P3004', 'Network setup', 'M2017', 'E1002', 2505000, '2018-03-12');
select * from Tbl_Project

--1
select p.P_id, e.Emp_Name, p.P_Cost, rank() over(order by p.P_Cost asc)
from Tbl_Project p inner join Tbl_Emp e on p.E_id=e.Emp_id
order by p.P_Cost asc

--2
create function fnProjectEmployeeDetails1
(
    @P_Name varchar(90),
    @Emp_Name varchar(90)
)
returns table
as
return
(
select p.P_Name, e.Emp_Name, p.P_Cost
from Tbl_Project p inner join Tbl_Emp e on p.E_id=e.Emp_id
where p.P_Name=@P_Name and e.Emp_Name=@Emp_Name
);
SELECT * FROM fnProjectEmployeeDetails1('Repair Hub', 'Polash') order by P_Cost asc;

--3
select Mgt_Name, Joining_date,rank() over(order by Joining_date) as Mgt_Rank
from Tbl_Management

--4
create function fnMaxSalaryIncrease(@Salary decimal(12,2))
returns decimal(12,2)
as
begin

    declare @result decimal(12,2);

    select @result=max(Salary) from Tbl_Emp
    where Salary=@Salary

    return @result
end
select dbo.fnMaxSalaryIncrease((select max(Salary) from Tbl_Emp))

--5
create function fnMaxCostProject
(
)
returns table
as
return
(
select top 1 P_Name from Tbl_Project order by P_Cost desc
)
select * from fnMaxCostProject()
--6
create function fnProjectCostRange2 
(
    @min_cost decimal(12,2),
    @max_cost decimal(12,2)
)
returns table
as
return
(
select P_Name,P_Cost
from Tbl_Project
where P_Cost between @min_cost and @max_cost
);
select * from fnProjectCostRange2(1200000, 2050000)

--7
create function fnEmployee
(
@P_id varchar(20),
@Mgt_id varchar(20),
@Emp_id varchar(20)
)
returns table
as
return
(
select m.Mgt_id, m.Mgt_Name, 
e.Emp_Name, e.Joining_Date, e.Salary, p.P_Name, p.P_Cost, p.Delivery_date
from Tbl_Management m inner join Tbl_Project p on p.Mgt_id=m.Mgt_id
inner join Tbl_Emp e on p.E_id=e.Emp_id
where p.P_id=@P_id and m.Mgt_id=@Mgt_id and e.Emp_id=@Emp_id
)
select * from fnEmployee('P3001','M2016','E1001')