Select EmployeeID, JobTitle, Salary
From SalaryInformation

-- Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From SalaryInformation) as AllAvgSalary
From SalaryInformation

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From SalaryInformation

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From SalaryInformation
Group By EmployeeID, Salary
order by EmployeeID

-- Subquery in From

Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From SalaryInformation) a
Order by a.EmployeeID

-- Subquery in Where


Select EmployeeID, JobTitle, Salary
From SalaryInformation
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDetails
	where Age > 30)
