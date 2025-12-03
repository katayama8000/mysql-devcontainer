# Index Merge Optimization Example

このディレクトリには、MySQLの **Index Merge** 最適化手法を示すサンプルコードが含まれています。

## Index Merge とは

通常、MySQLは1つのテーブルに対するクエリ実行において、1つのインデックスしか使用しません。しかし、**Index Merge** 最適化が適用されると、複数のインデックスを使用して行をスキャンし、その結果をマージ（結合、交差、和集合）して最終的な結果を生成することができます。

主なアルゴリズムは以下の通りです：

1.  **Intersection Algorithm**: `AND` 条件で複数のインデックスを使用し、その共通部分（積集合）を取得します。
2.  **Union Algorithm**: `OR` 条件で複数のインデックスを使用し、その和集合を取得します。
3.  **Sort-Union Algorithm**: Unionと同様ですが、行IDを取得した後にソートしてからマージします。

## サンプルコードの内容

- `index_merge_example.sql`:
    - `employees_merge_test` テーブルを作成し、`department_id` と `job_title` に個別のインデックスを定義します。
    - `OR` 条件を使ったクエリで **Union** アルゴリズムの動作を確認します。
    - `AND` 条件を使ったクエリで **Intersection** アルゴリズムの動作を確認します（オプティマイザの判断によります）。

## 実行方法

```bash
mysql -h localhost -u root -ppassword mydatabase < sql/index_merge/index_merge_example.sql
```

または MySQL プロンプトから:

```sql
SOURCE /workspace/sql/index_merge/index_merge_example.sql;
```

## 確認ポイント

`EXPLAIN` の出力結果の `type` 列が `index_merge` になっていること、および `Extra` 列に `Using union(...)` や `Using intersect(...)` が表示されていることを確認してください。
