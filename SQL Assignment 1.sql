--Database
use AdventureWorks2022 

select *
from HumanResources.Employee;

select * 
from HumanResources.Employee 
where MaritalStatus='M';

---find all the employee under job title marketing 
select * 
from HumanResources.Employee 
where JobTitle='Marketing Specialist';
--or
select * 
from HumanResources.Employee 
where JobTitle LIKE 'M%';
--or
select * 
from HumanResources.Employee 
where JobTitle LIKE 'Marketing%';
--or
select * 
from HumanResources.Employee 
where JobTitle LIKE 'Marketing Specialis_';

/*
select * 
from HumanResources.Employee;

select * 
from HumanResources.Employee 
where OrganizationNode = '0x5AE168'

SELECT *
FROM HumanResources.Employee 
WHERE OrganizationNode between 0x58 and 0x5AE168;

SELECT *
FROM HumanResources.Employee 
WHERE OrganizationNode LIKE 0x%;

SELECT * 
FROM HumanResources.Employee 
where OrganizationNode LIKE '%0x5AE16%';

SELECT * 
FROM HumanResources.Employee 
WHERE OrganizationNode = hierarchyid::Parse('/5AE16/');*/


--Aggregate function

select count(*) from HumanResources.Employee

select count(*) from HumanResources.Employee where Gender='M'

select count(JobTitle) from HumanResources.Employee

select * 
from HumanResources.Employee

--find the employee having salaried flag as 1
select * 
from HumanResources.Employee 
where SalariedFlag=1


--find all employee having vaccation hr more than 70
select * 
from HumanResources.Employee 
where VacationHours>70

--vacation hr more than 70 but less than 90

select * 
from HumanResources.Employee 
where VacationHours between 70 and 90

--or
select * 
from HumanResources.Employee 
where VacationHours>70 and VacationHours<90

--Find all jobs having as Designer
--(first find unique Job title)
select distinct(JobTitle) 
from HumanResources.Employee

select * 
from HumanResources.Employee 
where JobTitle='Design Engineer'
--or
select * 
from HumanResources.Employee 
where JobTitle LIKE '%Design%'
--or

SELECT * 
FROM HumanResources.Employee 
WHERE PATINDEX('%Design%', JobTitle) = 1;
--PATINDEX() returns the starting position of the pattern.
--If it returns 1, it means "Design" is at the start.



--find the total employees worked as technician
select * 
from HumanResources.Employee 
where JobTitle LIKE '%technician%'

--display data having NationalIDNumber, Job Title, marital Status, gender for all under marketing job title

select JobTitle, MaritalStatus, Gender 
from HumanResources.Employee 
where JobTitle like 'Marketing%'

--find all unique marital status
select distinct(MaritalStatus) 
from HumanResources.Employee

--find the max vacation hrs
select max(VacationHours) 
from HumanResources.Employee

---find the less sick leaves
select min(SickLeaveHours) 
from HumanResources.Employee

--find both vacation_hr and sickkeaves simulteneously 
select max(VacationHours),
min(SickLeaveHours) 
from HumanResources.Employee

--renaming
select max(VacationHours) as MAximumVactionHRS,
min(SickLeaveHours) as MinimumSickLeavesHrs 
from HumanResources.Employee

--another table--

--find all the employees from prodution department
select*
from HumanResources.Department 
where name='Production'

select * 
from HumanResources.Employee 
where BusinessEntityID in 
(select BusinessEntityID 
from HumanResources.EmployeeDepartmentHistory 
where DepartmentID=7);

--find all department under research and dev
select * 
from HumanResources.Department

select *
from HumanResources.Department 
where GroupName='Research and Development'

select * 
from HumanResources.Employee 

select *
from HumanResources.EmployeeDepartmentHistory 

--find all employee under research and dev
select * 
from HumanResources.Employee 
where BusinessEntityID in
(select BusinessEntityID 
from HumanResources.EmployeeDepartmentHistory 
where DepartmentID in 
(select DepartmentID 
from HumanResources.Department 
where GroupName='Research and Development'));



---find all employees who work in  day shift
select *
from HumanResources.Shift 
where ShiftID=1
select * 
from HumanResources.EmployeeDepartmentHistory


select * 
from HumanResources.Employee
where BusinessEntityID in
(select BusinessEntityID 
from HumanResources.EmployeeDepartmentHistory
where ShiftID in
(select ShiftID 
from HumanResources.Shift 
where Name='Day'));




--find all the emp where pay freq is 1
select*
from HumanResources.EmployeePayHistory

select*
from HumanResources.EmployeePayHistory
where PayFrequency=1

--find all candidate who are not placed
/*select* 
from HumanResources.JobCandidate
select*
from HumanResources.Employee 
where BusinessEntityID in
(select BusinessEntityID 
from HumanResources.JobCandidate 
where BusinessEntityID is NULL);
select BusinessEntityID  
from Person.BusinessEntityAddress 
where ModifiedDate*/


--find the address of employee
select * 
from Person.Address 
where AddressID in
(select AddressID 
from Person.BusinessEntityAddress 
where BusinessEntityID in
(select BusinessEntityID 
from HumanResources.Employee));


--Find the name of the employee working in group research and Development
select FirstName, MiddleName,LastName 
from Person.Person 
where BusinessEntityID in 
(select BusinessEntityID 
from HumanResources.EmployeeDepartmentHistory
where DepartmentID in
(select DepartmentID
from HumanResources.Department
where GroupName='Research and Development'));

--
select * 
from Person.Person 
where BusinessEntityID in 
(select BusinessEntityID 
from HumanResources.EmployeeDepartmentHistory
where DepartmentID in
(select DepartmentID 
from HumanResources.Department 
where GroupName='Research and Development'));

--
select * 
from HumanResources.Employee 
where BusinessEntityID in 
(select BusinessEntityID 
from HumanResources.EmployeeDepartmentHistory 
where DepartmentID in
(select DepartmentID 
from HumanResources.Department 
where GroupName='Research and Development'));