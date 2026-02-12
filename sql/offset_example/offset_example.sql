-- SOURCE /workspace/sql/offset_example/offset_example.sql;

-- データベースが存在しない場合に作成
CREATE DATABASE IF NOT EXISTS offset_test;
USE offset_test;

-- issues テーブルが存在すれば削除
DROP TABLE IF EXISTS issues;

-- issues テーブルの作成 (存在しない場合のみ)
CREATE TABLE IF NOT EXISTS issues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT,
    title VARCHAR(255),
    INDEX (parent_id)
);

-- テーブルを空にする
TRUNCATE TABLE issues;

-- テストデータの挿入 (200件)
-- ループ処理の代わりに再帰CTEを使用
INSERT INTO issues (parent_id, title)
WITH RECURSIVE NumberSequence (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM NumberSequence WHERE n < 200
)
SELECT 123, CONCAT('issue ', n) FROM NumberSequence;

-- OFFSET を使ったクエリの実行計画を確認
EXPLAIN SELECT * FROM issues WHERE parent_id = 123 ORDER BY id LIMIT 20 OFFSET 100;
