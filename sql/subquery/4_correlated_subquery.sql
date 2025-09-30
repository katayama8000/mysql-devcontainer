-- Use the created database
USE subquery_test;

-- ---
-- Correlated Subquery Example
-- ---
-- A correlated subquery is an inner query that depends on the outer query for its values.
-- It is evaluated repeatedly, once for each row that is processed by the outer query.

-- Goal: Find all employees who earn the highest salary in their respective department.

SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    department_id
FROM
    employees e1
WHERE
    salary = (
        SELECT MAX(salary)
        FROM employees e2
        WHERE e2.department_id = e1.department_id -- The correlation
    );

-- For each row in the outer query (aliased as `e1`), the subquery is executed.
-- The subquery finds the maximum salary for the *current* department (`e1.department_id`).
-- The outer query then compares the employee's salary (`e1.salary`) with this maximum salary.
-- If they are equal, the employee is included in the result.

-- This can be less efficient than other methods (like using window functions in modern SQL),
-- but it's a classic example of a correlated subquery.
