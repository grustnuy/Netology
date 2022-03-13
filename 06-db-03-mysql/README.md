# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

```
vagrant@server1:~$docker run --rm --name mysql -d -e MYSQL_ROOT_PASSWORD=pass -ti -p 3306:3306 -v /opt/data/mysql/:/var/lib/mysql mysql:8.0
vagrant@server1:~$docker exec -it mysql bash
root@778f82f677f6:/#mysql -u root -p

mysql> CREATE DATABASE test_db DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
root@778f82f677f6:/# mysql -p test_db < /var/lib/mysql/test_dump.sql
```


Перейдите в управляющую консоль `mysql` внутри контейнера.
Используя команду `\h` получите список управляющих команд.
Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
```
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          21
Current database:       test_db
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.28 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 1 hour 9 min 19 sec

Threads: 2  Questions: 47  Slow queries: 0  Opens: 165  Flush tables: 4  Open tables: 47  Queries per second avg: 0.011
--------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.
**Приведите в ответе** количество записей с `price` > 300.

```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)
mysql> use test_db
Database changed

mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select count(*) from orders where price >300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```
mysql> CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';
Query OK, 0 rows affected (0.03 sec)

mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.00 sec)

mysql> ALTER USER 'test'@'localhost' IDENTIFIED BY 'test-pass' WITH MAX_QUERIES_PER_HOUR 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT Select ON test_db.orders TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.01 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

```
mysql> set profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profiles;
+----------+------------+-----------------+
| Query_ID | Duration   | Query           |
+----------+------------+-----------------+
|        1 | 0.00011200 | set profiling=1 |
+----------+------------+-----------------+
1 row in set, 1 warning (0.00 sec)
```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```
mysql> SELECT TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH,INDEX_LENGTH FROM INFORMATION_SCHEMA.TABLES WHERE t
able_name = 'orders' and  TABLE_SCHEMA = 'test_db' ORDER BY ENGINE asc;
+------------+--------+------------+------------+-------------+--------------+
| TABLE_NAME | ENGINE | ROW_FORMAT | TABLE_ROWS | DATA_LENGTH | INDEX_LENGTH |
+------------+--------+------------+------------+-------------+--------------+
| orders     | InnoDB | Dynamic    |          5 |       16384 |            0 |
+------------+--------+------------+------------+-------------+--------------+
1 row in set (0.00 sec)
```
Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```
mysql>  ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.05 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.05 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.00011200 | set profiling=1                    |
|        2 | 0.05281250 | ALTER TABLE orders ENGINE = MyISAM |
|        3 | 0.05432275 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
3 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

#Set IO Speed
# 0 - скорость
# 1 - сохранность
# 2 - универсальный параметр
innodb_flush_log_at_trx_commit = 0

#Set compression
# Barracuda - формат файла с сжатием
innodb_file_format=Barracuda

#Set buffer
innodb_log_buffer_size  = 1M

#Set Cache size
key_buffer_size = 300М

#Set log size
max_binlog_size = 100M
```

