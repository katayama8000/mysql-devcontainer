# Buffer Pool Example

This example demonstrates the effect of the InnoDB Buffer Pool in MySQL.

## How it works

The buffer pool is a memory area where InnoDB caches table and index data. When you query data, InnoDB fetches it from disk and stores it in the buffer pool. If you query the same data again, InnoDB can read it directly from memory, which is much faster than reading from disk.

This example does the following:

1.  Creates a table with a large number of records (100,000).
2.  Resets the status counters.
3.  Executes a `SELECT` query for the first time. At this point, the data is read from the disk and loaded into the buffer pool.
4.  Shows the `Innodb_buffer_pool_reads` status, which indicates how many data reads were served from disk.
5.  Executes the _same_ `SELECT` query a second time.
6.  Shows the `Innodb_buffer_pool_reads` status again.

## What to observe

When you run the `buffer_pool_example.sql` script, pay attention to the output of `SHOW STATUS LIKE 'Innodb_buffer_pool_read%'` after each query.

- **After the first query:** You will see a certain number for `Innodb_buffer_pool_reads`. This represents the data pages read from disk.
- **After the second query:** The value of `Innodb_buffer_pool_reads` should be the same or only slightly higher. This is because the data was already in the buffer pool, and MySQL didn't need to read it from disk again. You will see that `Innodb_buffer_pool_read_requests` increases, showing that the query was served from memory.

This demonstrates that the buffer pool is effectively caching the data.

## How to run

SOURCE /workspace/sql/buffer_pool/buffer_pool_example.sql

## Status Variables

| 変数名                           | 説明                                                                                                                                                                                            |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Innodb_buffer_pool_read_requests | （合計）読み取り要求数 ∑ アプリケーションやクエリが、バッファプールに対してデータを要求した回数の合計。このページは、メモリ（バッファプール）からもディスクからも読み取られる可能性があります。 |
| Innodb_buffer_pool_reads         | ディスク I/O が発生した読み取り数 D データがバッファプールに見つからず（キャッシュミス）、ディスクから物理的に読み取る必要があった回数の合計。真のディスク I/O の発生回数です。                 |
