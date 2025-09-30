-- SOURCE /workspace/sql/buffer_pool/buffer_pool_example.sql

-- Create a database for this test
CREATE DATABASE IF NOT EXISTS buffer_pool_test;
USE buffer_pool_test;

-- Drop the table if it exists
DROP TABLE IF EXISTS users;

-- Create a simple table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a large number of records
-- This might take a moment
INSERT INTO users (name, email)
SELECT
    CONCAT('user', n),
    CONCAT('user', n, '@example.com')
FROM
    (
        SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + e.N * 10000 as n
        FROM
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c,
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d,
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) e
        ORDER BY n
    ) AS numbers
WHERE n < 100000; -- Insert 100,000 records

-- 1. First Query Execution
-- =========================
-- Flush status to reset counters
FLUSH STATUS;

SELECT 'First query execution. Data is read from disk.';

-- Explain and run the query.
-- The first time, data has to be read from disk into the buffer pool.
SELECT * FROM users WHERE id BETWEEN 50000 AND 50010;

-- Show the status variables.
-- Innodb_buffer_pool_reads: The number of reads from disk.
-- Innodb_buffer_pool_read_requests: The number of logical read requests.
SHOW STATUS LIKE 'Innodb_buffer_pool_read%';

-- 2. Second Query Execution
-- ==========================
SELECT 'Second query execution. Data should be in the buffer pool.';

-- Run the same query again.
-- This time, the data should be in the buffer pool.
SELECT * FROM users WHERE id BETWEEN 50000 AND 50010;

-- Show the status variables again.
-- Innodb_buffer_pool_reads should not have increased significantly,
-- because the data was read from memory (buffer pool).
SHOW STATUS LIKE 'Innodb_buffer_pool_read%';

-- Clean up the database
DROP DATABASE buffer_pool_test;
