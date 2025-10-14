-- SOURCE /workspace/sql/index_condition_pushdown/sample.sql;

-- Drop the table if it exists to ensure a clean state
DROP TABLE IF EXISTS users;

-- Create a table to demonstrate Index Condition Pushdown
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  age INT
);

-- Create a composite index on (last_name, first_name)
CREATE INDEX idx_lastname_firstname ON users (last_name, first_name);

-- Insert some data
INSERT INTO users (first_name, last_name, age) VALUES
('John', 'Doe', 30),
('Jane', 'Doe', 25),
('Peter', 'Jones', 40),
('Susan', 'Jones', 35),
('John', 'Smith', 28);

-- This query can use Index Condition Pushdown.
-- The `last_name = 'Doe'` part can be used by the index to narrow down the search.
-- The `first_name LIKE '%J%'` part can be pushed down to the storage engine.
-- The storage engine can then filter the rows with `last_name = 'Doe'` by checking if `first_name` starts with 'J'.
-- This avoids reading the full table rows for all 'Doe's.
EXPLAIN SELECT * FROM users WHERE last_name = 'Doe' AND first_name LIKE '%J%';

-- Use EXPLAIN ANALYZE to see the execution plan and actual costs.
-- This provides more detail, including the actual time spent.
EXPLAIN ANALYZE SELECT * FROM users WHERE last_name = 'Doe' AND first_name LIKE '%J%';

-- Without ICP, MySQL would have to retrieve all rows where `last_name = 'Doe'`
-- and then filter them by `first_name LIKE '%J%'` in the server layer.

-- To see the difference, you can disable ICP for the session:
-- SET optimizer_switch = 'index_condition_pushdown=off';
-- EXPLAIN SELECT * FROM users WHERE last_name = 'Doe' AND first_name LIKE '%J%';
-- SET optimizer_switch = 'index_condition_pushdown=on';

-- Clean up the table
DROP TABLE users;
