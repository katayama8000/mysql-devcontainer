-- SOURCE /workspace/sql/metadata_lock2/issue_project_setup.sql;

-- Clean up
DROP TABLE IF EXISTS issue;
DROP TABLE IF EXISTS project;

-- Create project table
CREATE TABLE IF NOT EXISTS project (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create issue table
CREATE TABLE IF NOT EXISTS issue (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    project_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES project(id)
);

-- Insert sample data
INSERT INTO project (name) VALUES ('Project A'), ('Project B');
INSERT INTO issue (title, project_id) VALUES ('Issue 1 for Project A', 1), ('Issue 2 for Project A', 1), ('Issue 1 for Project B', 2);
