-- SOURCE /workspace/sql/many_to_many_example.sql;

-- 多対多のリレーションシップを表現するためのサンプルSQL
-- 生徒(students)と講座(courses)を題材とします。

-- テーブルが存在する場合は削除して再作成（冪等性を担保）
DROP TABLE IF EXISTS student_courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;

-- ■ 1. テーブル定義

-- 生徒テーブル
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '生徒名'
) COMMENT='生徒情報を格納するテーブル';

-- 講座テーブル
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '講座名'
) COMMENT='講座情報を格納するテーブル';

-- 中間テーブル (生徒と講座の関連を定義)
CREATE TABLE IF NOT EXISTS student_courses (
    student_id INT NOT NULL COMMENT '生徒ID',
    course_id INT NOT NULL COMMENT '講座ID',
    -- 複合主キーとして設定し、(student_id, course_id) の組み合わせが一意であることを保証
    PRIMARY KEY (student_id, course_id),
    -- 外部キー制約
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) COMMENT='生徒と講座の多対多関連を管理する中間テーブル';


-- ■ 2. サンプルデータの挿入

-- 生徒の登録
INSERT INTO students (name) VALUES
('Alice'),
('Bob'),
('Charlie');

-- 講座の登録
INSERT INTO courses (name) VALUES
('数学'),
('物理'),
('歴史');

-- 誰がどの講座を受講しているかを中間テーブルに登録
-- Alice (ID:1) は 数学(ID:1)と物理(ID:2)を受講
-- Bob (ID:2) は 物理(ID:2)と歴史(ID:3)を受講
-- Charlie (ID:3) は 数学(ID:1)と歴史(ID:3)を受講
INSERT INTO student_courses (student_id, course_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 1),
(3, 3);


-- ■ 3. データ取得のクエリ例

-- 例1: 全生徒の受講講座一覧を取得する
-- 3つのテーブルをJOINして、人間が読みやすい形式で表示します。
SELECT
    s.name AS student_name,
    c.name AS course_name
FROM
    students s
JOIN
    student_courses sc ON s.id = sc.student_id
JOIN
    courses c ON sc.course_id = c.id
ORDER BY
    s.name, c.name;

-- 例2: 「物理」を受講している生徒一覧を取得する
SELECT
    s.name AS student_name
FROM
    students s
JOIN
    student_courses sc ON s.id = sc.student_id
JOIN
    courses c ON sc.course_id = c.id
WHERE
    c.name = '物理';
