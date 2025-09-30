-- Use the created database
USE subquery_test;

-- ---
-- Subquery in FROM clause (Derived Table)
-- ---
-- A subquery in the FROM clause creates a temporary table (a "derived table")
-- that the outer query can then select from, join, or filter.

-- Goal: For each department, show the department name and its average salary.

-- First, we create a temporary table that calculates the average salary for each department_id.
-- Then, we join this temporary table with the departments table to get the department names.

SELECT
    d.department_name,
    dept_avg.avg_salary
FROM
    departments d
JOIN
    (
        SELECT
            department_id,
            AVG(salary) AS avg_salary
        FROM
            employees
        GROUP BY
            department_id
    ) AS dept_avg ON d.department_id = dept_avg.department_id;

-- The subquery `(SELECT ... GROUP BY ...)` is executed first, creating a result set
-- with department_id and the average salary for each.
-- This result set is given the alias `dept_avg`.
-- The outer query then joins the `departments` table with `dept_avg` to produce the final result.
