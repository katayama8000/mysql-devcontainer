-- SOURCE /workspace/sql/metadata_lock2/long_query_on_issue.sql;

-- This query will be used in session 1 to simulate a long-running query on the issue table.
SELECT *, SLEEP(15) FROM issue;
