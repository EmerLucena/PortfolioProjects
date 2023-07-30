CREATE DATABASE Employeefriends; -- Creates a database

USE Employeefriends; -- Using the created database

DROP TABLE IF EXISTS Employee -- Deleting table if already exists
CREATE TABLE Employee (			-- Creating a table and its columns
	employee_id INT NOT NULL,
	department_id INT NOT NULL,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	age TINYINT,
	gender VARCHAR(50),
	performance_level TINYINT,
	salary INT,
	active BIT DEFAULT 1,
	PRIMARY KEY (employee_id) 
);

INSERT INTO Employee VALUES		-- Inserting records to the table
	(1, 2,'Jordan', 'Espiritu', 24, 'Male', 4, 18000, 0),
	(2, 1,'Aldwin', 'Grafe', 25, 'Male', 4, 19500, 1),
	(3, 1,'Adonis', 'Ladiza', 23, 'Male', 3, 17900, 1),
	(4, 3,'Russel', 'Zamora', 23, NULL, 2, 16000, 0),
	(5, 4,'Avan', 'Pulido', 24, 'Male', 4, 20500, 1),
	(6, 1,'Margarette', 'Dominguez', 23, 'Female', 5, 19000, 1),
	(7, 4,'Lalaine', 'Guilaran', 22, 'Female', 3, 19900, 1),
	(8, 2,'Paul', 'Mata', 23, 'Male', 3, 17800, 1),
	(9, 3,'Jomarie', 'Castro', 24, 'Male', 5, NULL, 1),
	(10,2,'Remy', 'Loresto', 39, 'Female', 4, 18900, 1),
	(11,3,'Edward', 'Sixto', 41, 'Male', 3, 15800, 0),
	(12,4,'Danlee', 'Samontee', 20,NULL,3,20000,1),
	(13,3,'Jobert','Gawk',32,'Male',1, 16500,1),
	(14,1,'Kyle','Javellana', 28,'Male', 3, 19300, 1);

CREATE TABLE Department (
	department_id INT NOT NULL,
	department_name VARCHAR(50)
	PRIMARY KEY (department_id)
);

INSERT INTO Department VALUES
	(1,'Sales'), (2,'HR'), (3,'Production'), (4,'Technology');

CREATE TABLE Performance (
	performance_level TINYINT,
	performance VARCHAR(50)
	PRIMARY KEY (performance_level)
);

INSERT INTO Performance VALUES
	(1,'Improvement Required'),
	(2,'Development Required'),
	(3,'Meet Expectaions'),
	(4,'Exceeds Expectaions'),
	(5,'Far Exceeds')
    
CREATE TABLE NewEmployee (
	employee_id INT NOT NULL, 
	department_id INT NOT NULL, 
	first_name VARCHAR(50), 
	last_name VARCHAR(50), 
	age TINYINT, 
	gender VARCHAR(50), 
	performance_level TINYINT, 
	salary INT,
	active BIT DEFAULT 1,
	PRIMARY KEY (employee_id)
	);
    
INSERT INTO NewEmployee VALUES
(16,1,'Jeson','Prodigalidad', 22, 'Male', 3, 17700, 1),
(17,2,'Gian Francis', 'Bautista', 24, 'Male', 3, 18400,1),
(18,4,'Kristine','Leuterio', 26, 'Female', 3, 19000,1),
(19,3,'Chezcka','Ortiz', 24, 'Female', 3, 17300,1);