WITH RECURSIVE task_tree AS (
    -- 1. 検索の起点（親タスク）を指定
    SELECT
        id,
        parent_id,
        title,
        status
    FROM
        tasks
    WHERE
        id = 1 -- ここに親タスクのIDを指定

    UNION ALL

    -- 2. 子孫タスクを再帰的に検索
    SELECT
        t.id,
        t.parent_id,
        t.title,
        t.status
    FROM
        tasks AS t
    JOIN
        task_tree AS tt ON t.parent_id = tt.id
)
SELECT
    id,
    parent_id,
    title,
    status
FROM
    task_tree;