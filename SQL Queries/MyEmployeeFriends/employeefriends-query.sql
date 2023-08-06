USE Employeefriends;



SELECT			 -- Selecting all the collum from employee table
*
FROM 
Employee;


INSERT INTO Employee -- Adding rows to the employee table
	VALUES 
		(15, 1, 'Bizky','Lucena', 18, 'Female', 5, 20900,1);


UPDATE Employee -- Updating data from employee table (Missing data)
	SET
		gender = 'Male'
	WHERE 
		employee_id IN (4,12);

UPDATE Employee 
	SET
		salary = 19350
	WHERE
		employee_id = 9;
	

SELECT		-- Selecting speciffic column
	employee_id,
	last_name,
	salary
FROM
	Employee;


SELECT			-- Shows the full name, age and gender of the employee
	CONCAT(first_name,' ',last_name) AS 'full name',
	age,
	gender
FROM
	Employee;



SELECT			-- Count of active employees in every department
	department_id,
	COUNT(active) AS 'count of active employee'
FROM
	Employee
WHERE active = 1
GROUP BY
	department_id;


SELECT			-- Showing the age group of the employees
	CONCAT(first_name,' ',last_name) AS Employee,
	CASE
		WHEN age BETWEEN 18 AND 30 THEN 'Young'
		WHEN age BETWEEN 30 AND 60 THEN 'Adult'
		WHEN age > 60 THEN 'Senior'
		ELSE 'Age is bellow 18'
	END AS 'age group'
FROM Employee;



SELECT			-- Shows the average age and salary of active employee by every department
	department_name,
	AVG(age) AS 'average Age',
	AVG(salary) AS 'average Salary'
FROM
	Employee AS e
JOIN
	Department AS d
ON 
	e.department_id = d.department_id
WHERE
	active = 1
GROUP BY
	department_name
ORDER BY
	AVG(salary) DESC;



SELECT	TOP (3) -- Shows the top 3 active employee with the highest salary
	CONCAT(first_name,' ',last_name) AS 'employee',
	salary
FROM 
	Employee
WHERE
	active = 1
ORDER BY
	salary DESC;



SELECT			-- Joining employee table with department table to show the department name of the employees
	CONCAT(first_name,' ',last_name) AS 'employee',
	age,
	gender,
	salary,
	department_name
FROM
	Employee AS e
JOIN
	Department AS d
ON
	e.department_id = d.department_id;
	

SELECT			-- Joining employee table with department table and performance table to show the performance of the employees
	CONCAT(first_name,' ',last_name) AS 'employee',
	department_name,
	age,
	gender,
	salary,
	performance,
	CASE
		WHEN active = 1 THEN 'Active'
		WHEN active = 0 THEN 'Inactive'
		ELSE ''
	END AS 'employee status'
FROM
	Employee AS e
JOIN
	Department AS d
ON
	e.department_id = d.department_id
JOIN
	Performance AS p
ON
	e.performace_level = p.performance_level;



			
WITH AllEmployee AS(			-- Making this combined table as a temporary table to used as the fact table for joining other tables
SELECT							-- Combining employee table with new employee table using UNION
	*,
	CASE
		WHEN active = 1 THEN 'Active'
		WHEN active = 0 THEN 'Inactive'
		ELSE ''
	END AS employee_status
FROM
	Employee

UNION

SELECT
	*,
	CASE
		WHEN active = 1 THEN 'Actve'
		WHEN active = 0 THEN 'Inactive'
		ELSE ''
	END AS employee_status
FROM
	NewEmployee)

SELECT 
	employee_id,
	ae.department_id,
	first_name,
	last_name,
	department_name,
	age,
	gender,
	performance,
	salary,
	employee_status
FROM 
	AllEmployee AS ae
JOIN
	Department AS d
ON
	ae.department_id = d.department_id
JOIN
	Performance AS p
ON
	ae.performace_level = p.performance_level;


DELETE FROM Employee -- Deleting records of all inactive employees
WHERE active = 0;



SELECT * INTO AllEmployee -- Creating a new table combining the 'employee' table with 'new employee' table
FROM Employee
UNION
SELECT * 
FROM NewEmployee;


				/* Joining 'all employee' table with department table and performance table 
				to show the department name and performance of all employees*/
SELECT
	employee_id,
	ae.department_id,
	CONCAT(first_name,' ', last_name) AS full_name,
	department_name,
	age,
	CASE
		WHEN age BETWEEN 18 AND 30 THEN 'Young'
		WHEN age BETWEEN 30 AND 60 THEN 'Adult'
		WHEN age > 60 THEN 'Senior'
		ELSE 'Age is bellow 18'
	END AS 'age group',
	gender,
	performace_level,
	performance,
	salary,
	CASE 
		WHEN active = 1 THEN 'Active'
		ELSE 'Inactive'
	END AS Status	
FROM
	AllEmployee AS ae
JOIN
	Department AS d
ON 
	ae.department_id = d.department_id
JOIN
	Performance AS p
ON ae.performace_level = p.performance_level;
