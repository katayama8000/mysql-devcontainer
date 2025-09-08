-- Database initialization SQL file
-- Executed automatically when devContainer starts

-- Create database only if it doesn't exist
CREATE DATABASE IF NOT EXISTS mydatabase CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use mydatabase
USE mydatabase;

-- Example of initial table creation (customize as needed)
-- CREATE TABLE IF NOT EXISTS users (
--     id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(255) NOT NULL,
--     email VARCHAR(255) UNIQUE NOT NULL,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- Example of initial data insertion (customize as needed)
-- INSERT INTO users (name, email) VALUES 
-- ('Test User 1', 'test1@example.com'),
-- ('Test User 2', 'test2@example.com')
-- ON DUPLICATE KEY UPDATE name=VALUES(name);
