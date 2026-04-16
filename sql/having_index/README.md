# HAVING と INDEX の調査

## セットアップ

```bash
make sql FILE=sql/having_index/setup.sql
```

## 調査クエリの実行

```bash
make sql FILE=sql/having_index/having_index_example.sql
```

## 調査ポイント

| クエリ  | 確認内容                                                                 |
| ------- | ------------------------------------------------------------------------ |
| クエリ1 | インデックスなしの `HAVING` → `type=ALL` になるか                        |
| クエリ2 | `idx_project_id` 追加後に `EXPLAIN` の結果がどう変わるか                 |
| クエリ3 | `WHERE` vs `HAVING` のフィルタタイミングの違い                           |
| クエリ4 | 複合インデックス `(project_id, status)` でカバリングインデックスが効くか |
| クエリ5 | `HAVING project_id = 1` がオプティマイザに `WHERE` として扱われるか      |

## インデックスの追加・削除

`setup.sql` 内のコメントアウトされたインデックス定義を外してから再度 setup を流す。

```sql
-- 例: project_id のインデックスを有効にする場合
CREATE INDEX idx_project_id ON issues (project_id);
```

```bash
# テーブルを作り直してインデックスあり状態にする
make sql FILE=sql/having_index/setup.sql

# EXPLAIN の結果を比較する
make sql FILE=sql/having_index/having_index_example.sql
```

## HAVING の基本

- `WHERE` は集計**前**にフィルタ → インデックスが効く
- `HAVING` は集計**後**にフィルタ → 全件 `GROUP BY` してから絞る
- `HAVING` に集計関数を使わない場合（例: `HAVING project_id = 1`）は、オプティマイザが `WHERE` に変換することがある
