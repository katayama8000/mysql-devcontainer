-- 基本的な共通テーブル式（CTE: Common Table Expression）のサンプル

-- テーブル作成とデータ挿入（べき等性を保証）
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  age INT NOT NULL,
  email VARCHAR(100),
  department VARCHAR(50),
  manager_id INT,
  FOREIGN KEY (manager_id) REFERENCES users(id) ON DELETE SET NULL
);

-- サンプルデータを挿入
INSERT INTO users (id, name, age, email, department, manager_id) VALUES
(1, '田中太郎', 45, 'tanaka@example.com', '営業部', NULL),
(2, '佐藤花子', 38, 'sato@example.com', '開発部', NULL),
(3, '鈴木一郎', 52, 'suzuki@example.com', '総務部', NULL),
(4, '高橋美咲', 28, 'takahashi@example.com', '営業部', 1),
(5, '伊藤健太', 35, 'ito@example.com', '開発部', 2),
(6, '渡辺愛', 42, 'watanabe@example.com', '開発部', 2),
(7, '山本直樹', 31, 'yamamoto@example.com', '営業部', 1),
(8, '中村舞', 26, 'nakamura@example.com', '総務部', 3),
(9, '小林拓也', 29, 'kobayashi@example.com', '開発部', 2),
(10, '加藤さくら', 33, 'kato@example.com', '営業部', 1),
(11, '吉田大輔', 40, 'yoshida@example.com', '開発部', 6),
(12, '山田百合子', 24, 'yamada@example.com', '総務部', 3);

-- 1. シンプルなCTEの例
-- 年齢が30歳以上のユーザーを抽出し、それを使って別のクエリを実行
WITH adult_users AS (
  SELECT
    id,
    name,
    age,
    email
  FROM
    users
  WHERE
    age >= 30
)
SELECT
  name,
  age,
  email
FROM
  adult_users
ORDER BY
  age DESC;

-- 2. 複数のCTEを使用する例
-- 部署ごとの平均年齢と最高年齢を計算
WITH department_stats AS (
  SELECT
    department,
    AVG(age) AS avg_age,
    MAX(age) AS max_age,
    COUNT(*) AS employee_count
  FROM
    users
  GROUP BY
    department
),
high_performers AS (
  SELECT
    id,
    name,
    department,
    age
  FROM
    users
  WHERE
    age > (SELECT AVG(age) FROM users)
)
SELECT
  hp.name,
  hp.department,
  hp.age,
  ds.avg_age AS dept_avg_age,
  ds.max_age AS dept_max_age,
  ds.employee_count
FROM
  high_performers AS hp
JOIN
  department_stats AS ds ON hp.department = ds.department
ORDER BY
  hp.department, hp.age DESC;

-- 3. 再帰CTEの例
-- 1から10までの数字を生成
WITH RECURSIVE numbers AS (
  -- ベースケース: 初期値
  SELECT 1 AS n
  
  UNION ALL
  
  -- 再帰ケース: 前の値に1を加える
  SELECT n + 1
  FROM numbers
  WHERE n < 10
)
SELECT n FROM numbers;

-- 4. 再帰CTEを使った階層構造の取得例
-- 組織の階層構造をたどる
WITH RECURSIVE employee_hierarchy AS (
  -- ベースケース: トップレベルの従業員（上司がいない）
  SELECT
    id,
    name,
    manager_id,
    1 AS level,
    CAST(name AS CHAR(1000)) AS path
  FROM
    users
  WHERE
    manager_id IS NULL
  
  UNION ALL
  
  -- 再帰ケース: 部下を取得
  SELECT
    u.id,
    u.name,
    u.manager_id,
    eh.level + 1,
    CONCAT(eh.path, ' > ', u.name)
  FROM
    users AS u
  INNER JOIN
    employee_hierarchy AS eh ON u.manager_id = eh.id
  WHERE
    eh.level < 5  -- 無限ループを防ぐため、最大レベルを制限
)
SELECT
  CONCAT(REPEAT('  ', level - 1), name) AS hierarchy,
  level,
  path
FROM
  employee_hierarchy
ORDER BY
  path;

-- 5. CTEを使った集計とフィルタリング
-- 各部署の上位3名の年齢が高い従業員を取得
WITH ranked_users AS (
  SELECT
    name,
    age,
    department,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY age DESC) AS rank_in_dept
  FROM
    users
)
SELECT
  department,
  name,
  age,
  rank_in_dept
FROM
  ranked_users
WHERE
  rank_in_dept <= 3
ORDER BY
  department, rank_in_dept;
