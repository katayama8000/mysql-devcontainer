-- 複合インデックスのパフォーマンス測定用SQL
-- MySQL内で実行してください

USE mydatabase;

-- ========================================
-- 0. 既存インデックス削除（PRIMARY KEYとUNIQUE以外）
-- ========================================
SELECT 'Dropping existing indexes...' as status;

-- 既存のインデックスを削除（エラーが発生しても継続）
-- Note: MySQL 5.7以前では IF EXISTS がサポートされていない場合があります
DROP INDEX idx_department ON users;
DROP INDEX idx_age ON users;
DROP INDEX idx_dept_age ON users;
DROP INDEX idx_age_dept ON users;
DROP INDEX idx_covering ON users;

-- ========================================
-- 1. 現在のインデックス状況確認
-- ========================================
SELECT 'Current indexes after cleanup:' as status;
SHOW INDEX FROM users;

-- ========================================
-- 2. インデックスなしの状態でのパフォーマンス測定
-- ========================================
SELECT '--- Before creating composite index ---' as status;

-- パターン1: 部署のみ
SELECT 'Pattern 1: department only' as query_type;
EXPLAIN SELECT * FROM users WHERE department = 'Engineering';

-- パターン2: 年齢のみ  
SELECT 'Pattern 2: age only' as query_type;
EXPLAIN SELECT * FROM users WHERE age = 30;

-- パターン3: 部署 + 年齢
SELECT 'Pattern 3: department + age' as query_type;
EXPLAIN SELECT * FROM users WHERE department = 'Engineering' AND age = 30;

-- パターン4: 年齢 + 部署（順序が逆）
SELECT 'Pattern 4: age + department' as query_type;
EXPLAIN SELECT * FROM users WHERE age = 30 AND department = 'Engineering';

-- ========================================
-- 3. 部署用の単一インデックス作成
-- ========================================
SELECT 'Creating single index on department...' as status;
CREATE INDEX idx_department ON users (department);

SELECT '--- After creating department index ---' as status;
EXPLAIN SELECT * FROM users WHERE department = 'Engineering';
EXPLAIN SELECT * FROM users WHERE department = 'Engineering' AND age = 30;

-- ========================================
-- 4. 複合インデックス作成（部署, 年齢）
-- ========================================
SELECT 'Creating composite index (department, age)...' as status;
CREATE INDEX idx_dept_age ON users (department, age);

SELECT '--- After creating composite index (department, age) ---' as status;

-- パターン1: 部署のみ（複合インデックスの左端一致）
SELECT 'Pattern 1: department only (leftmost prefix)' as query_type;
EXPLAIN SELECT * FROM users WHERE department = 'Engineering';

-- パターン2: 年齢のみ（複合インデックス使用できない）
SELECT 'Pattern 2: age only (cannot use composite index)' as query_type;
EXPLAIN SELECT * FROM users WHERE age = 30;

-- パターン3: 部署 + 年齢（複合インデックス完全使用）
SELECT 'Pattern 3: department + age (full composite index)' as query_type;
EXPLAIN SELECT * FROM users WHERE department = 'Engineering' AND age = 30;

-- パターン4: 年齢 + 部署（順序関係なく最適化される）
SELECT 'Pattern 4: age + department (optimizer reorders)' as query_type;
EXPLAIN SELECT * FROM users WHERE age = 30 AND department = 'Engineering';

-- ========================================
-- 5. 異なる順序の複合インデックスを追加テスト
-- ========================================
SELECT 'Creating reverse composite index (age, department)...' as status;
CREATE INDEX idx_age_dept ON users (age, department);

SELECT '--- After creating reverse composite index (age, department) ---' as status;
EXPLAIN SELECT * FROM users WHERE age = 30;
EXPLAIN SELECT * FROM users WHERE age = 30 AND department = 'Engineering';

-- ========================================
-- 6. 範囲検索でのパフォーマンス
-- ========================================
SELECT '--- Range queries performance ---' as status;

SELECT 'Range on age with department' as query_type;
EXPLAIN SELECT * FROM users WHERE department = 'Engineering' AND age BETWEEN 25 AND 30;

SELECT 'Range on department (not efficient)' as query_type;
EXPLAIN SELECT * FROM users WHERE department IN ('Engineering', 'Marketing') AND age = 30;

-- ========================================
-- 7. ORDER BY での複合インデックス効果
-- ========================================
SELECT '--- ORDER BY performance ---' as status;

SELECT 'ORDER BY matching index order' as query_type;
EXPLAIN SELECT * FROM users WHERE department = 'Engineering' ORDER BY age;

SELECT 'ORDER BY not matching index order' as query_type;
EXPLAIN SELECT * FROM users WHERE age = 30 ORDER BY department;

-- ========================================
-- 8. カバリングインデックスのテスト
-- ========================================
SELECT 'Creating covering index...' as status;
CREATE INDEX idx_covering ON users (department, age, name);

SELECT '--- Covering index test ---' as status;
EXPLAIN SELECT department, age, name FROM users WHERE department = 'Engineering' AND age = 30;

-- ========================================
-- 9. 最終的なインデックス一覧
-- ========================================
SELECT 'Final index list:' as status;
SHOW INDEX FROM users;

-- ========================================
-- 10. 実際のデータ件数確認
-- ========================================
SELECT 'Data distribution:' as status;
SELECT department, COUNT(*) as count FROM users GROUP BY department ORDER BY count DESC;
SELECT age, COUNT(*) as count FROM users GROUP BY age ORDER BY count DESC;
