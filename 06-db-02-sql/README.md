# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
```
version: '3.7'

volumes:
    data: 
    backup: 

services:

  postgres:
    container_name: pg12
    image: postgres:12
    environment:
      POSTGRES_USER: "test-admin-user"
      POSTGRES_PASSWORD: "pass"
      POSTGRES_DB: "test_db"
    ports:
      - "0.0.0.0:5432:5432"
    volumes:
      - ~/docker/volumes/postgres/data:/var/lib/postgresql/data
      - ~/docker/volumes/postgres/backup:/media/postgresql/backup
    
    restart: always


root@6897de424983:/# psql -U test-admin-user test_db
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

test_db=# \l
```
## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)
```
CREATE TABLE orders (id INT PRIMARY KEY, title VARCHAR(255), cost INT NOT NULL);
CREATE TABLE clients (id SERIAL PRIMARY KEY, last_name VARCHAR(50), country VARCHAR(50), order_id INT REFERENCES orders(id) ON DELETE CASCADE);
```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
~~~
GRANT CONNECT ON DATABASE test_db to "test-admin-user";
GRANT ALL ON ALL TABLES IN SCHEMA public to "test-admin-user";
~~~
- создайте пользователя test-simple-user  
```
CREATE USER "test-simple-user" WITH PASSWORD 'test';
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```
GRANT CONNECT ON DATABASE test_db TO "test-simple-user";
GRANT USAGE ON SCHEMA public TO "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public to "test-simple-user";
```


Приведите:
- итоговый список БД после выполнения пунктов выше,

```
test_db=# \l
                                             List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges
-----------+-----------------+----------+------------+------------+-----------------------------------------
 postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/"test-admin-user"                  +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"+
           |                 |          |            |            | "test-simple-user"=c/"test-admin-user"
(4 rows)
```

- описание таблиц (describe)

```
test_db=# \d+ clients
                                                         Table "public.clients"
  Column   |         Type          | Collation | Nullable |               Default               | Storage  | Stats target | D
escription
-----------+-----------------------+-----------+----------+-------------------------------------+----------+--------------+--
-----------
 id        | integer               |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 last_name | character varying(50) |           |          |                                     | extended |              |
 country   | character varying(50) |           |          |                                     | extended |              |
 order_id  | integer               |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
Access method: heap

test_db=# \d+ orders
                                          Table "public.orders"
 Column |          Type          | Collation | Nullable | Default | Storage  | Stats target | Description
--------+------------------------+-----------+----------+---------+----------+--------------+-------------
 id     | integer                |           | not null |         | plain    |              |
 title  | character varying(255) |           |          |         | extended |              |
 cost   | integer                |           | not null |         | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
Access method: heap
```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
SELECT * FROM information_schema.table_privileges WHERE table_catalog = 'test_db' AND grantee LIKE 'test-%';
```
- список пользователей с правами над таблицами test_db
```
test_db=# SELECT * FROM information_schema.table_privileges WHERE table_catalog = 'test_db' AND grantee LIKE 'test-%';
     grantor     |     grantee      | table_catalog |    table_schema    |              table_name               | privilege_type | is_grantable | with_hierarchy
-----------------+------------------+---------------+--------------------+---------------------------------------+----------------+--------------+----------------
 test-admin-user | test-admin-user  | test_db       | public             | orders                                | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | orders                                | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | public             | orders                                | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | orders                                | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | orders                                | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | orders                                | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | orders                                | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | clients                               | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | clients                               | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | public             | clients                               | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | clients                               | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | clients                               | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | clients                               | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public             | clients                               | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic                          | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic                          | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic                          | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic                          | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic                          | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic                          | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic                          | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_type                               | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_type                               | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_type                               | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_type                               | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_type                               | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_type                               | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_type                               | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_foreign_server                     | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_foreign_server                     | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_foreign_server                     | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_foreign_server                     | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_foreign_server                     | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_foreign_server                     | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_foreign_server                     | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_authid                             | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_authid                             | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_authid                             | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_authid                             | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_authid                             | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_authid                             | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_authid                             | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_shadow                             | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_shadow                             | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_shadow                             | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_shadow                             | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_shadow                             | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_shadow                             | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_shadow                             | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic_ext_data                 | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic_ext_data                 | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic_ext_data                 | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic_ext_data                 | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic_ext_data                 | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic_ext_data                 | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_statistic_ext_data                 | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_roles                              | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_roles                              | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_roles                              | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | pg_catalog         | pg_roles                              | DELETE         | YES          | NO
--More--

```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```
test_db=# INSERT INTO orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# SELECT * FROM orders;
 id |  title  | cost
----+---------+------
  1 | Шоколад |   10
  2 | Принтер | 3000
  3 | Книга   |  500
  4 | Монитор | 7000
  5 | Гитара  | 4000
(5 rows)

test_db=# INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# SELECT * FROM clients;
 id |      last_name       | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)

test_db=#
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 ```
UPDATE clients SET order_id = 3 WHERE last_name = 'Иванов Иван Иванович';
UPDATE 1
UPDATE clients SET order_id = 4 WHERE last_name = 'Петров Петр Петрович';
UPDATE 1
UPDATE clients SET order_id = 5 WHERE last_name = 'Иоганн Себастьян Бах';
UPDATE 1
SELECT c.id, c.last_name, c.country, o.title FROM clients AS c INNER JOIN orders AS o ON o.id = c.order_id;
 id |      last_name       | country |  title
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     | Книга
  2 | Петров Петр Петрович | Canada  | Монитор
  3 | Иоганн Себастьян Бах | Japan   | Гитара
(3 rows)
```
## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# EXPLAIN SELECT c.id, c.last_name, c.country, o.title FROM clients AS c INNER JOIN orders AS o ON o.id = c.order_id;                               
							QUERY PLAN
-------------------------------------------------------------------------
 Hash Join  (cost=13.15..26.96 rows=300 width=756)
   Hash Cond: (c.order_id = o.id)
   ->  Seq Scan on clients c  (cost=0.00..13.00 rows=300 width=244)
   ->  Hash  (cost=11.40..11.40 rows=140 width=520)
         ->  Seq Scan on orders o  (cost=0.00..11.40 rows=140 width=520)
(5 rows)
```
EXPLAIN - выводит план построения запроса. 

 - время которое пройдет прежде чем начнется вывод данных, приблизительная стоимость запуска;
 - расчетное время которое понадобится на вывод всех данных, приблизительная общая стоимость;
 - Ожидаемое число строк;
 - Ожидамый средний размер строк в байтах.
 
 
## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
```
root@6897de424983:/# pg_dumpall -U test-admin-user > /media/postgresql/backup/test_db.sql

vagrant@server1:~/virt-homeworks/06-db-02-sql/docker$ docker-compose stop
Stopping psql ... done
vagrant@server1:~/SQL$ docker ps -a

vagrant@server1:~/virt-homeworks/06-db-02-sql/docker$ docker run --rm -d -e POSTGRES_USER=test-admin-user -e POSTGRES_PASSWORD=test -e POSTGRES_DB=test_db -v ~/docker/volumes/postgres/backup:/media/postgresql/backup --name pg12-2 postgres:12
0c6f4be19d33cfe470db2619dc9256e8d88e2cb70f5e9ff7fa60304de8ba8702

vagrant@server1:~/virt-homeworks/06-db-02-sql/docker$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                      PORTS      NAMES
0c6f4be19d33   postgres:12   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes                5432/tcp   pg12-2
6897de424983   postgres:12   "docker-entrypoint.s…"   23 hours ago    Exited (0) 37 seconds ago              pg12


root@0c6f4be19d33:/# psql -U test-admin-user -f /media/postgresql/backup/test_db.sql test_db

root@0c6f4be19d33:/# psql -U test-admin-user test_db
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

test_db=# \d
                  List of relations
 Schema |      Name      |   Type   |      Owner
--------+----------------+----------+-----------------
 public | clients        | table    | test-admin-user
 public | clients_id_seq | sequence | test-admin-user
 public | orders         | table    | test-admin-user
(3 rows)
```
