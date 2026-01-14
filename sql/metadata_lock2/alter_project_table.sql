-- SOURCE /workspace/sql/metadata_lock2/alter_project_table.sql;

-- This query will be used in session 2 to alter the project table.
ALTER TABLE project ADD COLUMN new_column5 VARCHAR(255);
