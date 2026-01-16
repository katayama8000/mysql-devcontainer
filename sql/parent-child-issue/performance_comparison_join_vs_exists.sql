-- SOURCE /workspace/sql/parent-child-issue/performance_comparison_join_vs_exists.sql;

-- 3階層目にある課題だけを取得するクエリのパフォーマンスを比較します。
-- JOINを使用した場合とEXISTSを使用した場合の2つのアプローチを試します。

-- アプローチ1: JOIN を使用して3階層目の課題を取得
-- t3が第1階層（親）、t2が第2階層（子）、t1が第3階層（孫）に対応します。
-- t3.parent_id IS NULL 条件で、t3が最上位の課題であることを保証します。
EXPLAIN ANALYZE
SELECT
    t1.id AS grandchild_id,
    t1.title AS grandchild_title,
    t2.id AS child_id,
    t2.title AS child_title,
    t3.id AS parent_id,
    t3.title AS parent_title
FROM
    issues t1
JOIN
    issues t2 ON t1.parent_id = t2.id
JOIN
    issues t3 ON t2.parent_id = t3.id
WHERE
    t3.parent_id IS NULL;

-- アプローチ2: EXISTS を使用して3階層目の課題を取得
-- EXISTS句をネストして、親（t2）とさらにその親（t3）が存在し、
-- かつ最上位の親（t3）のparent_idがNULLであることを確認します。
EXPLAIN ANALYZE
SELECT
    t1.*
FROM
    issues t1
WHERE
    EXISTS (
        SELECT 1
        FROM issues t2
        WHERE t1.parent_id = t2.id
          AND EXISTS (
            SELECT 1
            FROM issues t3
            WHERE t2.parent_id = t3.id
              AND t3.parent_id IS NULL
        )
    );
