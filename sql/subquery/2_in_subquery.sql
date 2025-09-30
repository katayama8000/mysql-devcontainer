-- Use the created database
USE subquery_test;

-- ---
-- Multi-row Subquery with IN operator
-- ---
-- This type of subquery returns a list of values (multiple rows, one column).
-- It's commonly used with operators like IN, NOT IN, ANY, or ALL.

-- Goal: Find all employees who work in departments located in 'Tokyo'.

-- First, we need to find the department_ids for departments in 'Tokyo'.
-- Then, we find the employees belonging to those departments.

SELECT
    employee_id,
    first_name,
    last_name,
    department_id
FROM
    employees
WHERE
    department_id IN (SELECT department_id FROM departments WHERE location = 'Tokyo');

-- The subquery `(SELECT department_id FROM departments WHERE location = 'Tokyo')`
-- returns a list of department IDs (1 and 3). The outer query then selects
-- all employees whose department_id is in this list.

-- This is often an alternative to using a JOIN:
/*
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id
FROM
    employees e
JOIN
    departments d ON e.department_id = d.department_id
WHERE
    d.location = 'Tokyo';
*/
