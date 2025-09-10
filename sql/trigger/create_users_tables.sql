-- SOURCE /workspace/sql/create_users_tables.sql;

-- データベースのテーブルを作成するスクリプトです。
-- ユーザーテーブルと、トリガーのログを記録するテーブルが含まれています。

USE mydatabase;

-- 既存のテーブルがあれば削除します
DROP TABLE IF EXISTS user_scores;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS user_logs;

-- users テーブルを作成
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT,
    department VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- user_logs テーブルを作成 (トリガーによるイベントログ用)
CREATE TABLE user_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(50) NOT NULL,
    details TEXT,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
