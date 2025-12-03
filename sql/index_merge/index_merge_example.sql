-- SOURCE /workspace/sql/index_merge/index_merge_example.sql;

-- データベースを選択
USE mydatabase;

-- テーブルが存在すれば削除
DROP TABLE IF EXISTS employees_merge_test;

-- テーブル作成
-- department_id と job_title にそれぞれ個別のインデックスを作成します
CREATE TABLE employees_merge_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    job_title VARCHAR(50),
    salary INT,
    INDEX idx_dept (department_id),
    INDEX idx_job (job_title)
);

-- データの挿入
-- Index Merge が選ばれやすくするために、ある程度のデータ量を入れます
INSERT INTO employees_merge_test (name, department_id, job_title, salary) VALUES
('Alice', 1, 'Engineer', 60000),
('Bob', 2, 'Manager', 80000),
('Charlie', 1, 'Designer', 55000),
('David', 3, 'Engineer', 62000),
('Eve', 2, 'Sales', 50000),
('Frank', 1, 'Manager', 85000),
('Grace', 3, 'Sales', 52000),
('Heidi', 2, 'Engineer', 61000),
('Ivan', 1, 'Sales', 51000),
('Judy', 3, 'Designer', 56000);

-- さらにデータを増やす（ダミーデータ）
-- 10000件程度のデータを生成して、Index Merge (Intersection) が選ばれやすくします
INSERT INTO employees_merge_test (name, department_id, job_title, salary)
SELECT CONCAT('User_', seq), (seq % 5) + 1, 
       CASE (seq % 3) 
           WHEN 0 THEN 'Engineer' 
           WHEN 1 THEN 'Manager' 
           ELSE 'Sales' 
       END, 
       50000 + (seq * 10)
FROM (
    SELECT t1.i * 1000 + t2.i * 100 + t3.i * 10 + t4.i as seq 
    FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
         (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
         (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
         (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4
) numbers
WHERE seq < 10000;

-- 統計情報を更新
ANALYZE TABLE employees_merge_test;


-- 1. Index Merge Union Access Algorithm の例
-- department_id = 1 または job_title = 'Manager' のいずれかに一致する行を検索
-- それぞれのインデックス (idx_dept, idx_job) を使用して結果を取得し、統合します。
-- EXPLAINの結果で type: index_merge, Extra: Using union(idx_dept,idx_job) となることを期待します
SELECT '--- Index Merge (Union) Example ---' AS description;
EXPLAIN SELECT * FROM employees_merge_test 
WHERE department_id = 1 OR job_title = 'Manager';

-- 実際にクエリを実行
SELECT * FROM employees_merge_test 
WHERE department_id = 1 OR job_title = 'Manager'
LIMIT 10;


-- 2. Index Merge Intersection Access Algorithm の例
-- Intersectionアルゴリズムを発生させるには、
-- 「それぞれの条件単独ではヒット数が多いが、組み合わせると非常に少ない」
-- というデータ分布が理想的です。

-- 専用のテーブルを作成
DROP TABLE IF EXISTS intersection_test;
CREATE TABLE intersection_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    col1 INT,
    col2 INT,
    padding VARCHAR(200), -- 行サイズを大きくしてテーブルアクセスを重くする
    INDEX idx_col1 (col1),
    INDEX idx_col2 (col2)
);

-- データ挿入: パターンA (col1=1, col2=1) - 10,000行
INSERT INTO intersection_test (col1, col2, padding)
SELECT 1, 1, RPAD('data', 200, 'x')
FROM (
    SELECT 1 FROM 
    (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
    (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
    (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
    (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4
) t LIMIT 10000;

-- データ挿入: パターンB (col1=2, col2=2) - 10,000行
INSERT INTO intersection_test (col1, col2, padding)
SELECT 2, 2, RPAD('data', 200, 'x')
FROM (
    SELECT 1 FROM 
    (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
    (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
    (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
    (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4
) t LIMIT 10000;

-- データ挿入: パターンC (col1=1, col2=2) - 10行 (これがターゲット)
INSERT INTO intersection_test (col1, col2, padding) VALUES
(1, 2, 'TARGET'), (1, 2, 'TARGET'), (1, 2, 'TARGET'), (1, 2, 'TARGET'), (1, 2, 'TARGET'),
(1, 2, 'TARGET'), (1, 2, 'TARGET'), (1, 2, 'TARGET'), (1, 2, 'TARGET'), (1, 2, 'TARGET');

-- 統計情報を更新
ANALYZE TABLE intersection_test;

-- Intersection の確認
-- col1=1 (約10,010行) AND col2=2 (約10,010行) -> 交差は10行
-- 単一インデックスだと1万回のテーブルアクセスが必要だが、Index Mergeならインデックススキャンだけで絞り込める
SELECT '--- Index Merge (Intersection) Example with Skewed Data ---' AS description;
EXPLAIN SELECT * FROM intersection_test 
WHERE col1 = 1 AND col2 = 2;

SELECT * FROM intersection_test 
WHERE col1 = 1 AND col2 = 2;
