create database six
use six


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

--1
select P_Name,P_Cost,rank() over(order by P_Cost asc) as cost_rank
from Tbl_Project inner join Tbl_Emp ON Tbl_Project.E_id = Tbl_Emp.Emp_id
order by Tbl_Project.P_Cost asc

--2
CREATE FUNCTION fnProjectEmployeeDetails 
(
    @ProjectName VARCHAR(100), 
    @EmployeeName VARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(
    -- Inline functions cannot use ORDER BY without TOP, so we use TOP 100 PERCENT
    SELECT TOP 100 PERCENT 
        p.P_Name, 
        p.P_Cost, 
        e.Emp_Name
    FROM Tbl_Project p
    JOIN Tbl_Emp e ON p.E_id = e.Emp_id
    WHERE p.P_Name = @ProjectName AND e.Emp_Name = @EmployeeName
    ORDER BY p.P_Cost ASC
);
SELECT * FROM dbo.fnProjectEmployeeDetails('Repair Hub', 'Polash');

--3
select Mgt_Name, Joining_date, rank() over(order by Joining_date asc) AS Mgt_Rank 
FROM Tbl_Management;

--6
CREATE FUNCTION fnProjectCostRange 
(
    @MinCost INT, 
    @MaxCost INT
)
RETURNS TABLE
AS
RETURN 
(
    SELECT P_Name, P_Cost
    FROM Tbl_Project
    WHERE P_Cost BETWEEN @MinCost AND @MaxCost
);
 SELECT * FROM dbo.fnProjectCostRange(1200000, 2050000);

--7
CREATE FUNCTION fnEmployee 
(
    @P_id VARCHAR(10), 
    @Mgt_id VARCHAR(10), 
    @Emp_id VARCHAR(10)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        m.Mgt_id, 
        m.Mgt_Name, 
        e.Emp_Name, 
        e.Joining_Date, 
        e.Salary, 
        p.P_Name, 
        p.P_Cost, 
        p.Delivery_date
    FROM Tbl_Project p
    JOIN Tbl_Management m ON p.Mgt_id = m.Mgt_id
    JOIN Tbl_Emp e ON p.E_id = e.Emp_id
    WHERE p.P_id = @P_id 
      AND m.Mgt_id = @Mgt_id 
      AND e.Emp_id = @Emp_id
);

SELECT * FROM dbo.fnEmployee('P3001', 'M2016', 'E1001');