-- SOURCE /workspace/sql/insert_users.sql;
-- usersテーブルに少数のサンプルデータを挿入するスクリプトです。
-- このスクリプトは、create_tables.sql と create_trigger.sql を実行した後に使用することを想定しています。

USE mydatabase;

-- サンプルユーザーを挿入
INSERT INTO users (name, email, age, department) VALUES
('Taro Yamada', 'taro.yamada@example.com', 25, 'Engineering'),
('Hanako Sato', 'hanako.sato@example.com', 30, 'Marketing'),
('Jiro Tanaka', 'jiro.tanaka@example.com', 28, 'Sales'),
('Yuki Takahashi', 'yuki.takahashi@example.com', 32, 'Engineering'),
('Rina Kobayashi', 'rina.kobayashi@example.com', 27, 'HR');

-- 挿入されたユーザーの合計数を表示
SELECT COUNT(*) as total_users FROM users;

-- トリガーによって記録されたログを表示
SELECT * FROM user_logs;
