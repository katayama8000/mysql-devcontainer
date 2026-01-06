-- SOURCE /workspace/sql/metadata_lock/metadata_lock_example.sql;

-- このスクリプトは、長時間実行されるトランザクションが、
-- 同じテーブルに対してDDLステートメントが試行されたときに、
-- メタデータロックを引き起こす方法を示します。

-- 1. クリーンアップ（べき等性を保証）
DROP TABLE IF EXISTS my_table;

-- 2. サンプルテーブルの作成
CREATE TABLE IF NOT EXISTS my_table (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. サンプルデータの挿入
-- TRUNCATE TABLE my_table; -- テーブルを空にする場合
INSERT INTO my_table (name) VALUES ('Alice'), ('Bob'), ('Charlie');

-- メタデータロックを観察するには、次の手順に従ってください：

-- セッション1：トランザクションを開始し、テーブルから読み取ります
-- 以下の行をMySQLクライアントで実行しますが、まだコミットもロールバックもしないでください。
--
-- START TRANSACTION;
-- SELECT * FROM my_table WHERE id = 1;
-- (このセッションを開いたまま、トランザクションを未コミットの状態にしてください)

-- セッション2：同じテーブルに対してDDL操作を試みます
-- 2つ目のMySQLクライアントを開き、次のALTER TABLEステートメントを実行します。
-- このステートメントは、セッション1のトランザクションが完了するまで、メタデータロックを待ってハングします。
--
-- ALTER TABLE my_table ADD COLUMN new_column VARCHAR(255);

-- セッション1：セッション2でのハングを観察した後、セッション1でトランザクションをコミットします。
-- これで、セッション2のALTER TABLEが完了するはずです。
--
-- COMMIT;
-- (代わりにROLLBACK;でもロックは解放されます)

-- セッション2でALTER TABLEが完了した後、新しいカラムを確認できます：
-- DESCRIBE my_table;
-- SELECT * FROM my_table;