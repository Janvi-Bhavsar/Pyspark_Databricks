use AdventureWorks2022
/*select p.* from Person.Person p*/

select 
       BusinessEntityID, 
       NationalIDNumber,
       JobTitle,
(select FirstName from Person.Person p
where p.BusinessEntityID= e.BusinessEntityID) FirstNAme
from HumanResources.Employee e;

--##Co-realated subquries##
--add personal details of employee like middle name , first name and last name

 select 
       BusinessEntityID, 
       NationalIDNumber,
       JobTitle,
(select 
FirstName from Person.Person p
where p.BusinessEntityID= e.BusinessEntityID) 
FirstNAme,
(select 
MiddleName from Person.Person p
where p.BusinessEntityID= e.BusinessEntityID) 
MiddleName,
(select LastName
from Person.Person p
where p.BusinessEntityID= e.BusinessEntityID) 
LastName

from HumanResources.Employee e;

--As Per the Question
 select 
(select 
FirstName from Person.Person p
where p.BusinessEntityID= e.BusinessEntityID) 
FirstNAme,
(select 
MiddleName from Person.Person p
where p.BusinessEntityID= e.BusinessEntityID) 
MiddleName,
(select LastName
from Person.Person p
where p.BusinessEntityID= e.BusinessEntityID) 
LastName

from HumanResources.Employee e;

--#OR
--using concat
 select 
       BusinessEntityID, 
       NationalIDNumber,
       JobTitle,
       (select CONCAT_ws(' ',FirstName,MiddleName,LastName) from Person.Person p
        where p.BusinessEntityID= e.BusinessEntityID) Full_NAme 
from HumanResources.Employee e;

--#OR

 select 
       BusinessEntityID, 
       NationalIDNumber,
       JobTitle,
       (select CONCAT(' ',FirstName,' ',MiddleName,' ',LastName) from Person.Person p
        where p.BusinessEntityID= e.BusinessEntityID) Full_NAme 
from HumanResources.Employee e;

--Display national_id,first name,last_name and depart name, department_group
--Required Tables
select* from HumanResources.Employee
select* from HumanResources.Department
select* from HumanResources.EmployeeDepartmentHistory

--Display national_id Depart_name,departname_group
--Query
select (Select CONCAT_WS(' ',FirstNAme, LastNAme)
       from person.person p
	   where p.BusinessEntityID=ed.BusinessEntityID) Emp_Name,
	   (Select NationalIDNumber 
	   from HumanResources.Employee e
	   where e.BusinessEntityID=ed.BusinessEntityID)NationalIDNumber ,
	   (Select Concat(Name,' -', GroupName)
	   from HumanResources.Department d
	   where d.DepartmentID=ed.DepartmentID)DepartGroupName
from HumanResources.EmployeeDepartmentHistory ed;


--Display first_name, last _name , department, shift time
--Reuired Tables
select* from HumanResources.Department
select* from HumanResources.EmployeeDepartmentHistory
select* from HumanResources.Shift
select*from Person.Person

--#Query
select (Select CONCAT_WS(' ',FirstNAme, LastNAme)
       from person.person p
	   where p.BusinessEntityID=ed.BusinessEntityID) Person_details,
	   (Select  CONCAT(StartTime,' ', EndTime)---we can also use from start date to end date
	   from HumanResources.Shift s
	   where s.ShiftID=ed.ShiftID) Shift_Details,
	   (Select Name from HumanResources.Department d
	   where d.DepartmentID=ed.DepartmentID) Dept_details
from HumanResources.EmployeeDepartmentHistory ed;


--Display product name and product review based on production schema
--#Required Tables
select * from Production.Product
select * from Production.ProductReview

--#Query using Joins
select p.Name,
	   r.Comments,
	   r.ReviewerName from production.Product p join
	   production.ProductReview r on
	   r.ProductID=p.ProductID 
       
--Find the employees name, job title, card details whose credit card expired in month 11 year 2008
--Required Tables
select* from Person.Person
select* from HumanResources.Employee
select* from Sales.CreditCard
select* from Sales.PersonCreditCard

--#Query
select CreditcardID,
(select concat_ws(' ',FirstName, LastName) 
from Person.Person pp
where pp.BusinessEntityID=spc.BusinessEntityID)EMP_Name,
(select JobTitle from HumanResources.Employee he
where he.BusinessEntityID=spc.BusinessEntityID)JOb_Title,
(select CONCAT_WS('',CardType,'-',cardNumber)
from Sales.CreditCard sc
where sc.CreditCardID=spc.CreditCardID) Card_Details
from Sales.PersonCreditCard spc 
where CreditCardID in 
(select CreditCardID from Sales.CreditCard where ExpMonth=11 and ExpYear=2008);


--Display EMP NAMe, territory name, group, SalesLastYear SalesQuota, bonus
--Required Tables
select * from Sales.SalesPerson
select * from Sales.SalesTerritory
select* from Person.Person

--Query
select SalesQuota,
       Bonus,
       SalesLastYear,
     (select CONCAT_WS(' ',firstname,lastname) 
     from person.Person pp
     where pp.BusinessEntityID=ss.BusinessEntityID) Emp_Name,
     (select CONCAT_WS(Name,' ' ,[Group] ,'',SalesLastYear)
     from Sales.SalesTerritory st
     where st.TerritoryID=ss.TerritoryID) TerritoryDetails

from Sales.SalesPerson ss


/*Display EMP NAMe, territory name, group, SalesLastYear SalesQuota, bonus
from  germany and united kindom*/
--Query
select SalesQuota,
       Bonus,
       SalesLastYear,
      (select CONCAT_WS(' ',firstname,lastname) 
      from person.Person pp
      where pp.BusinessEntityID=ss.BusinessEntityID) Full_Name,
      (select CONCAT_WS(Name,' ' ,[Group] ,'',SalesLastYear)
      from Sales.SalesTerritory st
      where st.TerritoryID=ss.TerritoryID) TerritoryDetails
from Sales.SalesPerson ss
where ss.TerritoryID in
(select st.TerritoryID 
from Sales.SalesTerritory st
where [Name] IN ('Germany', 'United Kingdom'));


--Find all employess who worked in all north america territory
--Required tables
select * from Sales.SalesPerson
select * from Sales.SalesTerritory
select* from Person.Person

select
(select CONCAT_WS(' ',firstname,lastname) 
     from person.Person pp
     where pp.BusinessEntityID=ss.BusinessEntityID) Emp_Name_Working_inNA
     from Sales.SalesPerson ss
     where ss.TerritoryID in
     (select TerritoryID
     from Sales.SalesTerritory st
where [Group]='North America')


--Find the product details in cart
select* from Sales.ShoppingCartItem
select* from Production.Product

select * 
from Production.Product 
where ProductID in
( select ProductID 
from Sales.ShoppingCartItem)


--Find the product with special offer
--Required columns
select*from Sales.SpecialOffer
select*from Production.Product
select*from Sales.SpecialOfferProduct
/*select*from Purchasing.ShipMethod
select*from Purchasing.ProductVendor
select*from Purchasing.PurchaseOrderDetail*/

--#Query
select 
(select Name 
from Production.Product pp
where pp.ProductID=sop.ProductID) Product_With_spe_Offer

from Sales.SpecialOfferProduct sop
where sop.SpecialOfferID in(
select so.SpecialOfferID
from Sales.Specialoffer so
where [Description]!='No Discount' or DiscountPct=0.00)

--Display product , sell  start date ,sell end date,minOrderQty,maxorderQty
select*from Production.Product
select*from Production.TransactionHistoryArchive
select*from Production.WorkOrder
/*select MAX(Quantity) as maxorderQty,
MIN(Quantity) as minOrderQty
from Production.TransactionHistoryArchive*/


select Name as ProductName,
       sellstartdate,
	   sellenddate,
(select MAX(OrderQTY) as maxorderQty
from Production.WorkOrder pw
where pw.ProductID=pp.ProductID)MaxOrderQty,
(select Min(OrderQTY) as minorderQty
from Production.WorkOrder pw
where pw.ProductID=pp.ProductID)MinOrderQty
from Production.product pp
