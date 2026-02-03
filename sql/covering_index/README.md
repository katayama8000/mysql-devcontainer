# Covering Index（カバリングインデックス）

## 概要

カバリングインデックスとは、クエリで必要とするすべてのカラムがインデックスに含まれている状態のことです。この場合、MySQLはインデックスだけでクエリを処理でき、テーブルデータにアクセスする必要がないため、パフォーマンスが向上します。

## 実行方法

```bash
# MySQLコンテナに接続
./connect_to_mysql.sh

# SQLファイルを実行
SOURCE /workspace/sql/covering_index/covering_index_example.sql;
```

## カバリングインデックスの識別方法

`EXPLAIN`の結果で`Extra`カラムに`Using index`と表示される場合、カバリングインデックスが使用されています。

## ケース

### ✅ カバリングインデックスが効く例
- `SELECT id, email, age FROM users WHERE email = 'xxx'`
  - インデックス`(email, age)`が存在する場合
  - 必要なカラム（id, email, age）がすべてインデックスに含まれている

### ❌ カバリングインデックスが効かない例
- `SELECT id, email, age, name FROM users WHERE email = 'xxx'`
  - インデックス`(email, age)`が存在する場合
  - `name`カラムがインデックスに含まれていないため、テーブルアクセスが必要

## パフォーマンスへの影響

カバリングインデックスを使用すると：
- ディスクI/Oが削減される
- クエリ実行速度が向上する
- バッファプールの効率が上がる
