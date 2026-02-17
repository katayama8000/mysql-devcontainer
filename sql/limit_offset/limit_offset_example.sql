-- SOURCE /workspace/sql/limit_offset/limit_offset_example.sql;

-- Drop table if it exists to ensure idempotency for setup
DROP TABLE IF EXISTS users;

-- Create the users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

-- Insert sample data
INSERT INTO users (name, age) VALUES ('Alice', 30);
INSERT INTO users (name, age) VALUES ('Bob', 24);
INSERT INTO users (name, age) VALUES ('Charlie', 35);
INSERT INTO users (name, age) VALUES ('David', 28);
INSERT INTO users (name, age) VALUES ('Eve', 22);
INSERT INTO users (name, age) VALUES ('Frank', 40);
INSERT INTO users (name, age) VALUES ('Grace', 29);
INSERT INTO users (name, age) VALUES ('Heidi', 31);
INSERT INTO users (name, age) VALUES ('Ivan', 26);
INSERT INTO users (name, age) VALUES ('Judy', 33);

-- Example 1: Select the first 5 users
SELECT id, name, age
FROM users
ORDER BY id
LIMIT 5;

-- Example 2: Select the next 3 users after the first 5 (i.e., users 6-8)
SELECT id, name, age
FROM users
ORDER BY id
LIMIT 3 OFFSET 5;

-- Example 3: Select all users from the 3rd user onwards
SELECT id, name, age
FROM users
ORDER BY id
OFFSET 2;
