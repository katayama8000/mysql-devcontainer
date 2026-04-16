USE mydatabase;

-- Drop tables if they exist (idempotent)
DROP TABLE IF EXISTS issue_comments;
DROP TABLE IF EXISTS issues;

-- Create issues table
CREATE TABLE issues (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    project_id  INT NOT NULL,
    assignee_id INT,
    status      ENUM('open', 'in_progress', 'closed') NOT NULL DEFAULT 'open',
    priority    ENUM('low', 'medium', 'high') NOT NULL DEFAULT 'medium',
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Index candidates (commented out by default — add/remove to test HAVING behavior)
CREATE INDEX idx_project_id   ON issues (project_id);
CREATE INDEX idx_assignee_id  ON issues (assignee_id);
CREATE INDEX idx_status       ON issues (status);
CREATE INDEX idx_project_status ON issues (project_id, status);

-- Insert sample data
INSERT INTO issues (project_id, assignee_id, status, priority, created_at) VALUES
(1, 1, 'open',        'high',   '2024-01-01 09:00:00'),
(1, 1, 'open',        'medium', '2024-01-02 10:00:00'),
(1, 2, 'in_progress', 'high',   '2024-01-03 11:00:00'),
(1, 2, 'closed',      'low',    '2024-01-04 12:00:00'),
(1, 3, 'closed',      'medium', '2024-01-05 13:00:00'),
(2, 1, 'open',        'low',    '2024-02-01 09:00:00'),
(2, 2, 'open',        'high',   '2024-02-02 10:00:00'),
(2, 2, 'in_progress', 'medium', '2024-02-03 11:00:00'),
(2, 3, 'closed',      'high',   '2024-02-04 12:00:00'),
(2, 3, 'closed',      'medium', '2024-02-05 13:00:00'),
(3, 1, 'open',        'medium', '2024-03-01 09:00:00'),
(3, 2, 'in_progress', 'low',    '2024-03-02 10:00:00'),
(3, 3, 'closed',      'high',   '2024-03-03 11:00:00'),
(3, 3, 'closed',      'medium', '2024-03-04 12:00:00'),
(3, 4, 'open',        'low',    '2024-03-05 13:00:00');

SELECT 'setup done' AS message;
