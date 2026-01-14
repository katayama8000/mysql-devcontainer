-- SOURCE /workspace/sql/metadata_lock2/view_metadata_locks.sql;

-- This query provides detailed information about all active metadata locks.
-- It is a powerful tool for diagnosing lock contention issues.
-- Note: The performance_schema must be enabled on the server.

SELECT * FROM performance_schema.metadata_locks; 
