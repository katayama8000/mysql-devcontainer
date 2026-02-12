-- SOURCE /workspace/sql/offset_example/filesort_example.sql;

USE offset_test;

-- issues テーブルが存在すれば削除
DROP TABLE IF EXISTS issues;

-- issues テーブルの再作成 (titleにインデックスは無い状態)
CREATE TABLE issues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT,
    title VARCHAR(255),
    INDEX (parent_id) -- parent_idにのみインデックスを設定
);

-- テストデータの挿入 (200件)
INSERT INTO issues (parent_id, title)
WITH RECURSIVE NumberSequence (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM NumberSequence WHERE n < 200
)
SELECT 123, CONCAT('issue ', n) FROM NumberSequence;

-- 'title' カラムでソートする場合の実行計画を確認
-- 'title' にはインデックスがないため、filesortが発生する
EXPLAIN SELECT * FROM issues WHERE parent_id = 123 ORDER BY title LIMIT 20 OFFSET 100;
