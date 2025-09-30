-- Create a database for this test
CREATE DATABASE IF NOT EXISTS subquery_test;
USE subquery_test;

-- Drop tables if they exist to ensure a clean slate
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

-- Create employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    salary INT NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert data into departments
INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'Sales', 'Tokyo'),
(2, 'Engineering', 'Osaka'),
(3, 'HR', 'Tokyo'),
(4, 'Marketing', 'Fukuoka');

-- Insert data into employees
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES
(1, 'Taro', 'Yamada', 60000, 1),
(2, 'Hanako', 'Suzuki', 75000, 2),
(3, 'Jiro', 'Sato', 80000, 2),
(4, 'Saburo', 'Takahashi', 58000, 1),
(5, 'Shiro', 'Ito', 90000, 2),
(6, 'Yuki', 'Watanabe', 62000, 3),
(7, 'Kenji', 'Tanaka', 72000, 2),
(8, 'Emi', 'Nakamura', 55000, 4),
(9, 'Ichiro', 'Kobayashi', 65000, 1);

SELECT 'Sample tables created and populated successfully.' AS message;
