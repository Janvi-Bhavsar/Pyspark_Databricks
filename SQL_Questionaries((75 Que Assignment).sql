use [AdventureWorks2022]

---Q 1) find the average currency rate conversion from USD to Algerian Dinar and Australian Doller  

--Required Tables
select*from Sales.Currency        
select*from Sales.CurrencyRate    

--Query
select cr.FromCurrencyCode,
	   cr.ToCurrencyCode,
	   avg(cr.AverageRate)     
from Sales.Currency as c,
Sales.CurrencyRate as cr
where 
c.currencycode = cr.ToCurrencyCode
and c.name in ('Algerian Dinar','Australian Dollar')
group by cr.FromCurrencyCode,cr.ToCurrencyCode

--- Q 2) Find the products having offer on it and display product name , safety Stock Level, Listprice,  
--- and product model id, type of discount,  percentage of discount,  offer start date and offer end date

--Required Tables
select *from Production.Product               
select*from Sales.SpecialOffer               
select * from Sales.SpecialOfferProduct        

--Query
select 
      p.name,
	  p.ProductModelID,
	  p.ListPrice,
	  p.SafetyStockLevel,
	  so.type,
	  so.DiscountPct,
	  so.StartDate,
	  so.EndDate
from Production.Product as p,
Sales.SpecialOffer as so,
Sales.SpecialOfferProduct as sop
where sop.SpecialOfferID = so.SpecialOfferID
and p.ProductID = sop.ProductID

--Q 3) create  view to display Product name and Product review

--required Tables
select * from Production.Product               
select * from Production.ProductReview         

--query
SELECT
      p.name,
	  pr.Comments
from Production.Product as p,
Production.ProductReview as pr
where p.ProductID = pr.ProductID

--- Q 4) find out the vendor for product paint, Adjustable Race and blade

--requiredTables
SELECT * FROM Production.Product               
SELECT * FROM Purchasing.ProductVendor        
SELECT * FROM Purchasing.Vendor          

--Query
SELECT 
      p.name,
	  v.name as vendor_name
FROM 
Production.Product as p,
Purchasing.ProductVendor as pv,
Purchasing.Vendor as v
WHERE 
p.ProductID = pv.ProductID
and pv.BusinessEntityID = v.BusinessEntityID
and (p.name like ('%paint%')
or p.name = 'Adjustable Race'
or p.name = 'Blade')
GROUP BY p.name,v.name
order by name

--- Q 5) find product details shipped through ZY - EXPRESS 

--RequiredTables
select *from Purchasing.ShipMethod          
select * from Purchasing.PurchaseOrderHeader 
select * from Purchasing.PurchaseOrderDetail 
select * from Production.Product             

--query
select 
      distinct p.name,
	  sm.name as ship_through_name
from Purchasing.ShipMethod as sm,
Purchasing.PurchaseOrderHeader as poh,
Purchasing.PurchaseOrderDetail as pod,
Production.Product as p
where sm.ShipMethodID = poh.ShipMethodID
and poh.PurchaseOrderID = pod.PurchaseOrderID
and pod.ProductID = p.ProductID
and sm.name = 'ZY - EXPRESS'
 
--- Q 6) find the tax amt for products where order date and ship date are on the same day 

--requiredTables
select * from Production.Product                
select * from Purchasing.PurchaseOrderHeader    
select * from Sales.SalesOrderHeader           

--Query
select 
      poh.shipdate,
	  soh.OrderDate,
	  poh.TaxAmt
from Sales.SalesOrderHeader as soh,
Purchasing.PurchaseOrderHeader as poh
where poh.ShipMethodID = soh.ShipMethodID
and poh.shipdate = soh.OrderDate

--Q 7) find the average days required to ship the product based on shipment type. 

--RequiredTables
select* from Purchasing.PurchaseOrderHeader
select* from Purchasing.ShipMethod

--Query
select 
    poh.ShipMethodID,
    AVG(DATEDIFF(DAY, poh.OrderDate, poh.ShipDate)) AS avg_days_to_ship
from Purchasing.PurchaseOrderHeader poh
group BY poh.ShipMethodID;

--- 8) find the name of employees working in day shift 

SELECT * FROM HumanResources.EmployeeDepartmentHistory     
SELECT * FROM HumanResources.Shift						   
SELECT * FROM Person.Person                                

SELECT distinct p.FirstName,p.BusinessEntityID
FROM HumanResources.EmployeeDepartmentHistory as ed,
HumanResources.Shift as s,
Person.Person as p
WHERE ed.BusinessEntityID = p.BusinessEntityID
and ed.ShiftID = 1

--------------------------------------------------------

SELECT Firstname FROM Person.Person
WHERE BusinessEntityID in
(SELECT BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory
WHERE ShiftId in
(SELECT ShiftID FROM HumanResources.shift
WHERE name = 'Day'))


---Q 9) based on product and product cost history find the name , service provider time and average Standardcost   

SELECT * FROM Production.Product                
SELECT * FROM Production.ProductCostHistory     

SELECT 
      p.name,
	  avg(pc.StandardCost) avg_std_cost,
	  count(datediff(day,pc.StartDate,pc.EndDate)) Service_provided_time
FROM Production.Product as p,
Production.ProductCostHistory as pc
WHERE p.ProductID = pc.ProductID
GROUP BY p.name

--- Q 10) find products with average cost more than 500

SELECT * FROM Production.Product  

SELECT name,
       avg(Standardcost) as avg_cost
FROM Production.Product
GROUP BY name
Having avg(Standardcost) > 500

--Q 11) find the employee who worked in multiple territory

SELECT * FROM Sales.SalesTerritory
SELECT * FROM Sales.SalesTerritoryHistory
SELECT * FROM Person.Person

SELECT p.BusinessEntityID,
       p.firstname,
       count(*)TerritoryID
FROM Sales.SalesTerritory as st,
Sales.SalesTerritoryHistory as sth,
Person.Person as p
WHERE
st.TerritoryID = sth.TerritoryID
and sth.BusinessEntityID = p.BusinessEntityID
GROUP BY p.BusinessEntityID,p.FirstName
HAVING count(*) > 1

-- Q 12) find out the Product model name,  product description for culture as Arabic 

SELECT * FROM Production.Product              
SELECT * FROM Production.ProductDescription
SELECT * FROM Production.ProductModelProductDescriptionCulture
SELECT * FROM Production.Culture

SELECT 
      p.name,
	  pd.Description
FROM Production.Product as p,
Production.ProductDescription as pd,
Production.Culture as c,
production.ProductModelProductDescriptionCulture as pdc
WHERE p.ProductModelID = pdc.ProductModelID
and pdc.ProductDescriptionID = pd.ProductDescriptionID
and pdc.CultureID = c.CultureID
and c.Name like '%arabic%'

---13)Find first 20 employees who joined very early in the company

SELECT top 20 p.BusinessEntityID,p.FirstName,p.LastName,HireDate 
FROM HumanResources.Employee as e,
Person.Person as p
WHERE p.BusinessEntityID = e.BusinessEntityID
ORDER BY HireDate ;

--- 14)Find most trending product based on sales and purchase.
SELECT * FROM Purchasing.PurchaseOrderDetail
SELECT * FROM Sales.SalesOrderDetail

SELECT pod.ProductID
FROM Purchasing.PurchaseOrderDetail as pod
WHERE pod.ProductID in(SELECT sod.ProductID,sum(orderqty)
FROM Sales.SalesOrderDetail as sod
GROUP BY sod.ProductID)

-----##SubQueries---

--- Q 15) display EMP name, territory name, saleslastyear salesquota and bonus

SELECT * FROM Sales.SalesTerritory  
SELECT * FROM Sales.SalesPerson      
SELECT * FROM HumanResources.Employee 
SELECT * FROM Person.Person           
SELECT * FROM Sales.Customer          
SELECT * FROM Sales.SalesOrderDetail  
SELECT * FROM Sales.SalesTaxRate      

--Query
SELECT 
       (SELECT firstname FROM Person.Person pp
	   WHERE pp.BusinessEntityID = sp.BusinessEntityID) Emp_name, 
       (SELECT [Group] FROM Sales.SalesTerritory st
	   WHERE st.TerritoryID = sp.TerritoryID)Territory_group,
	   (SELECT name FROM Sales.SalesTerritory st
	   WHERE st.TerritoryID = sp.TerritoryID)Territory_name,
SalesQuota,Bonus,SalesLastYear 
FROM Sales.SalesPerson sp;


--- Q 16) display EMP name, territory name, saleslastyear salesquota and bonus from Germany and United Kingdom 

SELECT
      (SELECT firstname FROM Person.Person pp
	   WHERE pp.BusinessEntityID = sp.BusinessEntityID) Emp_name,
	  (SELECT [Group] FROM Sales.SalesTerritory st
	   WHERE st.TerritoryID = sp.TerritoryID)Territory_group,
	  (SELECT name FROM Sales.SalesTerritory st
	   WHERE st.TerritoryID = sp.TerritoryID)Territory_name,	
SalesQuota,Bonus,SalesLastYear 
FROM Sales.SalesPerson sp
WHERE TerritoryID in
            (SELECT TerritoryID FROM Sales.SalesTerritory st
			WHERE Name = 'Germany' or Name = 'United Kingdom')


--- Q 17) Find all employees who worked in all North America territory 

SELECT * FROM Sales.SalesTerritory   
SELECT * FROM Sales.SalesPerson      
SELECT * FROM Person.Person          

--Query
SELECT
      (SELECT firstname FROM Person.Person pp
	  WHERE pp.BusinessEntityID = sp.BusinessEntityID) Emp_name,
	  (SELECT [Group] FROM Sales.SalesTerritory st
	  WHERE st.TerritoryID = sp.TerritoryID) 
FROM Sales.SalesPerson sp
WHERE TerritoryID IN
	       (SELECT TerritoryID FROM Sales.SalesTerritory st
	       WHERE [Group] = 'North America') 

--- 18) find all products in the cart 

SELECT * FROM Production.Product       
SELECT * FROM Sales.ShoppingCartItem   

SELECT sc.*,
      (SELECT name FROM Production.Product pp
	   WHERE pp.ProductID = sc.ProductID)Product_name
FROM Sales.ShoppingCartItem sc

--- Q 19) find all the products with special offer 

select * from sales.SpecialOffer               
select * from Purchasing.ShipMethod            
select * from Purchasing.ProductVendor         
select * from Purchasing.PurchaseOrderDetail   
select * from Production.Product
select * from Sales.SpecialOfferProduct

SELECT sp.*,
     (SELECT ProductID FROM Sales.SpecialOffer so
	 WHERE so.SpecialOfferID=sp.SpecialOfferID) special_offer_product
	 FROM Sales.SpecialOfferProduct sp

SELECT 
	(SELECT name FROM Production.Product as p
	WHERE p.ProductID=so.ProductID) as prodname,
	(SELECT productnumber FROM Production.Product as p
	WHERE p.ProductID = so.ProductID) as prodnum
FROM sales.SpecialOfferProduct so ;


---20)find all employees name,job title, card details whose 
--credit card expired in the month 11 and year as 2008 

SELECT
    (SELECT concat_ws(' ',pp.FirstName,pp.LastName) FROM Person.person as pp
	WHERE pp.BusinessEntityID = pcc.BusinessEntityID) as fullname,
	(SELECT JobTitle FROM HumanResources.Employee as e
	WHERE e.BusinessEntityID = pcc.BusinessEntityID) as jobtitle,
	(SELECT concat_ws(' ',CardType,CardNumber) FROM Sales.CreditCard as cc
	WHERE cc.CreditCardID = pcc.CreditCardID) as cardnum
FROM Sales.PersonCreditCard as pcc;

--- Q 21) Find the employee whose payment might be revised  (Hint : Employee payment history) 

SELECT * FROM HumanResources.EmployeePayHistory            
SELECT BusinessEntityID,
       count(*) as emp_paymend_revised
FROM HumanResources.EmployeePayHistory emh
GROUP BY BusinessEntityID
Having count(*) > 1 ;

--- person whose salary is not revised

SELECT * FROM HumanResources.Employee
WHERE BusinessEntityID not in (SELECT BusinessEntityID
FROM HumanResources.EmployeePayHistory)

---22)Find total standard cost for the active Product. (Product cost history)

SELECT * FROM Production.ProductCostHistory;
SELECT * FROM Production.Product;

SELECT pch.ProductID,sum(pp.standardcost) as total_stdcost
FROM Production.ProductCostHistory as pch,
Production.Product as pp
WHERE pp.ProductID=pch.ProductID
GROUP BY pch.ProductID

------###JOINS --------

--- Q 23) Find the personal details with address and address type(hint: Business Entiry Address , Address, Address type) 

SELECT * FROM Person.Address                    -- add id, add line 1,city
SELECT * FROM Person.BusinessEntityAddress      -- business id,add id,add type id
SELECT * FROM Person.AddressType                -- add type id, name
SELECT * FROM Person.Person                     -- business id, first name

SELECT 
       p.FirstName,
       a.AddressLine1,
	   at.name as address_type
FROM Person.Address as a,
Person.BusinessEntityAddress as ba,
Person.AddressType as at,
Person.Person as p
WHERE a.AddressID = ba.AddressID
and ba.AddressTypeID = at.AddressTypeID
and ba.BusinessEntityID = p.BusinessEntityID 


 --- Q 24) Find the name of employees working in group of North America territory 

 SELECT * FROM HumanResources.Employee
 SELECT * FROM Sales.SalesTerritory
 SELECT * FROM Person.Person
 SELECT * FROM Sales.SalesTerritoryHistory

 SELECT 
        p.FirstName,
		s.[Group]
 FROM HumanResources.Employee as e,
 Sales.SalesTerritory as s,
 Person.Person as p,
 Sales.SalesTerritoryHistory as st
 WHERE e.BusinessEntityID = p.BusinessEntityID
 and p.BusinessEntityID = st.BusinessEntityID
 and st.TerritoryID = s.TerritoryID
 and [Group] = 'North America'

------### Group by---

/*25. Find the employee whose payment is revised for more than once*/

--Query
select p.BusinessEntityID
from Person.person p
join [HumanResources].[EmployeePayHistory] ep
on p.BusinessEntityId=ep.BusinessEntityId
group by p.BusinessEntityID,p.firstName,p.LastName
having COUNT(*)>1


/*26. display the personal details of employee whose payment is revised for more than once.*/

--RequiredTable
select*from person.person
select*from [Person].[PersonPhone]
select*from [HumanResources].[EmployeePayHistory]

--Query
select p.BusinessEntityID,
concat_ws(' ',p.firstName,p.LastName)EMP_Name,
pp.PhoneNumber
from Person.person p
join [HumanResources].[EmployeePayHistory] ep
on p.BusinessEntityId=ep.BusinessEntityId
join [Person].[PersonPhone] pp
on pp.BusinessEntityId=ep.BusinessEntityId
group by p.BusinessEntityID,p.firstName,p.LastName,pp.PhoneNumber
having COUNT(*)>1

/*27. Which shelf is having maximum quantity (product inventory)*/

--RequiredTable
select*from [Production].[ProductInventory]

--Query
select top 1 Shelf,
sum(Quantity) sum_of_Quant
from [Production].[ProductInventory]
group by Shelf
order by sum_of_Quant desc

/*28. Which shelf is using maximum bin(product inventory)*/

--RequiredTable
select*from [Production].[ProductInventory]

--Query
select top 1 Productid, Shelf,
sum(bin) Total_bin
from [Production].[ProductInventory]
group by  Productid,Shelf
order by Total_bin desc

SELECT TOP 1 Shelf, COUNT(DISTINCT Bin) AS Bin_Count
FROM Production.ProductInventory
GROUP BY Shelf
ORDER BY Bin_Count DESC;

--29. Which location is having minimum bin (product inventory)

--RequiredTable
select*from [Production].[ProductInventory]

--Query
select top 1 LocationId , count(distinct bin)dis_bin
from [Production].[ProductInventory]
group by LocationId 
order by dis_bin asc

--30. Find out the product available in most of the locations (product inventory)

--RequiredTable
select*from [Production].[ProductInventory]

--Query
select top 1  ProductId, count(distinct LocationId)dis_LocationID
from [Production].[ProductInventory]
group by ProductId 
order by dis_LocationID  desc;


--31. Which sales order is having most order qualtity.

--RequiredTable
select*from [Sales].[SalesOrderDetail]

--Query
select top 1 SalesOrderID, sum(Orderqty) Count_OrterQty
from [Sales].[SalesOrderDetail]
group by SalesOrderID
order by Count_OrterQty desc

/*32. find the duration of payment revision on every interval
(inline view) Output must be as given format
## revised time – count of revised salries
## duration – last duration of revision e.g there are two revision date
01-01-2022 and revised in 01-01-2024 so duration here is 2years
First name Last name Revised time duration
abc xyz 3*/

SELECT 
    p.FirstName, 
    p.LastName, 
    ep.Revised_Time, 
    ep.Duration
FROM 
    Person.Person p
JOIN 
    (SELECT 
         BusinessEntityID, 
         COUNT(RateChangeDate) AS Revised_Time, 
         DATEDIFF(YEAR, MIN(RateChangeDate), MAX(RateChangeDate)) AS Duration
     FROM 
         HumanResources.EmployeePayHistory
     GROUP BY 
         BusinessEntityID
    ) ep 
ON p.BusinessEntityID = ep.BusinessEntityID
ORDER BY 
    ep.Revised_Time DESC;

--33. check if any employee from jobcandidate table is having any payment revisions.

--RequiredTable
select*from [HumanResources].[JobCandidate]
select*from [HumanResources].[EmployeePayHistory]

--Query
select j.JobCandidateId,
j.BusinessEntityID,
count(ep.BusinessEntityID)Pay_revision
from [HumanResources].[JobCandidate] j
join [HumanResources].[EmployeePayHistory] ep
on j.BusinessEntityID=ep.BusinessEntityID
group by j.JobCandidateId,j.BusinessEntityID
having count(ep.BusinessEntityID)>0

--34. check the department having more salary revision

--RequiredTable
select *from [HumanResources].[Department]
select *from[HumanResources].[EmployeeDepartmentHistory]
select*from [HumanResources].[EmployeePayHistory]

--Query
select d.DepartmentID,d.Name DeptName,
count(ep.BusinessEntityID)Salary_revision
from [HumanResources].[EmployeeDepartmentHistory] ed
join [HumanResources].[EmployeePayHistory] ep
on ep.BusinessEntityID=ed.BusinessEntityID
join [HumanResources].[Department] d
on d.departmentID=ed.departmentID
group by d.DepartmentID,d.Name
order by Salary_revision desc

--35. check the employee whose payment is not yet revised

SELECT e.BusinessEntityID, p.FirstName, p.LastName
FROM HumanResources.Employee e
JOIN Person.Person p 
ON e.BusinessEntityID = p.BusinessEntityID
LEFT JOIN HumanResources.EmployeePayHistory eph 
    ON e.BusinessEntityID = eph.BusinessEntityID
WHERE eph.BusinessEntityID IS NULL;

--36. find the job title having more revised payments

--RequiredTable
select*from [HumanResources].[Employee]

--Query
select e.JobTitle,
count(e.BusinessEntityID)Pay_revision
from [HumanResources].[EmployeeDepartmentHistory] ed
join [HumanResources].[Employee] e
on e.businessEntityId=ed.BusinessEntityID
group by e.JobTitle
order by Pay_revision desc

--37. find the employee whose payment is revised in shortest duration (inline view)


--38. find the colour wise count of the product (tbl: product)

--RequiredTable
select*from production.Product

--Query
select color, count(*)product_count
from production.Product
where color is not null
group by color
order by product_count desc

--39. find out the product who are not in position to sell 
--(hint: check the sell start and end date)

select*from production.Product

--Query
select p.name,
       p.ProductID,
       p.SellStartDate,
	   p.SellEndDate 
from Production.Product p
where p.SellEndDate IS NOT NULL


--40. find the class wise, style wise average standard cost

select * from Production.Product 

--Query
select p.Class,
       p.Style,
	   avg(p.StandardCost)
from Production.Product p
where p.style is not null or p.class is not null
group by p.Class,p.Style

--41. check colour wise standard cost

select* from Production.Product

--Query
select p.color,
       sum(p.StandardCost)
from Production.Product as p
where p.Color is not NULL
group by p.color

--42. find the product line wise standard cost

--Query
select 
      p.ProductLine,
      sum(p.StandardCost) Standard_cost
from Production.Product p
where p.ProductLine is not null
group by p.ProductLine


--43. Find the state wise tax rate (hint: Sales.SalesTaxRate, Person.StateProvince)
--RequiredTable
select*from Sales.SalesTaxRate
select*from Person.StateProvince

--Query
select
      st.StateProvinceID,
	  sp.name,
	  sum(st.TaxRate)
from Sales.SalesTaxRate as st,
Person.StateProvince as sp
where st.StateProvinceID = sp.StateProvinceID
group by st.StateProvinceID,sp.name  


--44. Find the department wise count of employees
--RequiredTable
select *from HumanResources.Department
select *from HumanResources.EmployeeDepartmentHistory

--Query
select 
      d.name,
	  count(*) dept_wise_count
from HumanResources.Department as d,
HumanResources.EmployeeDepartmentHistory as ed
where d.DepartmentID = ed.DepartmentID
group by d.name 
order by count(*) desc

--45. Find the department which is having more employees

--Query
select top(1) d.name,
	   count(*) dept_wise_count
from HumanResources.Department as d,
HumanResources.EmployeeDepartmentHistory as ed
where d.DepartmentID = ed.DepartmentID
group by d.name 
order by count(*) desc


--46. Find the job title having more employees

select 
       e.JobTitle,
	   count(e.BusinessEntityID) as count
from HumanResources.Employee e
Group by e.JobTitle
order by count(e.BusinessEntityID) desc;

---or
select top 1
       e.JobTitle,
	   count(e.BusinessEntityID) as count
from HumanResources.Employee e
Group by e.JobTitle
order by count(e.BusinessEntityID) desc;


--47. Check if there is mass hiring of employees on single day
--RequiredTable
select * from HumanResources.JobCandidate
select * from HumanResources.Employee

--Query
select e.HireDate,
	   count(e.BusinessEntityID) count_of_employee
from HumanResources.Employee as e
group by e.HireDate
order by count(e.BusinessEntityID) desc;

--48. Which product is purchased more? (purchase order details)

--RequiredTable
select * from Purchasing.PurchaseOrderDetail;
select * from Production.Product;
--Query
select distinct top 1 pod.ProductID,
pp.Name,
sum(pod.OrderQty) over (partition by pod.ProductID) as total_orderqty
from Purchasing.PurchaseOrderDetail as pod,
Production.Product as pp
where pp.ProductID = pod.ProductID
order BY total_orderqty desc;

--49. Find the territory wise customers count (hint: customer)

--RequiredTable
select * from Sales.SalesTerritoryHistory
select * from Sales.Customer
--Query
select distinct territoryid,
count(CustomerID) over (partition by territoryid) as cust_cnt
from Sales.Customer;

--50. Which territory is having more customers (hint: customer)

--Query
select distinct top 1 territoryid,
count(CustomerID) over (partition by territoryid) as cust_cnt
from Sales.Customer
order by cust_cnt desc

--51. Which territory is having more stores (hint: customer)
select * from Sales.Customer

select distinct top 1 territoryid,
count(StoreID) over (partition by territoryid) as store_cnt
from Sales.Customer
order by store_cnt desc

--52. Is there any person having more than one credit card (hint: PersonCreditCard)
--RequiredTable
select * from Sales.PersonCreditCard;

--Query
select BusinessEntityID,count(Creditcardid)
from Sales.PersonCreditCard
group by BusinessEntityID
having count(Creditcardid) > 1;
--Conclusion:there is no person having more than one credit card

--53. Find the product wise sale price (sales order details)
--RequiredTable
select* from Sales.SalesOrderDetail;

--Query
select distinct ProductID,
sum(UnitPrice) over (partition by productid) as salesprice
from Sales.SalesOrderDetail

--54. Find the total values for line total product having maximum order
--RequiredTable
select * from Sales.SalesOrderDetail

--Query
select distinct linetotal,
sum(OrderQty) over (partition by linetotal) as ord
from Sales.SalesOrderDetail
order by ord desc


------### Date queries----

/*55. Calculate the age of employees*/
--requiredTAble
select*from [HumanResources].[Employee]
select*from person.Person
--Query
select concat_ws('',p.FirstName,p.LastName) Emp_NAme,
datediff(year,birthdate,getdate()) Age
from [HumanResources].[Employee] e,
person.person p
where e.BusinessEntityID=p.BusinessEntityID

/*56. Calculate the year of experience of the employee based on hire date*/
select concat_ws('',p.FirstName,p.LastName) Emp_NAme,
datediff(year,HireDate,getdate()) Year_of_exp
from [HumanResources].[Employee] e,
person.person p
where e.BusinessEntityID=p.BusinessEntityID

/*57. Find the age of employee at the time of joining*/
select concat_ws('',p.FirstName,p.LastName) Emp_NAme,
datediff(year,birthdate,HireDate) Age_at_joining
from [HumanResources].[Employee] e,
person.person p
where e.BusinessEntityID=p.BusinessEntityID

/*58. Find the average age of male and female*/
--RequiredTable
select*from [HumanResources].[Employee]
--Query
select Gender,
avg(datediff(year,birthdate,getdate()))Age
from [HumanResources].[Employee]
group by gender

/*59. Which product is the oldest product as on the date
(refer the product sell start date)*/

--RequiredTable
select*from production.Product

--Query
select top 1 NAme ProductNAme,
datediff(day,sellstartDate,getdate())Oldest_product
from production.Product
order by Oldest_product desc


/*60. Display the product name, standard cost, 
and time duration for the same cost. (Product cost history)*/

--RequiredTable
select*from Production.product
select *from [Production].[ProductCostHistory]

--Query
select p.NAme ProductName,
h.Standardcost,
DateDiff(HOUR,h.StartDate,h.EndDate)Time_Duration
from Production.product p,
[Production].[ProductCostHistory] h
where P.ProductID=h.ProductID

/*61. Find the purchase id where shipment is done 1 month later of order date*/

--RequiredTable
select*from Purchasing.PurchaseOrderHeader

--Query
select PurchaseORderID
from Purchasing.PurchaseOrderHeader
where ShipDate=DATEADD(Month,1,OrderDate)

--Output=0 rows
--Conclusion:So, There is No purchase id where shipment is done 1 month later of order date

/*62. Find the sum of total due where shipment is done 1 month later of order date 
( purchase order header)*/

--RequiredTable
select*from Purchasing.PurchaseOrderHeader

--Query
select sum(TotalDue) SumOfTOtalDue
from Purchasing.PurchaseOrderHeader
where ShipDate=DATEADD(Month,1,OrderDate)

/*63. Find the average difference in due date and ship date based on online order flag*/

--RequiredTable
Select*from sales.SalesOrderHeader

--Query
select distinct(OnlineOrderFlag),
avg(Datediff(Day,Duedate,Shipdate))over (partition by OnlineOrderFlag)avg_Due_ship_diff
from sales.SalesOrderHeader
--Or
select OnlineOrderFlag,
avg(Datediff(Day,Duedate,Shipdate))avg_Due_ship_diff
from sales.SalesOrderHeader
group by OnlineOrderFlag

-------###Window functions-----

/*64. Display business entity id, marital status, gender, vacationhr, 
average vacation based on marital status*/

--required table
select*from HumanResources.Employee

--Query
select BusinessentityID,
maritalStatus,
Gender,
vacationHours,
avg(vacationHours) over(partition by maritalStatus)avg_vac_hrs
from HumanResources.Employee

--or
select
BusinessentityID,
maritalStatus,
Gender,
vacationHours,
avg(vacationHours)
from HumanResources.Employee
group by BusinessentityID,
maritalStatus,
Gender,
vacationHours

/*65. Display business entity id, marital status, gender, vacationhr, average vacation based on gender*/

--tableRequired
select*from HumanResources.Employee

--Query
select BusinessentityID,
maritalStatus,
Gender,
vacationHours,
avg(vacationHours) over(partition by gender)avg_vac_hrs
from HumanResources.Employee

/*66. Display business entity id, marital status, gender, vacationhr, 
average vacation based on organizational level*/

--RequiredTable
select* from HumanResources.Employee
select*from HumanResources.EmployeePayHistory 

--Query
select BusinessentityID,
maritalStatus,
Gender,
vacationHours,
avg(vacationHours) over(partition by Organizationlevel)avg_vac_hrs
from HumanResources.Employee

/*67. Display entity id, hire date, department name and 
department wise count of employee and count based on organizational level in each dept*/

--Required Table
select* from HumanResources.Employee 
select*from HumanResources.EmployeeDepartmentHistory
select*from HumanResources.Department

--Query
select e.BusinessEntityID,
e.hireDate,
d.name dept_name,
count(d.departmentID) over(partition by organizationlevel) dept_count
from HumanResources.Employee e 
join HumanResources.EmployeeDepartmentHistory ed
on e.BusinessEntityID=ed.BusinessEntityID 
join HumanResources.Department d
on d.DepartmentID=ed.DepartmentID

/*68. Display department name, average sick leave and sick leave per department*/

--Required Table
select*from HumanResources.Employee
select*from HumanResources.Department

--Query
select distinct(d.NAme),
(select avg(e.sickLeavehours) from HumanResources.Employee e)avg_Sick_leave_per_dept,
count(e.sickLeavehours)over (partition by d.Name)Sick_leave_per_dept
from HumanResources.Employee e
join HumanResources.EmployeeDepartmentHistory ed
on e.BusinessEntityID=ed.BusinessEntityID 
join HumanResources.Department d
on d.DepartmentID=ed.DepartmentID

/*69. Display the employee details first name, last name, 
with total count of various shift done by the person and shifts count per department*/

--Required table
select*from Person.Person
select*from HumanResources.Employee
select*from HumanResources.Shift
select*from HumanResources.EmployeeDepartmentHistory

--Query
select pp.firstNAme,
pp.LAstName,
count(s.shiftID)over (partition by pp.BusinessEntityID)Total_countPerEMp,
count(s.shiftID)over (partition by ed.departmentID)Total_countPerDep
from Person.Person pp,
HumanResources.EmployeeDepartmentHistory ed,
HumanResources.Shift s
where 
pp.businessEntityID=ed.BusinessEntityID and
s.ShiftID=ed.ShiftID

/*70. Display country region code, group average sales quota based on territory id*/

--Required Table
select*from Sales.SalesPerson
select*from Sales.SalesTerritory

--Query
select distinct(t.countryRegioncode),
t.[Group],
avg(p.salesquota) over(partition by p.territoryId)avg_salesquota
from
Sales.SalesPerson p
join Sales.SalesTerritory t
on p.territoryID=t.territoryID

/*71. Display special offer description, category and avg(discount pct) per the category*/

--required table
select*from Sales.SpecialOffer
select*from Sales.SpecialOfferProduct

--Query
select description,
category,
avg(discountPCT) over (partition by category)avg_dct
from Sales.SpecialOffer

/*72. Display special offer description, category and avg(discount pct) per the month*/

--required Table
select*from Sales.SpecialOffer
select*from Sales.SpecialOfferProduct

--Query
select description,
category,
avg(discountPCT) over (partition by month(StartDate))avg_dct_per_month
from Sales.SpecialOffer

/*73. Display special offer description, category and avg(discount pct) per the year*/

--required table
select*from Sales.SpecialOffer
select*from Sales.SpecialOfferProduct

--Query
select description,
category,
avg(discountPCT) over (partition by year(StartDate))avg_dct_per_year
from Sales.SpecialOffer

/*74. Display special offer description, category and avg(discount pct) per the type*/

--Required Table
select*from Sales.SpecialOffer
select*from Sales.SpecialOfferProduct

--Query
select description,
category,
avg(discountPCT) over (partition by type)avg_dct_per_type
from Sales.SpecialOffer

/*75. Using rank and dense rank find territory wise top sales person*/

--Required Table
select*from Sales.SalesPerson
select*from Sales.SalesTerritory
select*from person.Person

--Query
select 
concat_ws(' ',pp.firstname,pp.lastname)Sales_person,
rank()over(partition by t.Name order by t.territoryID)rank_,
dense_rank() over (partition by t.Name order by t.territoryID)denseRank
from Sales.SalesPerson p
join Sales.SalesTerritory t
on p.TerritoryID=t.TerritoryID
join person.Person pp
on pp.BusinessEntityID=p.BusinessEntityID
