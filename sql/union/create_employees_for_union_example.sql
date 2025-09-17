-- `employees`テーブルがまだ存在しない場合に作成
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(255) NOT NULL,
    department VARCHAR(50) NOT NULL
);

-- 既存のデータをすべて削除
DELETE FROM employees;

-- サンプルデータの挿入
INSERT INTO employees (employee_name, department) VALUES
('山田 太郎', '経理'),
('佐藤 花子', '経理'),
('田中 一郎', '営業'),
('鈴木 恵美', '営業'),
('高橋 健太', '開発');