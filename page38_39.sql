create database four
use four

CREATE TABLE Teacher (
    TID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Dept VARCHAR(50),
    Age INT,
    Salary INT
);

CREATE TABLE Department (
    deptID INT PRIMARY KEY,
    deptName VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO Teacher VALUES
(1, 'Mizanur', 'Rahman', 'CSE', 28, 35000),
(2, 'Delwar', 'Hossain', 'CSE', 26, 33000),
(3, 'Shafiul', 'Islam', 'EEE', 24, 30000),
(4, 'Faisal', 'Imran', 'CSE', 30, 50000),
(5, 'Ahsan', 'Habib', 'English', 28, 28000);

INSERT INTO Department VALUES
(1, 'CSE', 'Talaimari'),
(2, 'EEE', 'Talaimari'),
(3, 'English', 'Kajla'),
(4, 'BBA', 'Talaimari');

--1
update Teacher
    set Salary=case
        when Dept='CSE'
            then Salary*1.15
        else
            Salary*1.1
    END

--2
select * into Teacher_copy from Teacher
where TID in(select TID from Teacher)

--3
select FirstName+' '+LastName as FullName, age
from Teacher where Salary in(
select max(Salary) from Teacher)

--4
select FirstName, Age, Dept from Teacher
where Age between 23 and 27

--5
select TID, FirstName from Teacher
where Salary<(select avg(Salary) from Teacher)

--6
update Teacher set Dept='English' where Dept in(
select deptName from Department where deptName='EEE')

--7
update Teacher set Salary=Salary*100
where TID in(select TID from Teacher where Salary>5000)

--8
select FirstName from Teacher
where TID in(
select TID from Teacher 
where FirstName like 'd%' or FirstName like 'f%')

--9
select FirstName, Salary from Teacher
where Dept='CSE' and Salary>(
select Salary from Teacher where FirstName='Delwar' and LastName='Hossain')

--10
select TID,FirstName+' '+LastName as FullName from Teacher
where Dept in(select Dept from Teacher
where FirstName='Mizanur')

--11
select Teacher.TID, Teacher.Salary, Department.deptID
from Teacher inner join Department
on Teacher.Dept=Department.deptName
where Teacher.Salary>(select avg(Salary) from Teacher)

--12
select Dept,min(Salary) from Teacher
group by Dept
having min(Salary)<(select avg(Salary) from Teacher)

--13
select FirstName+' '+LastName as FullName, Dept from Teacher
where Dept in(select deptName from Department where location='Kajla')

--14
select TID, FirstName, Salary from Teacher
where len(FirstName)>=6