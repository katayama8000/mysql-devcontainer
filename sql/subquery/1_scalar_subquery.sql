-- Use the created database
USE subquery_test;

-- ---
-- Scalar Subquery Example
-- ---
-- A scalar subquery returns a single value (one row with one column).
-- It can be used wherever a single value is expected.

-- Goal: Find all employees who earn more than the average salary of all employees.

SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    salary > (SELECT AVG(salary) FROM employees);

-- The subquery `(SELECT AVG(salary) FROM employees)` is executed first
-- and returns a single value (the average salary). The outer query then
-- uses this value to filter the employees.
