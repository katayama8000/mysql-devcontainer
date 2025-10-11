-- SOURCE /workspace/sql/index/triple_composite_index_example.sql;

USE mydatabase;

-- Drop the table if it exists and recreate it with a new 'status' column.
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT,
    department VARCHAR(100),
    status VARCHAR(20) DEFAULT 'active', -- Added for the example
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a composite index on three columns
CREATE INDEX idx_dept_status_created ON users (department, status, created_at);

-- Show the indexes on the users table
SHOW INDEX FROM users;
