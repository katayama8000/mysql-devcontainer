-- SOURCE /workspace/sql/offset_example/covering_index_offset.sql;

USE offset_test;

-- issues テーブルが存在すれば削除
DROP TABLE IF EXISTS issues;

-- issues テーブルの再作成
CREATE TABLE issues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT,
    title VARCHAR(255)
);

-- (parent_id, id) に複合インデックスを追加
CREATE INDEX idx_parent_id_id ON issues (parent_id, id);

-- テストデータの挿入 (200件)
INSERT INTO issues (parent_id, title)
WITH RECURSIVE NumberSequence (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM NumberSequence WHERE n < 200
)
SELECT 123, CONCAT('issue ', n) FROM NumberSequence;

-- OFFSET を使ったクエリの実行計画を確認（複合インデックスあり）
EXPLAIN SELECT id FROM issues WHERE parent_id = 123 ORDER BY id LIMIT 20 OFFSET 100;

