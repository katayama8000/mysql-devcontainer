# メタデータロックの例

このディレクトリには、MySQLのメタデータロックを実演するためのSQLファイルが含まれています。

`metadata_lock_example.sql`: このスクリプトは、長時間実行されるトランザクションがテーブル上のDDL操作を妨げ、メタデータロックにつながる方法を示しています。

メタデータロックを観察するには：
1. MySQLクライアントを開き、トランザクション内で以下を実行します：
   ```sql
   START TRANSACTION;
   SELECT * FROM my_table WHERE id = 1;
   -- まだコミットもロールバックもしないでください
   ```
2. *別の*MySQLクライアントセッションで、`metadata_lock_example.sql`の`ALTER TABLE`ステートメントを実行してみてください：
   ```sql
   ALTER TABLE my_table ADD COLUMN new_column VARCHAR(255);
   ```
   この`ALTER TABLE`ステートメントは、最初のトランザクションがコミットまたはロールバックされるまでハングします。

3. 最初のセッションに戻り、トランザクションをコミットします：
   ```sql
   COMMIT;
   ```
   これで、2番目のセッションの`ALTER TABLE`が完了するはずです。