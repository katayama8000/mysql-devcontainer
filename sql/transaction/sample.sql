--  SOURCE /workspace/sql/transaction/sample.sql;

-- 事前に一時テーブルが存在していれば削除する
DROP TEMPORARY TABLE IF EXISTS temp_balance_log;

-- accountsテーブルが存在しない場合にのみ作成します
CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY,
    balance DECIMAL(10, 2)
);

-- accountsテーブルを初期化します
DELETE FROM accounts WHERE account_id = 101;
INSERT INTO accounts (account_id, balance) VALUES (101, 5000.00);

-- 現在のaccountsテーブルの状態を確認
SELECT '--- 初期状態 ---' AS status, account_id, balance FROM accounts;

-- トランザクションを開始する
START TRANSACTION;

-- 1. 一時テーブルを作成する
CREATE TEMPORARY TABLE temp_balance_log (
    account_id INT,
    old_balance DECIMAL(10, 2),
    new_balance DECIMAL(10, 2)
);

-- 一時テーブルに初期残高を挿入します
INSERT INTO temp_balance_log (account_id, old_balance)
SELECT account_id, balance FROM accounts WHERE account_id = 101;

-- 一時テーブルの状態を確認
SELECT '--- 一時テーブルに初期残高を挿入後 ---' AS status, account_id, old_balance, new_balance FROM temp_balance_log;

-- 2. accountsテーブルの残高を更新
-- 残高を500減らします
UPDATE accounts
SET balance = balance - 500.00
WHERE account_id = 101;

-- 更新後のaccountsテーブルの状態を確認
-- 注: この変更はまだコミットされていません
SELECT '--- accountsテーブルを更新後 (未コミット) ---' AS status, account_id, balance FROM accounts;

-- 3. 一時テーブルの new_balance を更新
-- 更新後の残高を取得して一時テーブルに反映させます
UPDATE temp_balance_log
SET new_balance = (SELECT balance FROM accounts WHERE account_id = 101)
WHERE account_id = 101;

-- 一時テーブルの最終状態を確認
SELECT '--- 一時テーブルの最終状態 ---' AS status, account_id, old_balance, new_balance FROM temp_balance_log;

-- 4. 残高がマイナスになっていないかチェック
-- もしnew_balanceが負の値であれば、行が返されます
SELECT '--- 残高チェック結果 ---' AS status, new_balance
FROM temp_balance_log
WHERE new_balance < 0;

-- 5. トランザクションを確定
-- ここでCOMMIT;を実行し、すべての変更が確定されます
COMMIT;

-- トランザクション後の最終的なaccountsテーブルの状態を確認
SELECT '--- トランザクション完了後 ---' AS status, account_id, balance FROM accounts;