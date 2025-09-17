-- Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    parent_id INT NULL,
    title VARCHAR(255) NOT NULL,
    status ENUM('未着手', '進行中', '完了') NOT NULL DEFAULT '未着手',
    INDEX parent_id_idx (parent_id)
);

-- Delete all existing data from the table
DELETE FROM tasks;

-- Insert the initial data
INSERT INTO tasks (id, parent_id, title, status) VALUES
(1, NULL, '新機能開発プロジェクト', '進行中'),
(2, 1, 'データベース設計', '進行中'),
(3, 2, 'テーブルの正規化', '完了'),
(4, 1, 'ユーザーインターフェースの実装', '未着手'),
(5, 2, 'インデックスの最適化', '未着手'),
(6, 1, 'APIの設計', '未着手'),
(7, 1, 'テストの実施', '未着手'),
(8, 2, 'クエリの最適化', '未着手');