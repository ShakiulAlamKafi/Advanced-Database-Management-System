create database sp
use sp

-- Zone Table
CREATE TABLE Zone (
    Zone_Id VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50)
);

-- Branch Table
CREATE TABLE Branch (
    Br_Id VARCHAR(10) PRIMARY KEY,
    Branch_Name VARCHAR(50)
);

-- Account Detail Table
CREATE TABLE Account_Detail (
    Account_no INT PRIMARY KEY,
    Acc_holder_name VARCHAR(100),
    Amount int,
    Branch_Id VARCHAR(10),
    Zone_Id VARCHAR(10),
    
    FOREIGN KEY (Branch_Id) REFERENCES Branch(Br_Id),
    FOREIGN KEY (Zone_Id) REFERENCES Zone(Zone_Id)
);
-- Insert into Zone
INSERT INTO Zone VALUES
('Z-801', 'Sirajgonj'),
('Z-802', 'Rajshahi'),
('Z-803', 'Dhaka'),
('Z-804', 'Chittagong');
select * from Zone
-- Insert into Branch
INSERT INTO Branch VALUES
('B-101', 'Bonani'),
('B-102', 'Romna'),
('B-103', 'Shaheb bazar'),
('B-104', 'Ullapara');
select * from Branch
-- Insert into Account_Detail
INSERT INTO Account_Detail VALUES
(1992212, 'Mr. Nazmuzzaman', 200000, 'B-101', 'Z-803'),
(1992213, 'Mr. Jibon', 170000, 'B-102', 'Z-803'),
(1882212, 'Bushra', 180000, 'B-103', 'Z-802'),
(1882213, 'Sajib', 170000, 'B-104', 'Z-801');
select * from Account_Detail

--1
create proc SPdetails
as
begin
    select a.Acc_holder_name,a.Amount,b.Branch_Name,z.Name
    from Account_Detail a
    inner join Branch b on a.Branch_Id=b.Br_Id
    inner join Zone z on a.Zone_Id=z.Zone_Id
end

exec SPdetails

--2
create proc SPaverage
@Branch_Name varchar(20),
@Amount decimal(12,2)
as
begin
    select a.Amount,b.Branch_Name
    from Account_Detail a
    inner join Branch b on a.Branch_Id=b.Br_Id
    where b.Branch_Name=@Branch_Name and a.Amount>@Amount
end

exec SPaverage @Branch_Name='Bonani', @Amount=17000

--3
CREATE PROCEDURE SPbalance1
    @zone_name VARCHAR(50)
AS
BEGIN
    DECLARE @TotalAmount INT;

    SELECT @TotalAmount = SUM(A.Amount)
    FROM Account_Detail A
    INNER JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
    WHERE Z.Name = @zone_name;

    RETURN ISNULL(@TotalAmount, 0); 
END;

DECLARE @Result INT;
EXEC @Result = SPbalance1 @zone_name = 'Dhaka';
print @Result;

--4
create proc SPamount
as
begin
    declare @maximum decimal(12,2)
    select @maximum=max(Amount) from Account_Detail
    select a.Acc_holder_name,b.Branch_Name,z.Name
    from Account_Detail a
    inner join Branch b on a.Branch_Id=b.Br_Id
    inner join Zone z on a.Zone_Id=z.Zone_Id
    where a.Acc_holder_name like '%Mr.%' and a.Amount<@maximum
end

exec SPamount

--5
create proc SPdetailsInfo
@Zone_Name varchar(20),
@customer_count int output
as
begin
    select @customer_count=count(*)
    from Account_Detail a
    inner join Zone z on a.Zone_Id=z.Zone_Id
    where z.Name=@Zone_Name
end

declare @total_customer int 
exec SPdetailsInfo @Zone_Name='Dhaka', @customer_count=@total_customer output
print @total_customer

--6
create proc SPEmployeeSalaryDetails1
@start_amount decimal(12,2),
@end_amount decimal(12,2),
@Branch_Name varchar(20),
@Branch_count int output
as
begin
    select @Branch_Name=count(*)
    from Account_Detail a
    inner join Branch b on a.Branch_Id=b.Br_Id
    where a.Amount between @start_amount and @end_amount and b.Branch_Name=@Branch_Name
end

declare @total int
exec SPEmployeeSalaryDetails1 @start_amount=100000, @end_amount=200000,
@Branch_Name='Shaheb bazar', @Branch_count=@total output
print @total

--7
create proc SPdetailsInfo1
@Zone_Name varchar(20)
as
begin
    select count(*),z.Name
    from Account_Detail a
    inner join Zone z on a.Zone_Id=z.Zone_Id
    group by z.Name
end

exec SPdetailsInfo1 @Zone_Name='Dhaka'

--8
create proc SPdetailsInfo2
@Zone_Name varchar(20)
as
begin
    select count(distinct b.Br_Id),z.Name
    from Branch b
    inner join Account_Detail a on Br_Id=a.Branch_Id
    inner join Zone z on a.Zone_Id=z.Zone_Id
    where z.Name=@Zone_Name
    group by z.Name
end

exec SPdetailsInfo2 @Zone_Name='Dhaka'