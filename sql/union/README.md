## UNION とは
UNIONは、複数のSELECT文の結果を一つにまとめるためのSQL演算子です。これにより、複数のクエリの結果をまるで一つのテーブルのように扱うことができます。

### UNIONを使うには、以下の2つのルールを守る必要があります。

1. 列数の一致: 結合するすべてのSELECT文で、列の数が同じでなければなりません。

2. データ型の一致: 対応する列のデータ型が同じ、または互換性のあるものでなければなりません。

    例えば、SELECT columnA, columnB と SELECT columnC, columnD をUNIONで結合することはできません。しかし、SELECT name, email と SELECT contact_name, contact_email は結合できます。