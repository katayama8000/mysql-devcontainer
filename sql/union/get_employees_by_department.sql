SELECT
    '経理部' AS department,
    employee_name
FROM
    employees
WHERE
    department = '経理'

UNION ALL

SELECT
    '営業部' AS department,
    employee_name
FROM
    employees
WHERE
    department = '営業';