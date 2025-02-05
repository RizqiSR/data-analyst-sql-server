USE [SQL Tutorial]
GO
/****** Object:  StoredProcedure [dbo].[Temp_Employee]    Script Date: 1/16/2024 8:10:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Temp_Employee]
@jobTitle nvarchar(100)
AS
CREATE TABLE #temp_employee (
JobTitle varchar(100),
EmplyeesPerJob int,
AvgAge int,
AvgSalary int
)

INSERT INTO #temp_employee
SELECT jobTitle, COUNT(jobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics Dem
JOIN EmployeeSalary Sal
	ON Dem.EmployeeID = Sal.EmployeeID
WHERE jobTitle = @jobTitle
GROUP BY jobTitle

SELECT *
FROM #temp_employee