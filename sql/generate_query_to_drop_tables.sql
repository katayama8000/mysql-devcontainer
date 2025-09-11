-- SOURCE /workspace/sql/generate_query_to_drop_tables.sql

SELECT CONCAT('DROP TABLE IF EXISTS ', table_name, ';')
FROM information_schema.tables
WHERE table_schema = 'mydatabase';