-- SOURCE /workspace/sql/with/users_avg_age.sql

WITH department_average_age AS (
  -- 部署ごとの平均年齢を計算
  SELECT
    department,
    AVG(age) AS avg_age
  FROM
    users
  GROUP BY
    department
)
SELECT
  u.name,
  u.age,
  u.department,
  d.avg_age AS department_average_age
FROM
  users AS u
JOIN
  department_average_age AS d ON u.department = d.department
WHERE
  u.age > d.avg_age;