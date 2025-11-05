### `DISTINCT` キーワードのサンプル

このディレクトリには、`DISTINCT` キーワードの使用方法を示す自己完結型のSQLスクリプトが含まれています。

#### `distinct_example.sql`

このスクリプトは、`DISTINCT` の動作を実証するために、専用のテーブルの作成、ダミーデータの挿入、およびクエリの実行をすべて1つのファイルで行います。

スクリプトは**べき等**です。つまり、何度実行してもデータベースは同じ最終状態になります。これは、スクリプトの最初に `DROP TABLE IF EXISTS` を使用して、毎回テーブルを再作成することで実現されています。

#### 実行内容

1.  **`DROP TABLE IF EXISTS sales_data;`**: もし `sales_data` テーブルが既に存在していれば、それを削除します。
2.  **`CREATE TABLE sales_data (...)`**: `id`, `product_name`, `region`, `sale_date` カラムを持つ新しいテーブルを作成します。
3.  **`INSERT INTO sales_data (...)`**: `sales_data` テーブルに7件のダミーデータを挿入します。`region` カラムには 'North America', 'Europe', 'Asia' といった重複する値が含まれています。
4.  **`SELECT DISTINCT region FROM sales_data;`**: `sales_data` テーブルから `region` カラムの一意な値（重複を除いたリスト）を取得して表示します。

#### 期待される結果

最後の `SELECT DISTINCT` クエリは、以下の結果を返します。

```
+---------------+
| region        |
+---------------+
| North America |
| Europe        |
| Asia          |
+---------------+
```

`North America`, `Europe`, `Asia` はそれぞれ複数回データに登場しますが、`DISTINCT` によって一意な値だけが抽出されていることがわかります。