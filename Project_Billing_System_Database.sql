---Answer 1. Create Databse BBS

Create Database BBS
Go

---Answer 2. Create Objects specified in Data Model &amp; Add data to “Subscription” table.

-------------------------------------------
Create Table User_login
(
User_id int Identity(121,1) Primary Key,
Password Varchar(50) Unique
)

Insert into User_login
Values('AK@123'),('DP@478'),('GK@12345'),('GS@981')

Select * from User_login

-----------------------------------------------------------------
Create Table Subscription
(
Subscription_id int Identity(1061,1) Primary Key,
Subscription_Cost float,
Subscription_Details varchar(100),
Subscription_Area varchar(50),
Subscription_Speed varchar(100)
)

Insert Into Subscription(Subscription_Cost,Subscription_Details,Subscription_Area,Subscription_Speed)
values(1800,'All Entertainment','Sarojni Nagar','1_gbps'),
	(2100,'Movie Masala','Shakarpur','500_mbps'),
	(1950,'Market Mavens','Lajpat Nagar','2_gbps'),
	(2700,'All In One','South Extension','2_gbps')

Select * from Subscription

-------------------------------------------------------------
Create Table Customer_Details
(
Customer_id int Identity(191,1) Primary Key,
Customer_Mobile_Num varchar(50) Unique,
Customer_Name varchar(100),
Customer_Address varchar(100),
Customer_Type varchar(100),
Customer_Id_Proof varchar(50),
User_id int foreign key references User_login(User_id),
Subscription_id int foreign key references Subscription(Subscription_id)
)

Insert into Customer_Details(Customer_Mobile_Num,Customer_Name,Customer_Address,Customer_Type,Customer_Id_Proof,User_id,Subscription_id)
Values(9649795145,'Aakash Gupta','Sarojni Nagar','Regular','Ak_191',121,1061),
	(9881364718,'Deepak Singh','Shakarpur','Regular','DS_192',122,1062),
	(9414741827,'Gaurav Kumar','Lajpat Nagar','New','Gk_193',123,1063),
	(8058098695,'Gajendra Singh','South Extension','Regular','GS_194',124,1064)

Select * from Customer_Details

-------------------------------------------------------------------------
Create Table Bills
(
Bill_no int Identity(2021,1) Primary Key,
Month Varchar(50),
Cost float,
Status varchar(50),
Customer_id int foreign key references Customer_Details(Customer_id),
Subscription_id int foreign key references Subscription(Subscription_id)
)

Insert into Bills(Month,Cost,Status,Customer_id,Subscription_id)
Values('January',1800,'Paid',191,1061),
	('February',2100,'Pending',192,1062),
	('March',1950,'Paid',193,1063),
	('March',2700,'Pending',194,1064)

Select * from Bills

-----------------------------------------------------------------------
Create Table Transaction_Details
(
Transaction_id int Identity(1267501,1) Primary Key,
Date_of_Issue date,
Paid_Amount float,
Pay_Method varchar(50),
Bill_no int foreign key references Bills(Bill_no)
)


Insert into Transaction_Details(Date_of_Issue,Paid_Amount,Pay_Method,Bill_no)
values('15-jan-2023',1800,'UPI',2021),
	('15-feb-2023',2100,'Cash',2022),
	--it is inserted by stored procedure.....
	('15-Mar-2023',2700,'Cash',2024)

Select * from Transaction_Details
Go
-----------------------------------------------------------

---Answer 3. Create a procedure that gets customer’s name, customer mobile number,id proof, type, city, area, and password as inputs and registers the customer for choosing any suitable plan of broadband as per his locality.

Create or Alter Proc sp_broadbandPlan(@name varchar(50),@mob_num varchar(20), @id_proof varchar(20), @cust_type varchar(20), @city varchar(20), @area varchar(25), @password varchar(20))
As
Begin
	
	Select c.Customer_id,c.Customer_Name,c.Customer_Address,CONCAT(s.Subscription_Details,' @ ',s.Subscription_Speed,' at Rs ',s.Subscription_Cost) as [Subscription Plan] from Customer_Details C
	Join Subscription S
	On C.Subscription_id = S.Subscription_id
	where C.Customer_Name = @name

End


Exec sp_broadbandPlan 'Aakash Gupta',9649795145,'Ak_191','Regular','Delhi','Sarojni Nagar','AK@123'
GO

-----------------------------------------------------------------------

---Answer 4. Same as Previous

------------------------------------------------------------------------

---Answer 5. Create a procedure that gives the customer all the plans available and the customer can choose anyone plans out of them as per his need and locality by taking subscription id, customer id, and month as input.

Create proc sp_chooseSubscriptonPlans(@subs_id int, @cust_id int, @month varchar(20))
As
Begin
	Select S.Subscription_id,C.Customer_Name,C.Customer_Address,CONCAT(s.Subscription_Details,' @ ',s.Subscription_Speed,' at Rs ',s.Subscription_Cost) as [Subscription Plan],S.Subscription_Area,B.Month,B.Cost from Subscription S
	Join Customer_Details C
	on C.Subscription_id = S.Subscription_id
	Join Bills B
	On S.Subscription_id = B.Subscription_id
	where S.Subscription_id = @subs_id
End


Exec sp_chooseSubscriptonPlans 1062,192,'February'
Go
-------------------------------------------------------------------------

---Answer 6. Create a procedure that will generate the bill for the customer’s chosen subscription plan by taking subscription id, month, and customer id as inputs.

Create proc sp_Generate_bill(@subs_id int, @month varchar(20),@cust_id int)
As
Begin

	Select B.Bill_no,TD.Date_of_Issue,C.Customer_Name,C.Customer_Address,C.Customer_Type,B.Month,CONCAT(s.Subscription_Details,' @ ',s.Subscription_Speed,' at Rs ',s.Subscription_Cost) as [Subscription Plan],B.Cost as 'Bill Amount',B.Status,TD.Pay_Method from Customer_Details C
	Join Bills B
	On C.Customer_id = B.Customer_id
	Join Subscription S
	On B.Subscription_id = S.Subscription_id
	Join Transaction_Details TD
	On B.Bill_no = TD.Bill_no
	where C.Customer_id = @cust_id

End

Exec sp_Generate_bill  1061,'January',191
Go

------------------------------------------------------------------

---Answer 7. Create a procedure to make a transaction for payment for the chosen transaction and will show the transaction details of the customer’s payment status.

Create or Alter proc sp_TransactionDetails(@date date,@amount float,@pay_method varchar(20),@bill int)
As
Begin
	Insert Into Transaction_Details(Date_of_Issue,Paid_Amount,Pay_Method,Bill_no) 
		Values(@date,@amount,@pay_method,@bill)

	Select TD.Transaction_id,TD.Date_of_Issue,B.Month,TD.Paid_Amount,TD.Pay_Method,B.Bill_no,B.Status from Transaction_Details TD
	Join Bills B
	On B.Bill_no = TD.Bill_no
	where TD.Bill_no = @bill
End

Exec sp_TransactionDetails '15-Mar-2023',1950,'Cards',2023
Go

---------------------------------------------------------------

---Answer 8. Create a trigger that gets triggered when there is any update on the bill table after the successful transaction of payment and this trigger has to change the status of bill payment from pending to paid.

Create Trigger tr_UpdateBillStatus on Bills for Update
As
Begin 
	
	declare @bill_num int
	Select @bill_num = Bill_no from deleted
	Update Bills set Status = 'Paid'
	where Bill_no = @bill_num	

End

Select * from Bills

Update Bills set Cost = 2500
where Bill_no = 2024
Go

-------------------------------------------------------------
