--SQL Querry Based Project(DQL,DDL,DML,DCL,TSQL)


---Answer-1 Create a database with Antrix_Project, and make below structure into this database.

Create Database Antrix_Project
use Antrix_Project

---Answer-2 Create Table with name of “timetable”
/*Define the table design as follow:
Column Name	Data type
CDate	Datetime
Starting time	Datetime
Ending time	Datetime
Course name	Varchar(20)
Lesson topic	Varchar(100)
Room No	Int*/

Create Table Timetable
(
CDate datetime,
Starting_time datetime,
Ending_time datetime,
Course_name varchar(20),
Lesson_topic varchar(20),
Room_no int
)

select * from Timetable

---Answer-3 Modify above table and do following activities:
---3(a) Add new columns with the name of Teachers’ Name with varchar(20)
alter table Timetable
add Teachers_name varchar(20)

---3(b) Change the datatype of Room No to varchar(5) from Int
alter table Timetable
alter column Room_no varchar(5)

---3(c) Drop the column “Lesson topic” from table
alter table Timetable
drop column Lesson_topic

---Answer-4 Create Table with name of “Product”
/*Define the table design as follow:
Column Name	Data type	
Product_id	Int	Identity(1,1) + Primary Key
Product_Name	Varchar(12)	Unique Key
Product_Rate	Money	Check with Amount Always >0
Product_Location	Varchar(12)	Check  from List (‘Delhi’, ’Mumbai’)
Product_Manager_Id	Int	Foreign Key with Employee Table and Employee_Id*/


Create Table Product
(
Product_id int identity(1,1) Primary key,
Product_name varchar(12) Unique,
Product_rate money check (Product_rate>0),
Product_location varchar(12) check (Product_location in('Delhi','Mumbai')),
Product_Manager_id int foreign key references Employee(Employee_id)
)

Select * from Product


--Answer-5 Create Table with name of “Department”
/*Define the table design as follow:
Column Name	Data type	
Department_id	Int	Identity(111,1) + Primary Key
Department_Name	Varchar(12)	Unique Key
Head_Quarter	Varchar(12)	Default ‘Bangaluru’*/

Create table Department
(
Department_id int identity(111,1) Primary Key,
Department_name varchar(12) Unique,
Head_quater varchar(12) default 'Bengaluru'
)

Select * from Department


---Answer-6 Create Table with name of “Employee”
/*Define the table design as follow:
Column Name	Data type	
Employee_Id	Int	Identity(21,1) + Primary Key
Employee_Name	Varchar(12)	Unique Key
Employee_Age	Int	Check with Age Always >18
Employee_Salary	Money	
Department_Id	Int	Foreign Key with Department Table and Department Id */

Create Table Employee
(
Employee_id int identity(21,1) Primary Key,
Employee_name varchar(12) Unique,
Employee_age int Check (Employee_age>18),
Employee_Salary money,
Department_id int foreign key references Department(Department_id)
)

Select * from Employee


---Answer-7 Create Table with name of “Sales”
/*Define the table design as follow:
Column Name	Data type	
Sales_id	Int	Identity(71,1) + Primary Key
Product_Id	Int	Foreign Key with Product Table
Employee_Id	Int	Foreign Key with Employee Table
Unit_Sold	Int	
Product_Manager_Id	Int	Foreign Key with Employee Table
Order Date	Date	Default current date*/

Create Table Sales
(
Sales_id int identity(71,1) Primary Key,
Product_id int foreign key references Product(Product_id),
Employee_id int foreign key references Employee(Employee_id),
Unit_sold int,
Product_Manager_id int foreign key references Employee(Employee_id),
Order_date date default getdate()
)

Select * from Sales
Go


---Answer-8 Write SQL Statement to create a view with the name vwSalesReport with below fields
/*
a.	Product_Name
b.	Employee_Name
c.	Unit_Sold
d.	Product_Rate
e.	Sales_Amount (Unit *Rate)
*/

Create view VWSalesReport
as
Select pd.Product_name,Emp.Employee_name,sl.Unit_sold,pd.Product_rate,sl.Unit_sold*pd.Product_rate as 'Sales_Amount' from Product as pd
Join Employee as Emp
ON Emp.Employee_id = pd.Product_Manager_id
Join Sales as sl
ON Emp.Employee_id = sl.Employee_id
Go

Select * from VWSalesReport
Go

---Answer-9	Write SQL Statement to create a stored procedure insert into Product table.

Alter proc spInsertData(@Product_name varchar(12), @Product_rate money, @Product_location varchar(12), @Product_Manager_id int)
as
begin
	insert into Product(Product_name, Product_rate,Product_location,Product_Manager_id) Values(@Product_name, @Product_rate, @Product_location, @Product_Manager_id)
end

exec spInsertData 'Gaurav', 1200, 'Mumbai', 2
Go

---------------------------
Select * from Product
Go

---Answer-10 Write SQL Statement to create a stored procedure to accept Employee_Id as input and show below mentioned columns
/*
a.	Employee_Name
b.	Total_Unit_Sold
c.	Total_Sales_Amount (Unit *Rate)
*/

Alter proc spInsertEmployee_id(@Emp_id int)
as
begin
	Select Emp.Employee_name,sl.Unit_sold as 'Total_Units_Sold', sl.Unit_sold*Prd.Product_rate as 'Total_Sales_Amount' from Employee as Emp
	Join Sales as sl 
	On Emp.Employee_id = sl.Employee_id
	Join Product as Prd
	On Emp.Employee_id = Prd.Product_Manager_id Where Emp.Employee_id = @Emp_id
	
end

exec spInsertEmployee_id 4
Go

---Answer-11 Write SQL Statement to create a function to accept product rate and return the type of product category with below logic
/*
a.	If Product Rate greater than 5000, show product category as Gold
b.	If Product Rate between 5000-3000, show product category as Silver, otherwise category Basic to be shown
*/

Create function getProductCategory(@Product_rate money)
returns varchar(12)
as
begin
	declare @return_value varchar(12)

	set @return_value = 'Basic'

	if @Product_rate > 5000 set @return_value = 'Gold'

	else if @Product_rate between 3000 and 5000 set @return_value = 'Silver'
	
	return @return_value
end
Go
------------
Select dbo.getProductCategory(5100) as 'Product_Category'
Go
-------------


---Answer-12 Write SQL Statement to create a function to accept two numbers and return the division of two numbers, we need to make a provision to handle error, if there is error of divide by zero, return 0 as output.

---Creating Function for Divide two Numbers
Alter function DivisionProblem(@num1 int, @num2 int)
returns int
as
begin
	declare @result int
	Set @result = @num1/@num2
	return @result
end
Go

-----------------
---making try and catch block for error handling
begin try
	select dbo.DivisionProblem(10,0) as 'Result'
end try

begin catch
	Select 0 as 'Result'
end catch
Go
------------------

---Answer-13 Write SQL Statement to create a table function to accept Employee Id and showing below columns as output
/*
a.	Product_Name
b.	Employee_Name
c.	Unit_Sold
d.	Product_Rate
e.	Sales_Amount (Unit *Rate)
*/

Alter function getEmpDetails(@Emp_id int)
returns Table
as
return Select Prd.Product_name, Emp.Employee_name, sl.Unit_sold, Prd.Product_rate, sl.Unit_sold * Prd.Product_rate as 'Sales_Amount' from Employee as Emp
	Join Product as Prd
	On Emp.Employee_id = Prd.Product_Manager_id
	Join Sales as sl
	On Emp.Employee_id = sl.Employee_id where Emp.Employee_id = @Emp_id
GO
-------------
Select * from dbo.getEmpDetails(1)
Go
-------------

---Answer-14 Write SQL Statement to create trigger on Product Table for Delete and restrict the deletion of data temporary.

Create trigger trDeleterProduct on dbo.Product for Delete
as
begin
	Rollback Tran
end
Go

-------------------
Delete from Product where Product_id = 1
-------------------
Select * from Product
Go
-------------------

---Answer-15 Write SQL Statement to create trigger on Product Table for insert, and validate product_rate column values, with below logic.
/*
a.	If product_rate greater than 5000, make the copy of insert data into temp_product table, having similar column structure.
b.	If product_rate is not greater than 5000 than there will be no insertion needed in temp_product table
*/

Create Table temp_Product
(
Product_id int,
Product_name varchar(12),
Product_rate money,
Product_location varchar(12),
Product_Manager_id int
)

Select * from Product
Select * from temp_Product
Go
-----------------------

alter trigger trInsertProduct on dbo.Product for Insert
as
begin
	declare @Prd_rate int
	Select @Prd_rate = Product_rate from inserted
	if @Prd_rate > 5000
		Insert into temp_Product
		Select * from inserted

end
GO

Insert into Product(Product_name,Product_rate,Product_location) Values('burger',4500,'Delhi')

Insert into Product(Product_name,Product_rate,Product_location) Values('suitcase',5200,'Mumbai')

Select * from Product
Select * from temp_Product