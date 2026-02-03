-- SOURCE /workspace/sql/covering_index/covering_index_example.sql;

-- カバリングインデックスの例とそれが効かない例
-- このスクリプトはべき等（idempotent）です。何度実行しても同じ結果になります。

-- 1. テーブルの準備（既存のテーブルを削除して再作成）
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email_age (email, age)
);

-- 2. テストデータの挿入
INSERT INTO users (email, name, age, address) VALUES
('user001@example.com', '山田太郎', 25, '東京都渋谷区'),
('user002@example.com', '佐藤花子', 30, '大阪府大阪市'),
('user003@example.com', '鈴木一郎', 28, '愛知県名古屋市'),
('user004@example.com', '高橋美咲', 35, '福岡県福岡市'),
('user005@example.com', '田中健太', 42, '北海道札幌市');

-- より多くのデータを追加してパフォーマンスの差を見やすくする
INSERT INTO users (email, name, age, address)
SELECT 
    CONCAT('user', LPAD(n, 6, '0'), '@example.com'),
    CONCAT('ユーザー', n),
    20 + (n % 50),
    CONCAT('都道府県', n % 47, '市区町村', n % 100)
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 AS n
    FROM 
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
) numbers
WHERE n BETWEEN 6 AND 10000;

SELECT '=== データ挿入完了 ===' AS status;
SELECT COUNT(*) AS total_users FROM users;

-- 3. インデックスの確認
SELECT '\n=== 現在のインデックス ===' AS info;
SHOW INDEXES FROM users;

-- ============================================
-- ✅ ケース1: カバリングインデックスが効く例
-- ============================================
SELECT '\n=== ケース1: カバリングインデックスが効く例 ===' AS info;
SELECT '   SELECTするカラムがすべてインデックスに含まれている' AS description;

EXPLAIN SELECT id, email, age 
FROM users 
WHERE email = 'user001@example.com'\G

-- Extra: Using index が表示される
-- これは、インデックスだけでクエリを処理できることを意味する

-- 実際のクエリ実行
SELECT id, email, age 
FROM users 
WHERE email = 'user001@example.com';

-- ============================================
-- ✅ ケース2: 範囲検索でもカバリングインデックスが効く
-- ============================================
SELECT '\n=== ケース2: 範囲検索でもカバリングインデックスが効く ===' AS info;

EXPLAIN SELECT id, email, age 
FROM users 
WHERE email LIKE 'user00%' AND age > 30\G

-- Extra: Using where; Using index が表示される
-- インデックスだけで条件評価とデータ取得が完了

SELECT id, email, age 
FROM users 
WHERE email LIKE 'user00%' AND age > 30
LIMIT 5;

-- ============================================
-- ❌ ケース3: カバリングインデックスが効かない例
-- ============================================
SELECT '\n=== ケース3: カバリングインデックスが効かない例 ===' AS info;
SELECT '   インデックスに含まれていないカラム(name)をSELECTしている' AS description;

EXPLAIN SELECT id, email, age, name 
FROM users 
WHERE email = 'user001@example.com'\G

-- Extra: Using index condition が表示される（Using index ではない）
-- nameカラムがインデックスに含まれていないため、テーブルへのアクセスが必要

SELECT id, email, age, name 
FROM users 
WHERE email = 'user001@example.com';

-- ============================================
-- ❌ ケース4: SELECT * はカバリングインデックスが効かない
-- ============================================
SELECT '\n=== ケース4: SELECT * はカバリングインデックスが効かない ===' AS info;

EXPLAIN SELECT * 
FROM users 
WHERE email = 'user002@example.com'\G

-- すべてのカラムが必要なため、テーブルアクセスが発生

SELECT * 
FROM users 
WHERE email = 'user002@example.com';

-- ============================================
-- ✅ ケース5: COUNT(*) でもカバリングインデックスが効く
-- ============================================
SELECT '\n=== ケース5: COUNT(*) でもカバリングインデックスが効く ===' AS info;

EXPLAIN SELECT COUNT(*) 
FROM users 
WHERE email LIKE 'user001%'\G

-- インデックスだけで件数をカウントできる

SELECT COUNT(*) 
FROM users 
WHERE email LIKE 'user001%';

-- ============================================
-- 比較: パフォーマンスの差を確認
-- ============================================
SELECT '\n=== パフォーマンス比較 ===' AS info;

-- カバリングインデックスあり
SELECT '--- カバリングインデックスあり (id, email, age) ---' AS test;
SELECT BENCHMARK(100000, (
    SELECT id, email, age FROM users WHERE email = 'user001@example.com' LIMIT 1
)) AS 'カバリングインデックス使用';

-- カバリングインデックスなし
SELECT '--- カバリングインデックスなし (id, email, age, name, address) ---' AS test;
SELECT BENCHMARK(100000, (
    SELECT id, email, age, name, address FROM users WHERE email = 'user001@example.com' LIMIT 1
)) AS 'テーブルアクセスあり';

-- ============================================
-- 📝 まとめ
-- ============================================
SELECT '\n=== まとめ ===' AS info;
SELECT '
カバリングインデックスが効く条件:
1. SELECTするカラムがすべてインデックスに含まれている
2. WHERE句で使用するカラムもインデックスに含まれている
3. EXPLAINのExtraに「Using index」と表示される

カバリングインデックスが効かない場合:
1. インデックスに含まれていないカラムをSELECTしている
2. SELECT * を使用している
3. LARGEカラム（TEXT, BLOB等）を含めると効果が薄い

パフォーマンス向上のポイント:
- 必要なカラムだけをSELECTする
- よく使うクエリパターンに合わせて複合インデックスを設計する
- カバリングインデックスを活用することでディスクI/Oを削減できる
' AS summary;
