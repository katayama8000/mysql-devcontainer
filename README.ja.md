## 再帰クエリテスト

このセクションでは、再帰クエリテストの実行方法と、クエリが何をするかを説明します。


### SQLクエリの動作

`sql/recursive_query/validate_query.sql`内のSQLクエリは、特定の親課題のすべての子孫課題のうち、「未完了」状態にあるものを見つけるように設計されています。

クエリの詳細は以下の通りです。

-   **`WITH RECURSIVE all_descendants(...) AS (...)`**: `all_descendants`という名前の共通テーブル式（CTE）を定義します。これは自身を参照できるため、クエリが再帰的になります。

-   **`SELECT id, parent_issue_id, status_id, id as root_child_id FROM issue WHERE parent_issue_id = 1`**: これが再帰の開始点です。`id = 1`の課題のすべての子を直接選択します。`root_child_id`は直接の子の`id`に設定されます。

-   **`UNION ALL`**: これにより、開始クエリの結果とクエリの再帰部分の結果が結合されます。

-   **`SELECT i.id, i.parent_issue_id, i.status_id, d.root_child_id FROM issue i JOIN all_descendants d ON i.parent_issue_id = d.id`**: これが再帰部分です。前のステップで見つかった課題のすべての子を見つけ、前のステップの`root_child_id`を保持します。

-   **`SELECT DISTINCT root_child_id FROM all_descendants WHERE status_id IN (1, 2)`**: これが最終的なクエリです。`status_id`が`1`または`2`（「未完了」と見なしている）であるすべての子孫課題の、一意の`root_child_id`を選択します。

簡単に言うと、このクエリは親課題から始まり、そのすべての子、さらにその子を見つけます。次に、「未完了」のものだけをフィルタリングし、元の親の直接の子のうち、未完了のタスクがその先にあるものを表示します。