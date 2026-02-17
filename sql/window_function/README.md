# Window Functions

This directory contains examples of SQL window functions.

## `window_function_example.sql`

This file demonstrates the usage of several window functions, including:

- `ROW_NUMBER()`: Assigns a unique, sequential integer to each row within its partition, based on the ordering of rows within the partition.
- `RANK()`: Assigns a rank to each row within its partition. Rows with the same values for the ranking criteria receive the same rank. The next rank after ties is not consecutive.
- `SUM()` as a window function: Calculates a cumulative sum of a column within its partition.

### Setup

The script first creates a `sales` table and inserts some sample data. This table is then used to demonstrate the window functions.

### Cleanup

The script includes a `DROP TABLE IF EXISTS sales;` statement at the end to clean up the created table.