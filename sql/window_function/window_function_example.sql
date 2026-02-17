-- SOURCE /workspace/sql/window_function/window_function_example.sql;

-- Create a sample table
CREATE TABLE IF NOT EXISTS sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    sale_date DATE,
    amount DECIMAL(10, 2)
);

-- Insert sample data
INSERT INTO sales (employee_id, sale_date, amount) VALUES
(1, '2023-01-01', 100.00),
(1, '2023-01-02', 150.00),
(1, '2023-01-03', 200.00),
(2, '2023-01-01', 120.00),
(2, '2023-01-02', 180.00),
(3, '2023-01-01', 90.00),
(3, '2023-01-02', 110.00);

-- no window function: Get total sales per employee
SELECT
    employee_id,
    SUM(amount) as total_sales
FROM
    sales
GROUP BY
    employee_id;

-- normal select: Get all sales with no ranking
SELECT
    id,
    employee_id,
    sale_date,
    amount
FROM
    sales;

-- Example of a window function: ROW_NUMBER() to rank sales per employee
SELECT
    id,
    employee_id,
    sale_date,
    amount,
    ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY amount DESC) as rn
FROM
    sales;

-- Example of a window function: RANK() to rank sales per employee
SELECT
    id,
    employee_id,
    sale_date,
    amount,
    RANK() OVER (PARTITION BY employee_id ORDER BY amount DESC) as rnk
FROM
    sales;

-- Example of a window function: SUM() as a window function (cumulative sum)
SELECT
    id,
    employee_id,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) as cumulative_sales
FROM
    sales;

-- Clean up: Drop the table
DROP TABLE IF EXISTS sales;
