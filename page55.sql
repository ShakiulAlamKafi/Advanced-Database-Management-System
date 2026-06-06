create database five
use five

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

-- Insert into Branch
INSERT INTO Branch VALUES
('B-101', 'Bonani'),
('B-102', 'Romna'),
('B-103', 'Shaheb bazar'),
('B-104', 'Ullapara');

-- Insert into Account_Detail
INSERT INTO Account_Detail VALUES
(1992212, 'Mr. Nazmuzzaman', 200000, 'B-101', 'Z-803'),
(1992213, 'Mr. Jibon', 170000, 'B-102', 'Z-803'),
(1882212, 'Bushra', 180000, 'B-103', 'Z-802'),
(1882213, 'Sajib', 170000, 'B-104', 'Z-801');

--1
create proc SPdetails
as 
begin
    select Acc_holder_name, Amount, Branch_Name, Name from Account_Detail
    inner join Branch on Account_Detail.Branch_Id=Branch.Br_Id
    inner join Zone on Account_Detail.Zone_Id=Zone.Zone_Id
end

Exec SPdetails

--or
CREATE PROCEDURE SPdetails
AS
BEGIN
    SELECT 
        A.Acc_holder_name, 
        A.Amount, 
        B.Branch_Name, 
        Z.Name AS Zone_Name
    FROM Account_Detail A
    INNER JOIN Branch B ON A.Branch_Id = B.Br_Id
    INNER JOIN Zone Z ON A.Zone_Id = Z.Zone_Id;
END;

Exec SPdetails

--2
create proc SPaverage
@Branch_name varchar(20),
@Amount int
as 
begin
    select Branch_Name, Amount from Account_Detail
    inner join Branch on Account_Detail.Branch_Id=Branch.Br_Id
    where Branch.Branch_Name=@Branch_name and Account_Detail.Amount>@Amount
end

Exec SPaverage 'Bonani', 17000

--3
create proc SPbalance2
@Zone_Name varchar(20)
as
begin
    declare @total int
    select @total=sum(Account_Detail.Amount) from Account_Detail
    inner join Zone on Account_Detail.Zone_Id=Zone.Zone_Id
    where Zone.Name=@Zone_Name

    return ISNULL(@total,0)
end

declare @Result int
exec @Result=SPbalance2 @Zone_Name='Dhaka'
select @Result

--or
CREATE PROCEDURE SPbalance1
    @zone_name VARCHAR(50)
AS
BEGIN
    DECLARE @TotalAmount INT;

    SELECT @TotalAmount = SUM(A.Amount)
    FROM Account_Detail A
    INNER JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
    WHERE Z.Name = @zone_name;

    -- Returns an integer value
    RETURN ISNULL(@TotalAmount, 0); 
END;

-- To see a RETURN value, you must declare a variable to catch it
DECLARE @Result INT;
EXEC @Result = SPbalance1 @zone_name = 'Dhaka';
SELECT @Result AS Total_Zone_Amount;

--4
create proc SPamount
as
begin
    declare @maximum int
    select @maximum=max(amount) from Account_Detail
    select Acc_holder_name, Branch_Name, Name from Account_Detail
    inner join Branch
    on Account_Detail.Branch_Id=Branch.Br_Id
    inner join Zone
    on Account_Detail.Zone_Id=Zone.Zone_Id
    where Account_Detail.Acc_holder_name like '%Mr.%' and Account_Detail.Amount<@maximum
end

Exec SPamount

--5
create proc SPdetailsInfo
@Zone_Name varchar(20),
@customer_count int output
as
begin
    select @customer_count=count(Account_Detail.Account_no) from Account_Detail
    inner join Zone on Account_Detail.Zone_Id=Zone.Zone_Id
end

declare @result int
exec SPdetailsInfo @Zone_Name='Dhaka', @customer_count=@result output
select @result

--6
create proc spEmployeeSalaryDetails1
@StartAmount int,
@EndAmount int,
@Branch_Name varchar(20),
@Branch_Count int output
as
begin
    select @Branch_Count=count(Account_Detail.Account_no) from Account_Detail
    inner join Branch on Account_Detail.Branch_Id=Branch.Br_Id
    where Branch.Branch_Name=@Branch_Name and Account_Detail.Amount between @StartAmount and @EndAmount
end

declare @total int
EXEC spEmployeeSalaryDetails1 
    @StartAmount = 150000, 
    @EndAmount = 250000, 
    @Branch_Name = 'Bonani', 
    @Branch_Count = @total OUTPUT;

SELECT @total AS Branch_Match_Count;

--7
create proc SPDetailsInfo7
@Zone_Name varchar(20)
as
begin
    select Name, count(Account_no) from Account_Detail
    inner join Zone on Account_Detail.Zone_Id=Zone.Zone_Id
    where Zone.Name=@Zone_Name
    group by Zone.Name
end

exec SPDetailsInfo7 'Rajshahi'

--8
CREATE PROCEDURE SPdetailsInfo1
    @zone_name VARCHAR(50)
AS
BEGIN
    SELECT 
        Z.Name AS Zone_name, 
        COUNT(DISTINCT A.Branch_Id) AS number_of_Branch
    FROM Account_Detail A
    INNER JOIN Zone Z ON A.Zone_Id = Z.Zone_Id
    WHERE Z.Name = @zone_name
    GROUP BY Z.Name;
END;

EXEC SPdetailsInfo1 @zone_name = 'Dhaka';