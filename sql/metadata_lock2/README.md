# メタデータロックの検証 (Metadata Lock Verification)

このシナリオでは、長時間実行されるトランザクションがテーブルに対して実行されている間に、同じテーブル、または関連するテーブルに対するDDL操作がどのようにメタデータロックを引き起こすかを示します。

## 前提条件

`issue` および `project` テーブルがデータベースに作成され、サンプルデータが挿入されていることを確認してください。
まだセットアップしていない場合は、以下のSQLファイルを実行してください。

```bash
SOURCE /workspace/sql/metadata_lock2/issue_project_setup.sql;
```

## 検証手順

メタデータロックを観察するために、**2つの異なるMySQLクライアントセッション**を開いてください。

### セッション1：長時間実行されるトランザクションの開始

最初のセッションで、`issue` テーブルに対する長時間実行されるクエリを開始します。
**このトランザクションはコミットまたはロールバックしないでください。**

1.  新しいターミナルを開きます。
2.  以下のコマンドを実行して、`issue` テーブルからデータを読み取り、`SLEEP(15)` を使用してクエリの実行を遅延させます。
    このコマンドは、`issue` テーブルに対する読み取りロックを約15秒間保持します。
    ```bash
    SOURCE /workspace/sql/metadata_lock2/long_running_transaction.sql;
    ```
    （これは`START TRANSACTION;`と`SELECT`文、`COMMIT;`を含んでいます。`COMMIT;`の前に中断してロックを保持することも可能です。）
    もし`COMMIT;`なしで実行したい場合は、MySQLクライアントに入り、手動で`START TRANSACTION; SELECT *, SLEEP(15) FROM issue;`を実行してください。

### セッション2：DDL操作の試行

セッション1のトランザクションがまだ実行中である間に、2番目のセッションで `project` テーブルにカラムを追加するDDL操作を試みます。

1.  別の新しいターミナルを開きます。
2.  以下のコマンドを実行して、`project` テーブルに新しいカラムを追加します。
    ```bash
    SOURCE /workspace/sql/metadata_lock2/alter_project_table.sql;
    ```

### 予想される結果

-   **セッション2の `ALTER TABLE` ステートメントはハング（停止）します。** これは、セッション1のトランザクションが `issue` テーブルに対するメタデータロックを保持しているため、MySQLが `project` テーブルに関連するスキーマ変更を許可できないために発生します。`issue` と `project` テーブルは外部キー制約で関連しているため、`project` テーブルの変更もブロックされます。
-   セッション1のクエリが完了（約15秒後）すると、セッション1のトランザクションがコミットされ、メタデータロックが解放されます。
-   ロックが解放されると、セッション2の `ALTER TABLE` ステートメントが正常に完了します。

### 検証

セッション2の `ALTER TABLE` が完了した後、`project` テーブルの構造を確認して、新しいカラムが追加されたことを確認できます。

```bash
SOURCE /workspace/sql/metadata_lock2/describe_project.sql;
```

### クリーンアップ

検証が完了したら、追加したカラムを削除してテーブルを元の状態に戻すことができます。

```sql
ALTER TABLE project DROP COLUMN new_column;
```

## シナリオ2：ロック中に他のSELECTクエリが来た場合

このシナリオでは、DDL操作（`ALTER TABLE`）がメタデータロックを待っている間に、同じテーブルに対して別の`SELECT`クエリが来た場合に何が起こるかを検証します。

### 検証手順

**3つの異なるMySQLクライアントセッション**を開いてください。

#### セッション1：長時間実行されるトランザクションの開始

最初のセッションで、`issue` テーブルに対する長時間実行されるクエリを開始します。

```bash
mysql -h mysql -u root -ppassword -D mydatabase < sql/metadata_lock2/long_query_on_issue.sql
```

#### セッション2：DDL操作の試行

セッション1のトランザクションがまだ実行中である間に、2番目のセッションで `project` テーブルにカラムを追加するDDL操作を試みます。これは、セッション1が完了するまでハングします。

```bash
mysql -h mysql -u root -ppassword -D mydatabase < sql/metadata_lock2/alter_project_table.sql
```

#### セッション3：SELECTクエリの実行

セッション2の`ALTER TABLE`が待機状態にある間に、3番目のセッションで`project`テーブルに対して`SELECT`クエリを実行します。

```bash
SOURCE /workspace/sql/metadata_lock2/select_from_project.sql;
```

### 予想される結果

-   **セッション2の `ALTER TABLE` ステートメントは、セッション1が完了するまでハングします。** これはシナリオ1と同じです。
-   **セッション3の `SELECT` ステートメントもハングします。** これは、セッション2の`ALTER TABLE`（DDL操作）がキューで待機しているため、後続の`SELECT`（DML操作）がブロックされるためです。MySQLでは、ペンディング中のDDL操作は、後から来たDML操作よりも高い優先度を持ちます。
-   セッション1のクエリが完了すると、まずセッション2の`ALTER TABLE`が実行され、その後にセッション3の`SELECT`が実行されます。

### なぜこうなるのか？

MySQLは、メタデータロックを要求する操作をキューに入れます。DDL操作（`ALTER TABLE`など）がキューで待機している場合、そのテーブルに対する後続のクエリ（`SELECT`、`INSERT`など）は、DDL操作が完了するまで待たなければなりません。これにより、スキーマの変更中にデータの一貫性が保たれます。しかし、これが原因で、長時間実行されるクエリが1つあるだけで、多くのクエリが連鎖的に待たされる「クエリの雪崩」が発生する可能性があります。
