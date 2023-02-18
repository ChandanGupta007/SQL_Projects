---SQL Query Based Project(DDL,DML,DCL,DQL,TSQL)

---Answer - 1 Create a database and make below structure into this database.
Create Database Chandan
Use Chandan

---Answer - 2 Create Table with name of “timetable”
/*
Define the table design as follow:
Column Name	Data type
CDate	Datetime
Starting time	Datetime
Ending time	Datetime
Course name	Varchar(20)
Lesson topic	Varchar(100)
Room No	Int
*/

Create Table Timetable
(
CDate Datetime,
Starting_time Datetime,
Ending_time Datetime,
Course_name varchar(20),
Lesson_topic varchar(100),
Room_no int
)

---Answer - 3 Modify above table and do following activities:

---3(a) Add new columns with the name of Teachers’ Name with varchar(20).
alter table Timetable
add Teachers_name varchar(20)

---3(b) Change the datatype of Room No to varchar(5) from Int.
Alter Table Timetable
alter column Room_no varchar(5)

---3(c) Drop the column “Lesson topic” from table.
Alter Table Timetable
drop column Lesson_topic

Insert into Timetable(CDate,Starting_time,Ending_time,Course_name,Room_no,Teachers_name) 
Values('20-Dec-2022 00:00:00','20-Dec-2022 08:00:00','20-Dec-2022 14:00:00','MS-Excel','A1','Manoj Kumar'),
	('21-Dec-2022 00:00:00','21-Dec-2022 08:00:00','21-Dec-2022 14:00:00','Tableau','A1','Manoj Kumar'),
	('22-Dec-2022 00:00:00','22-Dec-2022 08:00:00','22-Dec-2022 14:00:00','Power-BI','B1','Manoj Kumar'),
	('23-Dec-2022 00:00:00','23-Dec-2022 08:00:00','23-Dec-2022 14:00:00','MS-SQL Server','H1','Rajinder Chittoria'),
	('24-Dec-2022 00:00:00','24-Dec-2022 08:00:00','24-Dec-2022 14:00:00','AWS Cloud Service','H1','Rajinder Kumar')

-----------
Select * from Timetable
------------

---Answer - 4 Create Table with name of “Product”
/*
Define the table design as follow:
Column Name	Data type	
Product_id	Int	Identity(1,1) + Primary Key
Product_Name	Varchar(12)	Unique Key
Product_Rate	Money	Check with Amount Always >0
Product_Location	Varchar(12)	Check  from List (‘Delhi’, ’Mumbai’)
Product_Manager_Id	Int	Foreign Key with Employee Table and Employee_Id
*/

Create Table Product
(
Product_id int Identity(1,1) Primary Key,
Product_name varchar(12) Unique,
Product_rate money check(Product_rate > 0),
Product_location varchar(12) check(Product_location in('Delhi','Mumbai')),
Product_Manager_id int foreign key references Employee(Employee_id)
)

Insert into Product(Product_name,Product_rate,Product_location,Product_Manager_id)
Values('Shoes',8500,'Delhi',21),('Jacket',9000,'Mumbai',22), ('Purse',4900,'Delhi',23), ('Handbag',2100,'Mumbai',24), 
	('Trouser',2300,'Mumbai',25), ('Sneakers',3600,'Delhi',26)

--------------
Select * from Product
--------------


---Answer - 5 Create Table with name of “Department”.
/*
Define the table design as follow:
Column Name	Data type	
Department_id	Int	Identity(111,1) + Primary Key
Department_Name	Varchar(12)	Unique Key
Head_Quarter	Varchar(12)	Default ‘Bangaluru’
*/

Create Table Department
(
Department_id int Identity(111,1) Primary Key,
Department_name varchar(12) Unique,
Head_quater varchar(12) Default 'Bengaluru'
)

Insert into Department(Department_name,Head_quater)
Values('HR','Bengaluru'),('IT','Bengaluru'),('Finance','Hydrabad'),('Accounting','Bengaluru'),('Sales','Bengaluru'),
	('Marketing','Bengaluru')

Insert into Department(Department_name) Values('Admin')

Update Department set Head_quater = 'Bengaluru'
where Department_id = 113

Delete from Department where Department_id = 117

-----------
Select * from Department
------------

---Answer - 6 Create Table with name of “Employee”
/*
Define the table design as follow:
Column Name	Data type	
Employee_Id	Int	Identity(21,1) + Primary Key
Employee_Name	Varchar(12)	Unique Key
Employee_Age	Int	Check with Age Always >18
Employee_Salary	Money	
Department_Id	Int	Foreign Key with Department Table and Department Id 
*/

Create Table Employee
(
Employee_id int Identity(21,1) Primary Key,
EMployee_name varchar(12) Unique,
Employee_age int Check(Employee_age>18),
Employee_Salary money,
Department_id int foreign key references Department(Department_id)
)

Insert into Employee(EMployee_name,Employee_age,Employee_Salary,Department_id)
Values('Chandan',23,32000,111),('Gaurav',24,35000,112),('Aashish',21,12000,113),('Naman',24,12000,114),('Harish',25,16000,115),('Tarun',23,28000,116)

-----------
Select * from Employee
-----------

---Answer - 7 Create Table with name of “Sales”
/*
Define the table design as follow:
Column Name	Data type	
Sales_id	Int	Identity(71,1) + Primary Key
Product_Id	Int	Foreign Key with Product Table
Employee_Id	Int	Foreign Key with Employee Table
Unit_Sold	Int	
Product_Manager_Id	Int	Foreign Key with Employee Table
Order Date	Date	Default current date
*/

Create Table Sales
(
Sales_id int identity(71,1) Primary Key,
Product_id int foreign key references Product(Product_id),
Employee_id int foreign key references Employee(Employee_id),
Unit_Sold int,
Product_Manager_id int foreign key references Employee(Employee_id),
Order_Date Date default getdate()
)

Insert into Sales(Product_id,Employee_id,Unit_Sold,Product_Manager_id,Order_Date)
Values(1,21,4,21,'20-Dec-2022'), (2,22,5,22,'21-Dec-2022'), (3,23,6,23,'22-Dec-2022'), (4,24,3,24,'23-Dec-2022'),
	(5,25,12,25,'24-Dec-2022'), (6,26,26,26,'25-Dec-2022')

------------
Select * from Sales
------------

Select * from Timetable
Select * from Product
Select * from Department
Select * from Employee
Select * from Sales
Go


---Answer - 8 Write SQL Statement to create a view with the name vwSalesReport with below fields
/*
a.	Product_Name
b.	Employee_Name
c.	Unit_Sold
d.	Product_Rate
e.	Sales_Amount (Unit *Rate)
*/

alter View vwSalesReport
as
Select Pd.Product_name,Emp.EMployee_name,sl.Unit_Sold,Pd.Product_rate,sl.Unit_Sold*Pd.Product_rate as 'Sales_Amount'  from Product as Pd
Join Employee as Emp
On Pd.Product_Manager_id = Emp.Employee_id
Join Sales as sl
On sl.Product_id = Pd.Product_id
Go
------------
Select * from vwSalesReport
GO 
------------

---Answer - 9 Write SQL Statement to create a stored procedure insert into Product table.

Create proc spInsertData(@Product_name varchar(12), @Product_rate money, @Product_location varchar(12), @Product_Manager_id int)
as
begin
	Insert into Product(Product_name,Product_rate,Product_location,Product_Manager_id) 
	Values(@Product_name,@Product_rate,@Product_location,@Product_Manager_id)
end
Go

-----------
exec spInsertData 'Laptop',82000,'Mumbai',27
exec spInsertData 'Mobile',27000,'Delhi',28 
----------


----------------------------------
Insert into Department(Department_name) Values('Admin'),('Corp')

Insert into Employee(EMployee_name,Employee_age,Employee_Salary,Department_id)
Values('Sunil',24,14000,118), ('Ram',25,16000,119)
GO
------------------------------


---Answer - 10 Write SQL Statement to create a stored procedure to accept Employee_Id as input and show below mentioned columns
/*
a.	Employee_Name
b.	Total_Unit_Sold
c.	Total_Sales_Amount (Unit *Rate)
*/

Create proc spInsertEmployeeid(@Emp_id int)
as
begin
	Select Emp.EMployee_name,sl.Unit_Sold as 'Total Units Sold',sl.Unit_Sold*Pd.Product_rate as 'Total_Sales_Amount' from Employee as Emp
	Join Sales as sl
	on Emp.Employee_id = sl.Employee_id
	Join Product as Pd
	On Emp.Employee_id = Pd.Product_Manager_id where Emp.Employee_id = @Emp_id
end

---------
exec spInsertEmployeeid 24

exec spInsertEmployeeid 21
GO
-----------

---Answer - 11 Write SQL Statement to create a function to accept product rate and return the type of product category with below logic
/*
a.	If Product Rate greater than 5000, show product category as Gold
b.	If Product Rate between 5000-3000, show product category as Silver, otherwise category Basic to be shown
*/

Create function getProduct_Cat(@Product_rate money)
returns varchar(12)
as
begin
	declare @Product_Cat varchar(12)
	set @Product_Cat = 'Basic'

	if @Product_rate > 5000
	set @Product_Cat = 'Gold'

	else if @Product_rate between 3000 and 5000
	set @Product_Cat = 'Silver'

	return @Product_Cat
end
go
------------------
Select dbo.getProduct_Cat(5000) as 'Product_Category'
Go
------------------


---Answer - 12 Write SQL Statement to create a function to accept two numbers and return the division of two numbers, we need to make a provision to handle error, if there is error of divide by zero, return 0 as output.

Create function Error_handling(@num1 int, @num2 int)
returns int
as
begin
	declare @result int
	set @result = @num1/@num2
	return @result
end
Go

---Error handling 
begin try
	Select dbo.Error_handling(10,2) as 'Result'
end try

begin catch
	Select 0 as 'Result'
end catch
Go
---------------------------


---Answer - 13 Write SQL Statement to create a table function to accept Employee Id and showing below columns as output.
/*
a.	Product_Name
b.	Employee_Name
c.	Unit_Sold
d.	Product_Rate
e.	Sales_Amount (Unit *Rate)
*/

Create function getEmployee_Details(@Emp_id int)
returns table 
as 
return Select Pd.Product_name, Emp.EMployee_name, sl.Unit_Sold, Pd.Product_rate, sl.Unit_Sold*Pd.Product_rate as 'Sales_Amount' from Product as Pd
		Join Employee as Emp
		On Pd.Product_Manager_id = Emp.Employee_id
		Join Sales as sl
		On Pd.Product_id = sl.Product_id where Emp.Employee_id = @Emp_id
Go

-----------------
Select * from dbo.getEmployee_Details(21)
Go
-----------------


---Answer - 14 Write SQL Statement to create trigger on Product Table for Delete and restrict the deletion of data temporary.

Create trigger trRestrict_Delete on Product for Delete
as
begin
	Rollback tran
end
Go

Delete from Product where Product_id = 9

Select * from Product
------------------------------


---Answer - 15 Write SQL Statement to create trigger on Product Table for insert, and validate product_rate column values, with below logic.
/*
a.	If product_rate greater than 5000, make the copy of insert data into temp_product table, having similar column structure.
b.	If product_rate is not greater than 5000 than there will be no insertion needed in temp_product table
*/

Create table Temp_Product
(
Product_id int,
Product_name varchar(12),
Product_rate money,
Product_location varchar(12),
Product_Manager_id int
)

Select * from Product
Select * from Temp_Product
Go

Create trigger trInsertData on Product for Insert
as
begin
	declare @Prd_rate money
	Select @Prd_rate = Product_rate from inserted
	if @Prd_rate > 5000
		Insert into Temp_Product
		Select * from inserted
end
Go

-----------------
Insert into Product(Product_name,Product_rate,Product_location,Product_Manager_id) 
Values('iphone',92000,'Mumbai',29)

Insert into Product(Product_name,Product_rate,Product_location,Product_Manager_id) 
Values('Earphones',1200,'Delhi',30)
----------------------

---------------------
Insert into Department(Department_name) Values('Manager'),('Cheifs')

Insert into Employee(EMployee_name,Employee_age,Employee_Salary,Department_id)
Values('Arnav',23,32000,122), ('Bhairav',23,35000,123)
-----------------------

Select * from Timetable
Select * from Product
Select * from Department
Select * from Employee
Select * from Sales
Select * from Temp_Product

---------------------------------------------------------