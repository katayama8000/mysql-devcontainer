-- Backlogの課題階層構造のサンプル（シンプル版）

-- テーブル作成とデータ挿入（べき等性を保証）
DROP TABLE IF EXISTS issues;

CREATE TABLE issues (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,
  status ENUM('未対応', '処理中', '完了') DEFAULT '未対応',
  parent_id INT,
  FOREIGN KEY (parent_id) REFERENCES issues(id) ON DELETE CASCADE
);

-- サンプルデータを挿入
INSERT INTO issues (id, title, status, parent_id) VALUES
(1, 'ユーザー認証機能', '処理中', NULL),
(2, 'ログイン画面', '完了', 1),
(3, 'JWT認証', '処理中', 1),
(4, 'トークン生成', '完了', 3),
(5, 'トークン検証', '処理中', 3);

-- =====================================================
-- 例1: 特定の親課題配下の全ての子課題を取得（CTEあり）
-- =====================================================
SELECT '===== CTEあり: 課題ID=1の配下にある全ての課題 =====' AS '';

WITH RECURSIVE issue_tree AS (
  SELECT
    id,
    title,
    status,
    parent_id,
    1 AS level
  FROM issues
  WHERE id = 1
  
  UNION ALL
  
  SELECT
    i.id,
    i.title,
    i.status,
    i.parent_id,
    it.level + 1
  FROM issues i
  JOIN issue_tree it ON i.parent_id = it.id
)
SELECT
  CONCAT(REPEAT('  ', level - 1), '└ ', title) AS hierarchy,
  id,
  status,
  level
FROM issue_tree
ORDER BY id;

-- =====================================================
-- 例1の別解: CTEなし（直接の子のみ取得可能）
-- =====================================================
SELECT '' AS '';
SELECT '===== CTEなし: 課題ID=1の直接の子課題のみ（孫は取れない） =====' AS '';

SELECT
  i.id,
  i.title,
  i.status
FROM issues i
WHERE i.parent_id = 1;

-- 孫まで取得したい場合は複数回JOINが必要
SELECT '' AS '';
SELECT '===== CTEなし: 孫まで取得（3階層まで固定） =====' AS '';

SELECT
  i1.id AS level1_id,
  i1.title AS level1_title,
  i2.id AS level2_id,
  i2.title AS level2_title,
  i3.id AS level3_id,
  i3.title AS level3_title
FROM issues i1
LEFT JOIN issues i2 ON i2.parent_id = i1.id
LEFT JOIN issues i3 ON i3.parent_id = i2.id
WHERE i1.id = 1
ORDER BY i1.id, i2.id, i3.id;

-- =====================================================
-- 例2: 親課題から最上位の親までのパスを辿る（CTEあり）
-- =====================================================
SELECT '' AS '';
SELECT '===== CTEあり: 課題ID=5から最上位親までのパス =====' AS '';

WITH RECURSIVE ancestors AS (
  SELECT
    id,
    title,
    parent_id,
    1 AS level
  FROM issues
  WHERE id = 5
  
  UNION ALL
  
  SELECT
    i.id,
    i.title,
    i.parent_id,
    a.level + 1
  FROM issues i
  JOIN ancestors a ON i.id = a.parent_id
)
SELECT
  id,
  title,
  level
FROM ancestors
ORDER BY level DESC;

-- =====================================================
-- 例2の別解: CTEなし（固定階層のみ）
-- =====================================================
SELECT '' AS '';
SELECT '===== CTEなし: 課題ID=5の親を辿る（3階層まで固定） =====' AS '';

SELECT
  i1.id AS child_id,
  i1.title AS child_title,
  i2.id AS parent_id,
  i2.title AS parent_title,
  i3.id AS grandparent_id,
  i3.title AS grandparent_title
FROM issues i1
LEFT JOIN issues i2 ON i1.parent_id = i2.id
LEFT JOIN issues i3 ON i2.parent_id = i3.id
WHERE i1.id = 5;
