-- SOURCE /workspace/sql/parent-child-issue/issue_table_setup.sql;

-- This script ensures the 'issues' table is created and populated with a large, hierarchical dataset.
-- It is idempotent: running it multiple times will result in the same final state.

-- 1. Drop the table if it exists to ensure a clean slate.
DROP TABLE IF EXISTS issues;

-- 2. Recreate the 'issues' table.
CREATE TABLE issues (
    id INT PRIMARY KEY AUTO_INCREMENT,
    parent_id INT NULL,
    title VARCHAR(255) NOT NULL,
    status ENUM('未着手', '進行中', '完了') NOT NULL DEFAULT '未着手',
    INDEX parent_id_idx (parent_id),
    FOREIGN KEY (parent_id) REFERENCES issues(id) ON DELETE CASCADE
);

-- 3. Define a stored procedure to generate a large volume of test data.
DROP PROCEDURE IF EXISTS GenerateLargeIssueData;
DELIMITER //
CREATE PROCEDURE GenerateLargeIssueData()
BEGIN
    -- Config: 100 (L1) + 100*10 (L2) + 100*10*9 (L3) = 10,100 total records.
    DECLARE v_level1_count INT DEFAULT 100;
    DECLARE v_level2_per_level1 INT DEFAULT 10;
    DECLARE v_level3_per_level2 INT DEFAULT 9;

    DECLARE i, j, k INT;
    DECLARE level1_id, level2_id INT;

    -- Disable FK checks for performance, as we just created the table.
    SET FOREIGN_KEY_CHECKS=0;
    
    SET i = 1;
    WHILE i <= v_level1_count DO
        INSERT INTO issues (parent_id, title) VALUES (NULL, CONCAT('Project-', i));
        SET level1_id = LAST_INSERT_ID();
        SET j = 1;

        WHILE j <= v_level2_per_level1 DO
            INSERT INTO issues (parent_id, title) VALUES (level1_id, CONCAT('Task-', i, '-', j));
            SET level2_id = LAST_INSERT_ID();
            SET k = 1;

            WHILE k <= v_level3_per_level2 DO
                INSERT INTO issues (parent_id, title) VALUES (level2_id, CONCAT('Subtask-', i, '-', j, '-', k));
                SET k = k + 1;
            END WHILE;
            SET j = j + 1;
        END WHILE;
        SET i = i + 1;
    END WHILE;

    SET FOREIGN_KEY_CHECKS=1;
    SELECT CONCAT('Successfully inserted ', v_level1_count + v_level1_count*v_level2_per_level1 + v_level1_count*v_level2_per_level1*v_level3_per_level2, ' hierarchical issues.') AS status;
END //
DELIMITER ;

-- 4. Execute the procedure to populate the table.
CALL GenerateLargeIssueData();