-- SOURCE /workspace/sql/index/index_update_on_update.sql;
-- This script demonstrates how index statistics, like Cardinality,
-- are updated when data in an indexed column is updated.

USE mydatabase;

-- 1. Setup the table with data and analyze it
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT,
    department VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_department_age ON users (department, age);

INSERT INTO users (name, email, age, department) VALUES
('Alice', 'alice@example.com', 30, 'Sales'),
('Bob', 'bob@example.com', 35, 'Engineering'),
('Charlie', 'charlie@example.com', 30, 'Sales'),
('David', 'david@example.com', 40, 'HR'),
('Eve', 'eve@example.com', 35, 'Engineering'),
('Frank', 'frank@example.com', 42, 'Engineering');

ANALYZE TABLE users;

-- 2. Show index status on the table BEFORE the update
SELECT '-- Before UPDATE --' as 'Step';
SHOW INDEX FROM users;

-- 3. Update a row, changing indexed columns to be a duplicate of another row.
-- We change Frank's data to match Alice/Charlie.
-- This should decrease the cardinality of the composite index.
UPDATE users SET department = 'Sales', age = 30 WHERE email = 'frank@example.com';

-- 4. Analyze the table to force an update of index statistics.
ANALYZE TABLE users;

-- 5. Show index status AFTER the update
-- The Cardinality of the composite index should have changed.
SELECT '-- After UPDATE and ANALYZE --' as 'Step';
SHOW INDEX FROM users;
