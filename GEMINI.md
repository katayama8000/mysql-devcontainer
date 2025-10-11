## environment

- This is a playground for experimenting with SQL queries and database concepts.
- Tech Stack
  - MySQL
  - Docker
    - devContainer

## Rules

- When writing SQL queries, ensure they are idempotent (can be run multiple times without changing the result beyond the initial application). Use patterns like `CREATE TABLE IF NOT EXISTS` or `DROP TABLE IF EXISTS` where appropriate.
- SQL files should start with a comment indicating their source path, e.g., `-- SOURCE /workspace/sql/your_file.sql;`
