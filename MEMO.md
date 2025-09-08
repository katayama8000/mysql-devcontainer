```sql
mysql -h mysql -u root -ppassword -e "USE mydatabase; EXPLAIN SELECT * FROM users WHERE age = 30;"
```
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | users | NULL       | ALL  | NULL          | NULL | NULL    | NULL |  104 |    10.00 | Using where |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+

Add index on age column
```sql
mysql -h mysql -u root -ppassword -e "USE mydatabase; CREATE INDEX idx_age ON users(age);"
```

Check the query plan again
```sql
mysql -h mysql -u root -ppassword -e "USE mydatabase; EXPLAIN SELECT * FROM users WHERE age = 30;"
```
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | users | NULL       | ref  | idx_age       | idx_age | 5       | const |   11 |   100.00 | NULL  |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+

check age index
```sql
mysql -h mysql -u root -ppassword -e "USE mydatabase; SHOW INDEX FROM users WHERE Key_name = 'idx_age';"
```