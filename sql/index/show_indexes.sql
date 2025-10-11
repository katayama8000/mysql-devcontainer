-- SOURCE /workspace/sql/index/show_indexes.sql;

USE mydatabase;

-- Drop the table if it exists and recreate it
-- to ensure we are working with a known state.
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT,
    department VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add a composite index for demonstration
CREATE INDEX idx_department_age ON users (department, age);

-- Show the indexes on the users table
SHOW INDEX FROM users;
