

--Update

Update RamyaDemo..EmployeeDetails
Set Gender = 'Female'
Where FirstName = 'Marsh' and LastName = 'Mellow'

Delete From 'TableName'
Where 'filter name'

---------------------------------------------------------------

--Joins

Select Jobtitle, Avg(Salary)
From RamyaDemo.dbo.EmployeeDetails
Inner Join RamyaDemo.dbo.SalaryInformation
	On EmployeeDetails.EmployeeID = SalaryInformation.EmployeeID
Where Jobtitle = 'Developer'
Group by Jobtitle

----------------------------------------------------------------


--Case Statement


Select FirstName, LastName, Age,
Case
	When Age = 35 Then 'Cool'
	When Age > 30 Then 'Old'
	Else 'Baby'
END
From RamyaDemo. dbo.EmployeeDetails
Where Age is NOT NULL
Order by Age


Select FirstName, LastName, Jobtitle, Salary,
Case
	WHEN Jobtitle = 'Developer' Then Salary + (Salary * .10)
	WHEN Jobtitle = 'Business Analyst' Then Salary + (Salary * .05)
	WHEN Jobtitle = 'Data Engineer' Then Salary + (Salary * .02)
	ELSE Salary + (Salary * .04)
END as NewSalary
From RamyaDemo.dbo.EmployeeDetails
Join RamyaDemo.dbo.SalaryInformation
	ON EmployeeDetails.EmployeeID = SalaryInformation.EmployeeID

---------------------------------------------------------------------------------------


--Having Clause


Select Jobtitle, Avg(Salary)
From RamyaDemo.dbo.EmployeeDetails
Join RamyaDemo.dbo.SalaryInformation
	ON EmployeeDetails.EmployeeID = SalaryInformation.EmployeeID
Group by Jobtitle
Having Avg(Salary) > 70000
Order by Avg(Salary)

-----------------------------------------------------------------------------


/* Aliasing */

Select FirstName + ' ' + LastName As FullName
From [RamyaDemo].[dbo].[EmployeeDetails]

Select Demo.EmployeeID, Sal.Salary
From [RamyaDemo].[dbo].[EmployeeDetails] AS Demo
JOIN [RamyaDemo].[dbo].[SalaryInformation] AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID

----------------------------------------------------------------------------

/* Partition by */

SELECT FirstName, LastName, Gender, Salary,
	COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender
FROM RamyaDemo.dbo.EmployeeDetails demo
JOIN RamyaDemo.dbo.SalaryInformation sal
	ON demo.EmployeeID = sal.EmployeeID

-----------------------------------------------------------------------------

/* Group By */

SELECT FirstName, LastName, Gender, Salary, COUNT(Gender)
FROM RamyaDemo.dbo.EmployeeDetails demo
JOIN RamyaDemo.dbo.SalaryInformation sal
	ON demo.EmployeeID = sal.EmployeeID
GROUP BY FirstName, LastName, Gender, Salary


SELECT Gender, COUNT(Gender)
FROM RamyaDemo.dbo.EmployeeDetails demo
JOIN RamyaDemo.dbo.SalaryInformation sal
	ON demo.EmployeeID = sal.EmployeeID
GROUP BY Gender

-----------------------------------------------------------------------------------

/* CTEs */

like a subquery - put in temporary place to get the data

WITH CTE_Employee AS
 (SELECT FirstName, LastName, Gender, Salary,
 COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender,
 AVG(Salary) OVER (PARTITION BY Gender) AS AvgSalary
FROM RamyaDemo..EmployeeDetails demo
JOIN RamyaDemo..SalaryInformation sal
	ON demo.EmployeeID = sal.EmployeeID
WHERE Salary > 70000
)
SELECT FirstName, AvgSalary
FROM CTE_Employee

---------------------------------------------------------------------------------------


/* Temp Tables */

saves runtime

CREATE TABLE #Temp_Employee(
EmployeeID int,
JobTitle varchar (100),
Salary int
)

SELECT *
FROM #Temp_Employee

INSERT INTO #Temp_Employee VALUES (
'1001', 'HR', '50000'
)

INSERT INTO #Temp_Employee
SELECT *
FROM RamyaDemo..SalaryInformation



CREATE TABLE #temp_Employee2 (
Jobtitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #temp_Employee2
SELECT Jobtitle, Count(Jobtitle), Avg(Age), Avg(Salary)
FROM RamyaDemo..EmployeeDetails demo
JOIN RamyaDemo..SalaryInformation sal
	ON demo.EmployeeID = sal.EmployeeID
GROUP BY Jobtitle

SELECT *
FROM #Temp_Employee2
