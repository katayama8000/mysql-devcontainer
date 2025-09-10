-- usersテーブルとuser_scoresテーブルをLEFT JOINで結合
-- ON users.id = user_scores.user_id の条件で結合します
-- このクエリの結果は、100人全員のユーザーと、スコアがある場合はそのスコア、
-- スコアがない場合はNULLが表示されます
SELECT
    u.id,
    u.name,
    u.department,
    s.score
FROM
    users AS u
LEFT JOIN
    user_scores AS s ON u.id = s.user_id;

-- 結合後のレコード数を確認（100件になるはずです）
SELECT COUNT(*) AS total_records_after_left_join
FROM
    users AS u
LEFT JOIN
    user_scores AS s ON u.id = s.user_id;