---SQL-Project : Student Management System

---Answer 1. Create a table name student and attribute of s_id, first last and middle name, address, email, city, and state.

Create Table Student
(
S_id varchar(5) Primary Key,
Sf_name varchar(15) Unique,
Sm_name varchar(15),
Sl_name varchar(15),
S_phone varchar(13) Unique,
S_email varchar(25) Unique,
S_State varchar(25),
S_Address varchar(100),
S_City varchar(15) default 'Kolkata'
)

Select * from Student

---Answer 2. Display the datatype of all attributes in the student table?
sp_help student


---Answer 3. Insert values into the table student?
Insert Into Student(S_id,Sf_name,Sm_name,Sl_name,S_Phone,S_email,S_state,S_address,S_city)
Values('001','Chandan','Kumar','Gupta','9649794168','chandan@gmail.com','Delhi','Laxmi Nagar','Delhi'),
	('002','Aashish','Kumar','Gupta','8015798456','aashish@outlook.com','Haryana','Vijay Chowk','Panipat'),
	('003','Gaurav','Kumar','Gupta','9718561506','gaurav@facebook.com','West Bengal','Howrah Bridge','Kolkata'),
	('004','Naman','Kumar','Sharma','9871875614','naman@hotmail.com','Rajasthan','Church Gate','Jaipur'),
	('005','Tarun','G','Raj','8874561425','tarun@warrior.com','West Bengal','Imperial Church','Kolkata')



---Answer 4. Change the datatype of s_id in the student table?
--Already done int to varchar

---Answer 5. Update the city of s_id=001 to bby?
update Student set S_City = 'bby'
where S_id = 001

Select * from Student

-----------------------------------------------------------
Create Table Users
(
reg_id int Identity(20,1) Primary Key,
reg_pass varchar(15),
reg_nickname varchar(12) Unique,
reg_marks float,
reg_percentage as (reg_marks/120)*100,
reg_result varchar(5),
users_name varchar(15) foreign key references Student(Sf_name)
)

Insert into Users(reg_pass,reg_nickname,reg_marks,reg_result,users_name)
Values('Cg@123','chandan_g',87.5,'pass','Chandan'),
	('Ash@123','Aashu',72.4,'pass','Aashish'),
	('Gau@rav','Gau_sa',65.4,'fail','Gaurav'),
	('Nm@12345','Nunnu',78.9,'pass','Naman'),
	('TG@456','Bihari',68.4,'fail','Tarun')

Select * from Users
----------------------------------------------------------------

----------------------------------------------------------------
Create Table Course
(
C_id int Identity(11,1) Primary Key,
C_fee float,
C_name varchar(15),
C_duration varchar(12),
S_id varchar(5) foreign key references Student(S_id)
)

Insert Into Course(C_fee,C_name,C_duration,S_id)
Values(120000,'Computer Netw.','120_hr','001'),
	(160000,'DBMS','360_hr','002'),
	(36000,'Eng. Maths','45_hr','003'),
	(55000,'Human Values','90_hr','004'),
	(95000,'Computer Arch.','130_hr','005')

Select * from Course
--------------------------------------------------------

--------------------------------------------------------
Create Table Teacher
(
T_id int Identity(51,1) Primary Key,
Tf_name varchar(15),
Tm_name varchar(15),
Tl_name varchar(15),
T_qualification varchar(15),
T_course varchar(25),
T_phone varchar(13) unique,
S_Card_Num varchar(5) foreign key references Student(S_id)
)

Insert Into Teacher(Tf_name,Tm_name,Tl_name,T_qualification,T_course,T_phone,S_Card_Num)
Values('Suresh','J.','Kala','PHD.','Computer Networks',9218506562,'001'),
	('Dhruv','Kumar','Saxena','B.Tech','DBMS',9414941739,'002'),
	('Kundan','G.','Kumar','M.Sc.','Eng. Maths',8281914165,'003'),
	('Rekha','K.','Mehra','PHD.','Human Values',7035729822,'004'),
	('Deepak','Kumar','Gupta','M.Tech','Computer Architechture',8482983164,'005')

Select * from Teacher
------------------------------------------------------------

---RETRIEVING DATA USING SELECT

---Answer 1. Display all the columns of the table name course?
Select * from Course


---Answer 2. Display the columns c_name aliases course name of table name course?
Select C_name as [Course Name] from Course


---Answer 3. Display the columns c_fee and c_name using concatenation and aliases
---course details of table name course?
Select Concat(C_fee,' ',C_name) as [Course Details] from Course


---Answer 4. Display the course fee and increase in course fee by 3000 where the
---course duration is 45_hr?
Select C_fee + 3000.0 as [New Course Fee] from Course
where C_duration = '45_hr'


---Answer 5. Remove the duplicate value from course duration with a student ID from
---the table name course?
Select Distinct C_duration,S_id,* from Course


---RESTRICTIONS AND SORTING

---Answer 1. Display the student ID and the first name from the table name student whose state is westbengal?
Select S_id,Sf_name from Student
where S_State = 'West Bengal'


---Answer 2. Display all the data of the table course whose course ID is ‘11’.
Select * from Course
Where C_id = 11


---Answer 3. Display all the data of the table course whose course fee range is less than 100000?
Select * from Course
Where C_fee < 100000


---Answer 4. Display the Lastname and city of the table student where the student’s first name starts with ‘a’ and consists of 4 characters?
Select Sl_name,S_City from Student
where Sf_name like 'A____%'


---Answer 5. Display the course fee of the table name course which is between 10000 to 50000?
Select C_fee from Course
where C_fee between 10000 and 50000



---AGGREGATE AND GROUPING

---Answer 1. Display the average course fee for all the courses in the given table?
Select Avg(C_fee) as [Avg. Course Fee] from Course


---Answer 2. Display the minimum and maximum course fees in the given table?
Select Min(C_fee) as 'Min. Course Fee',Max(C_fee) as 'Max Course Fee' from Course


---Answer 3. Display the count number of course names from the table name course?
Select Count(Distinct C_name) as [No. of Courses] From Course


---Answer 4. Display the total course fee in the table name course?
Select Sum(C_fee) as [Totals of Course Fee] from Course


---Answer 5. Display the student ID and minimum course fee from the course table and group by student ID having a course fee less than 102000 and sort the minimum course fee in descending order?
Select S_id,min(C_fee) as [Min Course Fee] from Course
Group By S_id
Having sum(C_fee) < 102000 
Order By [Min Course Fee] Desc


---SINGLE ROW FUNCTION

---Answer 1. Display the student ID and student first name and state from the student table where convert student first name and state into uppercase?
Select S_id,Upper(Sf_name) as 'First Name', UPPER(S_state) as 'State' from Student


---Answer 2. Display the student ID and student first name and state from the student table where convert student first name and state into lowercase?
Select S_id, lower(Sf_name) as 'First Name', lower(S_state) as 'State' from Student


---Answer 3. Display the student ID and student state from table student and change the first character of all states to uppercase?
Select S_id, Concat(Upper(LEFT(S_State,1)),LOWER(substring(S_state,2,len(S_state)-1))) as 'State Name' from Student


---Answer 4. Display the student ID and student first name middle name last name together from the table student use the character-manipulation function?
Select S_id,CONCAT(Sf_name,' ',Sm_name,' ',Sl_name) as [Full Name] from Student


---Answer 5. Display the student ID and the length of the first name and the last name from the table student using the character-manipulation function.
Select S_id,len(Sf_name) as 'Length First Name',LEN(Sl_name) as 'Length Last Name' from Student



---JOINS

---Answer 1. Display the registration number for the user’s table and the student’s first name on the table student use inner join?
Select U.reg_id as [Registration Number],S.Sf_name as [User's Name] from Users U
Join Student S
On U.users_name = S.Sf_name


---Answer 2. Display the registration number for the user’s table and the student’s first name on the table student use left join and order by the first name.
Select U.reg_id as [Registration Number],S.Sf_name as [User's Name] from Users U
Left Join Student S
On U.users_name = S.Sf_name
Order By S.Sf_name


---Answer 3. Display the registration number for the user’s table and the student’s first name and last name from the table student use the right join and order by registration number.
Select U.reg_id as [Registration Number],S.Sf_name as [User's First Name],S.Sl_name as [User's Last Name] from Users U
Right Join Student S
On U.users_name = S.Sf_name
Order By U.reg_id


---Answer 4. Select all teachers and all courses in the given table using full join and order by teacher ID.
Select T.T_id,T.Tf_name as [Teacher Name],C.C_name as [Course Name] from Teacher T
Full Outer Join Course C
ON C.S_id = T.S_Card_Num
Order By T.T_id


---Answer 5. Select all students’ first names and last names and city in the given table using self-join and order by the city?
Select S1.Sf_name as [First Name],S1.Sl_name as [Last Name],S2.S_City from Student S1
Join Student S2
On S1.S_id = S2.S_id
Order By S2.S_City


---SUBQUERRY

---Answer 1. Display the first middle and last name of the student where the course fee is minimum?
Select Sf_name as [First Name],Sm_name As [Middle Name],Sl_name as [Last Name] from Student
where S_id =  (Select S_id from Course where C_fee = (Select Min(C_fee) from Course))


---Answer 2. Display the teacher ID and first middle and last name of the teacher where the course name is DBMS?
Select T_id,Tf_name as [First Name],Tm_name As [Middle Name],Tl_name as [Last Name] from Teacher
where S_Card_Num =  (Select S_id from Course where C_name = 'DBMS')


---Answer 3. Display the phone number of the student of who’s registration number is 20?
Select Sf_name as 'Name',S_phone as [Contact Number] from Student
where Sf_name = (Select users_name from Users where reg_id = 20)


---Answer 4. Display the registration number who live in Jaipur?
Select reg_id as [Registration Number] from Users
where users_name = (select Sf_name from Student where S_City = 'Jaipur')


---Answer 5. Display teacher ID first name and phone number whose qualification is b.tech?
Select T_id,Tf_name as [Name], T_phone as [Phone Number] from Teacher
where T_qualification = 'B.Tech'
