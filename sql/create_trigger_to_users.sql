-- SOURCE /workspace/sql/create_trigger_to_users.sql;
-- usersテーブルに新しいユーザーが挿入された後に実行されるトリガーです。
-- このトリガーは、ユーザーの登録イベントをuser_logsテーブルに記録します。

USE mydatabase;

-- 既存のトリガーがあれば削除します
DROP TRIGGER IF EXISTS after_user_insert;

-- デリミタを一時的に変更
DELIMITER //

-- after_user_insertトリガーを作成
CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_logs (user_id, action, details)
    VALUES (NEW.id, 'User Registered', CONCAT('新しいユーザーが登録されました: ', NEW.name, ' (ID: ', NEW.id, ')'));
END//

-- デリミタを元に戻す
DELIMITER ;
