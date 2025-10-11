-- SOURCE /workspace/sql/index/index_update_on_insert.sql;
-- This script demonstrates how index statistics, like Cardinality,
-- are updated when data is inserted into a table.

USE mydatabase;

-- 1. Setup the table with an index
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

-- 2. Show index status on the EMPTY table
-- The Cardinality for all indexes will be 0.
SELECT '-- Before INSERT --' as 'Step';
SHOW INDEX FROM users;

-- 3. Insert some data
-- We have 3 unique departments ('Sales', 'Engineering', 'HR')
-- and 4 unique ages (30, 35, 40, 42)
INSERT INTO users (name, email, age, department) VALUES
('Alice', 'alice@example.com', 30, 'Sales'),
('Bob', 'bob@example.com', 35, 'Engineering'),
('Charlie', 'charlie@example.com', 30, 'Sales'),
('David', 'david@example.com', 40, 'HR'),
('Eve', 'eve@example.com', 35, 'Engineering'),
('Frank', 'frank@example.com', 42, 'Engineering');

-- 4. Analyze the table to force an update of index statistics.
-- Without this, the Cardinality update might be delayed.
ANALYZE TABLE users;

-- 5. Show index status AFTER the insert
-- The Cardinality should now reflect the inserted data.
SELECT '-- After INSERT and ANALYZE --' as 'Step';
SHOW INDEX FROM users;
