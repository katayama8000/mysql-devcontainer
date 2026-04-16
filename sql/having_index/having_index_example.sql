USE mydatabase;

-- ============================================================

-- HAVINGとインデックスの調査クエリ
-- 実行前に setup.sql を流しておくこと
--   make sql FILE=sql/having_index/setup.sql
-- ============================================================

-- ------------------------------------------------------------
-- 1. インデックスなしの状態でのHAVING (EXPLAIN で type=ALL になるはず)
-- ------------------------------------------------------------
SELECT '----- Query 1: HAVING without index -----';
EXPLAIN
SELECT project_id, COUNT(*) AS issue_count
FROM issues
GROUP BY project_id
HAVING issue_count >= 3;
SELECT '';

-- ------------------------------------------------------------
-- 2. インデックスを貼ってEXPLAINを比較
--    (setup.sql のコメントアウトを外して試す)
-- ------------------------------------------------------------
-- CREATE INDEX idx_project_id ON issues (project_id);

SELECT '----- Query 2: compare after adding idx_project_id -----';
EXPLAIN
SELECT project_id, COUNT(*) AS issue_count
FROM issues
GROUP BY project_id
HAVING issue_count >= 3;
SELECT '';

-- ------------------------------------------------------------
-- 3. HAVING vs WHERE の違いを確認
--    WHERE はインデックスを使えるが HAVING は集計後フィルタ
-- ------------------------------------------------------------

-- WHERE でフィルタ (集計前) → インデックスが効く
SELECT '----- Query 3-1: WHERE filter before aggregation -----';
EXPLAIN
SELECT project_id, COUNT(*) AS issue_count
FROM issues
WHERE project_id IN (1, 2)
GROUP BY project_id;
SELECT '';

-- HAVING でフィルタ (集計後) → 全件 GROUP BY してから絞る
SELECT '----- Query 3-2: HAVING filter after aggregation -----';
EXPLAIN
SELECT project_id, COUNT(*) AS issue_count
FROM issues
GROUP BY project_id
HAVING project_id IN (1, 2);
SELECT '';

-- ------------------------------------------------------------
-- 4. 複合インデックス (project_id, status) でのカバリングインデックス効果
--    (setup.sql のコメントアウトを外して試す)
-- ------------------------------------------------------------
-- CREATE INDEX idx_project_status ON issues (project_id, status);

SELECT '----- Query 4: covering index check (project_id, status) -----';
EXPLAIN
SELECT project_id, status, COUNT(*) AS cnt
FROM issues
GROUP BY project_id, status
HAVING cnt >= 2;
SELECT '';

-- ------------------------------------------------------------
-- 5. HAVING に集計関数を使わずカラムを直接指定するケース
--    (GROUP BY に含まれるカラムへの HAVING はオプティマイザが WHERE に変換する場合がある)
-- ------------------------------------------------------------
SELECT '----- Query 5: non-aggregate HAVING predicate -----';
EXPLAIN
SELECT project_id, COUNT(*) AS issue_count
FROM issues
GROUP BY project_id
HAVING project_id = 1;

SELECT '';
SELECT '===== END: HAVING and INDEX investigation =====';
SELECT '';
