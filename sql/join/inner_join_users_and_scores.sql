-- SOURCE /workspace/sql/inner_join_users_and_scores.sql;
-- usersテーブルとuser_scoresテーブルをINNER JOINで結合
-- ON users.id = user_scores.user_id の条件で結合します
-- このクエリの結果は、両方のテーブルに存在するユーザーのみが抽出されます
SELECT
    u.id,
    u.name,
    u.department,
    s.score
FROM
    users AS u
INNER JOIN
    user_scores AS s ON u.id = s.user_id;

-- 結合後のレコード数を確認（15件になるはずです）
SELECT COUNT(*) AS total_records_after_inner_join
FROM
    users AS u
INNER JOIN
    user_scores AS s ON u.id = s.user_id;
