-- ① テーブルの準備（前回の残りを消して作り直し）
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT,
  content TEXT,
  parent_id INT
);

-- ② データの準備
INSERT INTO posts (id, content, parent_id) VALUES
(101, '今日のランチ何にする？', NULL),
(102, 'カレーがいいな！', 101),
(103, '私はパスタ派です', 101),
(104, '神保町のカレー屋知ってるよ', 102),
(105, 'そこ、私も行きたい！', 104),
(106, '風邪ひいた', NULL),
(107, 'お大事に', 106),
(108, 'ありがとう', 107);


-- ③ WITH RECURSIVE で階層構造だけを取り出す
WITH RECURSIVE thread(id, content, level) AS (
  -- 【スタート】親がいない投稿（level 1）
  SELECT id, content, 1
  FROM posts
  WHERE parent_id IS NULL

  UNION ALL

  -- 【再帰】前の結果(t)に繋がる投稿(p)を探し、levelを1ずつ増やす
  SELECT p.id, p.content, t.level + 1
  FROM posts p
  JOIN thread t ON p.parent_id = t.id
)
SELECT * FROM thread;

-- ④ さらに、スレッドの塊を識別するために「root_id」を追加してみる
WITH RECURSIVE thread(id, content, level, root_id) AS (
  -- 【スタート】親がいない投稿（level 1）
  -- 自分のIDを「root_id」としてセットする
  SELECT id, content, 1, id
  FROM posts
  WHERE parent_id IS NULL

  UNION ALL

  -- 【再帰】親の「root_id」をそのまま引き継ぐ
  SELECT p.id, p.content, t.level + 1, t.root_id
  FROM posts p
  JOIN thread t ON p.parent_id = t.id
)
-- root_idでグループ（塊）にして、その中でレベル順に並べる
SELECT * FROM thread 
ORDER BY root_id ASC, level ASC;