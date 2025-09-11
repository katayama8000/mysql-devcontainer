-- ユーザーのスコアを記録する新しいテーブル
-- 全てのユーザーではなく、一部のユーザーのみのスコアを登録します
CREATE TABLE IF NOT EXISTS user_scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    score INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- スコアデータを挿入（一部のユーザーのみ）
INSERT INTO user_scores (user_id, score) VALUES
(1, 95),   -- Alice Johnson
(2, 88),   -- Bob Smith
(3, 92),   -- Carol Davis
(4, 75),   -- David Wilson
(5, 80),   -- Emma Brown
(10, 99),  -- Jack Anderson
(20, 85),  -- Tina Hall
(30, 90),  -- Dana Gonzalez
(40, 78),  -- Nina Evans
(50, 81),  -- Xena Rivera
(60, 87),  -- Gary Ramirez
(70, 93),  -- Quest Ross
(80, 79),  -- Faye Bryant
(90, 84),  -- Max Ford
(100, 91); -- Zion Harper
