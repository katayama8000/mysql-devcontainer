# Subquery Examples

This directory contains several examples of SQL subqueries.

## What is a Subquery?

A subquery, also known as an inner query or nested query, is a query nested inside another SQL query. Subqueries can be used in various clauses like `SELECT`, `FROM`, `WHERE`, and `HAVING`.

## Setup

Before running the examples, you need to create the sample tables and data. Connect to your MySQL instance and run the `setup.sql` script:

```sql
SOURCE /workspace/sql/subquery/setup.sql
```

This will create a `subquery_test` database with `employees` and `departments` tables and populate them with data.

## Examples

The examples are numbered for clarity. You can run them in any order after running the setup script.

### 1. Scalar Subquery (`1_scalar_subquery.sql`)

This query finds all employees who earn more than the average salary. It uses a subquery in the `WHERE` clause that returns a single value (the average salary).

**Run it:**
```sql
SOURCE /workspace/sql/subquery/1_scalar_subquery.sql
```

### 2. Subquery with `IN` (`2_in_subquery.sql`)

This query finds all employees who work in departments located in 'Tokyo'. It uses a subquery in the `WHERE` clause that returns a list of department IDs.

**Run it:**
```sql
SOURCE /workspace/sql/subquery/2_in_subquery.sql
```

### 3. Subquery in `FROM` Clause (`3_from_subquery.sql`)

This query calculates the average salary for each department. It uses a subquery in the `FROM` clause to create a temporary table (a "derived table") containing the average salaries, which is then joined with the `departments` table.

**Run it:**
```sql
SOURCE /workspace/sql/subquery/3_from_subquery.sql
```

### 4. Correlated Subquery (`4_correlated_subquery.sql`)

This query finds all employees who have the highest salary in their respective departments. It uses a correlated subquery, where the inner query depends on the outer query. For each employee, the subquery calculates the max salary for that employee's department.

**Run it:**
```sql
SOURCE /workspace/sql/subquery/4_correlated_subquery.sql
```

## Cleanup

After you are done, you can drop the test database with the following command:

```sql
DROP DATABASE subquery_test;
```
