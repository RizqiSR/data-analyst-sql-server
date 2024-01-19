--1. CREATE TABLE :

CREATE TABLE EmployeeDemographics
(EmployeeID int,
firstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)

--CREATE TABLE EmployeeSalary
--(EmployeeID int,
--jobTitle varchar(50),
--Salary int
--)


--2. INSERT INTO ... VALUES:
--INSERT INTO EmployeeDemographics VALUES
--(NULL, 'Holly' ,'Flax', NULL, NULL),
--(1011, 'Ryan', 'Howard', 26, 'Male'),
--(1013, 'Darryl', 'Philbin', NULL, 'Male')



--INSERT INTO EmployeeSalary VALUES
--(1001, 'Salesman', 45000)

--Create Table WareHouseEmployeeDemographics 
--(EmployeeID int, 
--FirstName varchar(50), 
--LastName varchar(50), 
--Age int, 
--Gender varchar(50)
--)

Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')

--SELECT *
--FROM [SQL Tutorial].dbo.EmployeeSalary

--SELECT *
--FROM [SQL Tutorial].dbo.EmployeeDemographics

--SELECT *
--from [SQL Tutorial].dbo.WareHouseEmployeeDemographics
--ORDER BY EmployeeID

--SELECT Gender, Age, COUNT(Gender)
--FROM EmployeeDemographics
--GROUP BY Gender, Age


/*-- UNION: to combine 2 different tables with the same total columns, data types, and values type --*/
--SELECT EmployeeID, firstName, Age 
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--UNION
--SELECT EmployeeID, jobTitle, Salary
--FROM [SQL Tutorial].dbo.EmployeeSalary


/*-- JOINS: to combine 2 different tables, either it's FULL OUTER JOIN, INNER JOIN, LEFT OUTER JOIN, LEFT JOIN, RIGHT OUTER JOIN, or RIGHT JOIN. Depends --*/
--SELECT jobTitle, AVG(Salary) AS AverageSalary
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--Inner Join [SQL Tutorial].dbo.EmployeeSalary
--	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--WHERE jobTitle = 'Salesman'
--GROUP BY jobTitle

--SELECT *
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--Full Outer Join [SQL Tutorial].dbo.WareHouseEmployeeDemographics
--	ON EmployeeDemographics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID


/*-- CASE STATEMENTS: The use is the same with if-else in programming --*/
--SELECT firstName, LastName, Age,
--CASE
--	WHEN Age > 30 THEN 'Old'
--	WHEN Age BETWEEN  27 AND 30 THEN 'Young'
--	ELSE 'Baby'
--END
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--WHERE Age is NOT NULL
--ORDER BY Age

--SELECT firstName, LastName, jobTitle, Salary,
--CASE
--	WHEN jobTitle = 'Frontend Engineer' AND jobTitle = 'Data Analyst' THEN Salary + (Salary * 0.15)
--	WHEN jobTitle = 'Salesman' AND jobTitle = 'Business Analyst' THEN Salary + (Salary * .10)
--	WHEN jobTitle = 'Accountant' AND jobTitle = 'Social Media Specialist' THEN Salary + (Salary * .05)
--	ELSE Salary + (Salary * .03)
--END AS SalaryAfterRaise
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--JOIN [SQL Tutorial].dbo.EmployeeSalary
--	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


/*-- HAVING: If we want to filter something that counted before (agregated) --*/
--SELECT jobTitle, AVG(Salary)
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--JOIN [SQL Tutorial].dbo.EmployeeSalary
--	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--GROUP BY jobTitle
--HAVING AVG(Salary) > 45000
--ORDER BY AVG(Salary)

--SELECT *
--FROM [SQL Tutorial].dbo.EmployeeDemographics

/*-- UPDATE --*/
--UPDATE [SQL Tutorial].dbo.EmployeeDemographics
--SET Age = 32, Gender = 'Male'
--WHERE firstName = 'Darryl' AND LastName = 'Philbin'

--SELECT EmployeeID, COUNT(EmployeeID)
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--GROUP BY EmployeeID
--HAVING COUNT(EmployeeID) > 1


/*-- CTEs (Common Table Expressions): Make new temporary table stored in memory somewhere. The values you add can be the new value, OR the selected ones from your subquery. 
	 use: WITH temp_tableName
	 You can do the query(like SELECT * FROM temp_tableName), if it excecuted from the start you created them (Like: WITH  temp_tableName ... to SELECT * FROM temp_tableName)
	 The temp_tableName creation step will be excecute over and over again.
--*/
--WITH CTE_Employee as
--(
--SELECT firstName, LastName, Gender, Salary,
--	COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender,
--	AVG(Salary) OVER (PARTITION BY Salary) as AvgSalary
--FROM [SQL Tutorial].dbo.EmployeeDemographics Demo
--JOIN [SQL Tutorial].dbo.EmployeeSalary Sal
--	ON Demo.EmployeeID = Sal.EmployeeID
--)
--SELECT *
--FROM CTE_Employee


/*-- TEMP TABLES: Kinda similar to CTEs, but you don't have to excecute the CREATE TABLE over and over again. 
	 Tips: to prevent the duplicating #temp_tableName error, always write (DROP TABLE IF EXISTS #temp_tableName) before you (CREATE TABLE #temp_tableName)
--*/
--CREATE TABLE #temp_Employee
--(EmployeeID int,
--JobTitle varchar(50),
--Salary int)

--SELECT *
--FROM #temp_Employee

--INSERT INTO #temp_Employee VALUES (1001, 'Salesman', 45000)

--INSERT INTO #temp_Employee
--SELECT *
--FROM [SQL Tutorial].dbo.EmployeeSalary


--DROP TABLE IF EXISTS #Temp_Employee2
--CREATE TABLE #Temp_Employee2
--(JobTitle varchar(50),
--EmployeePerJob int,
--AvgAge int,
--AvgSalary int)

--INSERT INTO #Temp_Employee2
--SELECT jobTitle, COUNT(jobTitle), AVG(Age), AVG(Salary)
--FROM [SQL Tutorial].dbo.EmployeeDemographics Demo
--JOIN [SQL Tutorial].dbo.EmployeeSalary Sal
--	ON Demo.EmployeeID = Sal.EmployeeID
--GROUP BY jobTitle

--SELECT * FROM #Temp_Employee2

--/*-- STRING FUNCTIONS --*/
--CREATE TABLE EmployeeErrors (
--EmployeeID varchar(50)
--,FirstName varchar(50)
--,LastName varchar(50)
--)

--Insert into EmployeeErrors Values 
--('1001  ', 'Jimbo', 'Halbert')
--,('  1002', 'Pamela', 'Beasely')
--,('1005', 'TOby', 'Flenderson - Fired')

--Select *
--From [SQL Tutorial]..EmployeeErrors

--/*-- 1. TRIM, LTRIM (Left trim), RTRIM (Right Trim): get rid the blank spaces, either it's on the left or right side --*/
--SELECT EmployeeID, TRIM(EmployeeID)
--FROM [SQL Tutorial].dbo.EmployeeErrors

--SELECT EmployeeID, LTRIM(EmployeeID)
--FROM [SQL Tutorial]..EmployeeErrors

--SELECT EmployeeID, RTRIM(EmployeeID)
--FROM [SQL Tutorial]..EmployeeErrors


--/*-- 2. REPLACE:  --*/
--SELECT LastName, REPLACE(LastName, ' - Fired', '') as LastNameFixed
--FROM [SQL Tutorial]..EmployeeErrors

--/*-- 3. SUBSTRING: --*/
--SELECT Err.FirstName, SUBSTRING(Err.FirstName,1,3), Demo.firstName, SUBSTRING(Demo.firstName,1,3)
--FROM [SQL Tutorial]..EmployeeDemographics Demo
--JOIN [SQL Tutorial]..EmployeeErrors Err
--	ON SUBSTRING(Demo.firstName,1,3) = SUBSTRING(Err.FirstName,1,3) /* substring dipakai disini agar yg di-match TIDAK keseluruhan nama, hanya substring saja */

--/*-- 4. UPPER & LOWER --*/
--SELECT FirstName, UPPER(FirstName)
--FROM [SQL Tutorial]..EmployeeErrors

--SELECT FirstName, LOWER(FirstName)
--FROM [SQL Tutorial]..EmployeeErrors

/*-- 5. STORED PROCEDURES: Mirip function di programming (disimpan di Programmability > Stored Procedures), bisa menerima parameter juga, jadi bisa dikai berulang kali dimanapun --*/
--CREATE PROCEDURE TEST
--AS
--SELECT *
--FROM EmployeeDemographics

--EXEC TEST

--CREATE PROCEDURE Temp_Employee
--AS
--CREATE TABLE #temp_employee (
--JobTitle varchar(100),
--EmplyeesPerJob int,
--AvgAge int,
--AvgSalary int
--)

--INSERT INTO #temp_employee
--SELECT jobTitle, COUNT(jobTitle), AVG(Age), AVG(Salary)
--FROM EmployeeDemographics Dem
--JOIN EmployeeSalary Sal
--	ON Dem.EmployeeID = Sal.EmployeeID
--GROUP BY jobTitle

--SELECT *
--FROM #temp_employee

--EXEC Temp_Employee @jobTitle = 'Frontend Engineer'

/*-- 6. SUBQUERIES:  --*/
/* - Subquery in SELECT : */
SELECT EmployeeID, Salary, (SELECT AVG(Salary) FROM EmployeeSalary) as AllAvgSalary
FROM EmployeeSalary

/* - How to do it with Partition By: */
SELECT EmployeeID, Salary, 
	AVG(Salary) OVER () AS AvgSalary
FROM EmployeeSalary

/* - Why Group By doesn't work: */
SELECT EmployeeID, Salary, AVG(Salary) AS AllAvgSalary
FROM EmployeeSalary
GROUP BY EmployeeID, Salary
ORDER BY 1, 2

/* - Subquery in From: */
SELECT a.EmployeeID, AllAvgSalary
FROM (SELECT EmployeeID, Salary, AVG(Salary) over () AS AllAvgSalary FROM EmployeeSalary) AS a

/* - Subquery in Where: */
SELECT EmployeeID, jobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID in (
	SELECT EmployeeID 
	FROM EmployeeDemographics
	WHERE Age > 30)