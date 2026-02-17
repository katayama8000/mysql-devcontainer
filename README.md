## run devContainer

```bash
command + shift + p
Rebuild Container
```

## connect to mysql

```bash
mysql -h mysql -u root -p
password: password
```

or

```bash
mysql -h mysql -u root -p'password'
```

## play with mysql

```sql
show databases;
use mydatabase;
show tables;
```

## Recursive Query Test

This section explains how to run the recursive query test and what the query does.

### How to run the test

1.  Open a terminal and enter the `app` container:

    ```bash
    docker-compose exec app bash
    ```

2.  Inside the container, run the following command to execute the SQL script:

    ```bash
    mysql -h mysql -u root -ppassword -D mydatabase -vvv < sql/recursive_query/validate_query.sql
    ```

    The `-vvv` flag provides verbose output, so you can see each step of the execution.

### What the SQL query does

The SQL query in `sql/recursive_query/validate_query.sql` is designed to find all descendant issues of a given parent issue that are in an "uncompleted" state.

Here's a breakdown of the query:

-   **`WITH RECURSIVE all_descendants(...) AS (...)`**: This defines a Common Table Expression (CTE) named `all_descendants` that can refer to itself. This is what makes the query recursive.

-   **`SELECT id, parent_issue_id, status_id, id as root_child_id FROM issue WHERE parent_issue_id = 1`**: This is the starting point of the recursion. It selects all direct children of the issue with `id = 1`. The `root_child_id` is set to the `id` of the direct child.

-   **`UNION ALL`**: This combines the results of the starting query with the results of the recursive part of the query.

-   **`SELECT i.id, i.parent_issue_id, i.status_id, d.root_child_id FROM issue i JOIN all_descendants d ON i.parent_issue_id = d.id`**: This is the recursive part. It finds all children of the issues that were found in the previous step, and it keeps the `root_child_id` from the previous step.

-   **`SELECT DISTINCT root_child_id FROM all_descendants WHERE status_id IN (1, 2)`**: This is the final query. It selects the unique `root_child_id`s of all the descendant issues that have a `status_id` of `1` or `2` (which we are considering as "uncompleted").

In simple terms, the query starts with a parent issue, finds all its children, then finds all of their children, and so on. Then it filters out only the "uncompleted" ones and tells you which of the direct children of the original parent have uncompleted tasks down the line.
