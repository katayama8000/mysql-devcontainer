-- SOURCE /workspace/sql/distinct/distinct_example.sql;

-- このスクリプトはべき等です。何度実行しても同じ結果になります。

USE mydatabase;

-- sales_data テーブルが存在する場合は削除します
DROP TABLE IF EXISTS sales_data;

-- sales_data テーブルを作成します
CREATE TABLE sales_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    region VARCHAR(100) NOT NULL,
    sale_date DATE
);

-- ダミーデータを挿入します
INSERT INTO sales_data (product_name, region, sale_date)

    ('Laptop', 'North America', '2024-01-15'),
    ('Keyboard', 'Europe', '2024-01-16'),
    ('Mouse', 'North America', '2024-01-17'),
    ('Monitor', 'Asia', '2024-01-18'),
    ('Laptop', 'Europe', '2024-01-19'),
    ('Webcam', 'North America', '2024-01-20'),
    ('Keyboard', 'Asia', '2024-01-21');

-- region カラムから重複しない値を取得します
SELECT DISTINCT region
FROM sales_data;
