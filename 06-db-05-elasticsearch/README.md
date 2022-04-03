# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста

```
FROM centos:7
   
ENV ES_USER="elastic"
ENV ES_HOME="/opt/elasticsearch/elasticsearch-8.1.0"
ENV ES_DATA="/var/lib/elasticsearch"
ENV ES_LOG="/var/log/elasticsearch"
ENV ES_BACKUP="/opt/backups"

WORKDIR /opt/elasticsearch

RUN yum install wget -y && \
    yum install perl-Digest-SHA -y && \
    wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz && \
    wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.1.0-linux-x86_64.tar.gz && \
    rm -f elasticsearch-8.1.0-linux-x86_64.tar.gz && \
    cd elasticsearch-8.1.0/ && \
    yum autoremove -y && \
    yum clean all -y
  
COPY elasticsearch.yml ${ES_HOME}/config/elasticsearch.yml

RUN useradd "${ES_USER}" && \
    mkdir -p "${ES_DATA}" && \
    mkdir -p "${ES_LOG}" && \
    mkdir -p "${ES_BACKUP}" && \
    chown -R ${ES_USER}: /opt/elasticsearch && \
    chown -R ${ES_USER}: "${ES_DATA}" && \
    chown -R ${ES_USER}: "${ES_LOG}" && \
    chown -R ${ES_USER}: "${ES_BACKUP}"

USER ${ES_USER}

WORKDIR "${ES_HOME}"
 
EXPOSE 9200
EXPOSE 9300    
    
CMD ["./bin/elasticsearch"]
```
`elasticsearch.yml`:

```
node.name: netology_test
network.host: localhost
path:
  data: /var/lib/elasticsearch
  logs: /var/log/elasticsearch
  repo: /opt/backups
xpack.security.enabled: false  
xpack.security.http.ssl:
  enabled: false
http.host: [_local_, _site_]   
```  

- [Образ в репозитории dockerhub](https://hub.docker.com/layers/200834262/grustnuy/image/elasticsearch/images/sha256-b007985552fae4c0a3dc350284ded6a9d0c3c1fd9e97e9ba6317258365ff13c1?context=repo)

- ответ `elasticsearch` на запрос пути `/` в json виде

```
docker run --name elk -d -p 9200:9200 -p 9300:9300 grustnuy/elasticsearch:1.0.0
grustnuy@ubuntu:~$ curl localhost:9200 /
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "9KV6w8yWQe2RxDnDmqbq3g",
  "version" : {
    "number" : "8.1.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "3700f7679f7d95e36da0b43762189bab189bc53a",
    "build_date" : "2022-03-03T14:20:00.690422633Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
curl: (3) URL using bad/illegal format or missing URL
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |


```
curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}' 
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```
grustnuy@ubuntu:~$ curl -X GET "localhost:9200/_cat/indices"
green  open ind-1 Meq2u5X8SI6dupdjal0FgA 1 0 0 0 225b 225b
yellow open ind-3 rq1MQ7EoRNGF3KnXkUz2tg 4 2 0 0 900b 900b
yellow open ind-2 eULtdHUyR6mcbM1cILhDsg 2 1 0 0 450b 450b
```

Получите состояние кластера `elasticsearch`, используя API.

```
grustnuy@ubuntu:~$ curl -X GET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

- Неверный расчет количества шардов и реплик. Количество неназначенных шард больше ноля.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.


Удалите все индексы.
```
grustnuy@ubuntu:~$ curl -X DELETE 'http://localhost:9200/ind-1'
{"acknowledged":true}
grustnuy@ubuntu:~$ curl -X DELETE 'http://localhost:9200/ind-2'
{"acknowledged":true}
grustnuy@ubuntu:~$ curl -X DELETE 'http://localhost:9200/ind-3'
```

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

```
grustnuy@ubuntu:~$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d' { "type": "fs",   "settings": { "location": "/opt/backups" } }'
{
  "acknowledged" : true
}
```
**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```
grustnuy@ubuntu:~$ curl -X GET "localhost:9200/_snapshot/netology_backup?pretty"
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/opt/backups"
    }
  }
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```
grustnuy@ubuntu:~$ curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 } } }'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```
grustnuy@ubuntu:~$ curl -X PUT "localhost:9200/_snapshot/netology_backup/netology_snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "netology_snapshot_1",
    "uuid" : "xRevGNlhQOeeo6W4PWuGoQ",
    "repository" : "netology_backup",
    "version_id" : 8010099,
    "version" : "8.1.0",
    "indices" : [
      ".geoip_databases",
      "test"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-04-02T22:41:11.114Z",
    "start_time_in_millis" : 1648939271114,
    "end_time" : "2022-04-02T22:41:12.116Z",
    "end_time_in_millis" : 1648939272116,
    "duration_in_millis" : 1002,
    "failures" : [ ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```
[elastic@7ac733499a4f backups]$ pwd
/opt/backups
[elastic@7ac733499a4f backups]$ ll
total 36
-rw-r--r-- 1 elastic elastic   852 Apr  2 22:41 index-0
-rw-r--r-- 1 elastic elastic     8 Apr  2 22:41 index.latest
drwxr-xr-x 4 elastic elastic  4096 Apr  2 22:41 indices
-rw-r--r-- 1 elastic elastic 18349 Apr  2 22:41 meta-xRevGNlhQOeeo6W4PWuGoQ.dat
-rw-r--r-- 1 elastic elastic   360 Apr  2 22:41 snap-xRevGNlhQOeeo6W4PWuGoQ.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
 curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}

grustnuy@ubuntu:~$ curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 } } }'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

grustnuy@ubuntu:~$ curl -X GET "localhost:9200/_cat/indices"
green open test-2 QMT3f7SiSuSYRxHweXgEdA 1 0 0 0 225b 225b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```
grustnuy@ubuntu:~$ curl -X POST "localhost:9200/_snapshot/netology_backup/netology_snapshot_1/_restore?pretty"
{
  "accepted" : true
}
grustnuy@ubuntu:~$ curl -X GET "localhost:9200/_cat/indices"
green open test-2 QMT3f7SiSuSYRxHweXgEdA 1 0 0 0 225b 225b
green open test   cMAnPoukRo-Rvdo0QIinIw 1 0 0 0 225b 225b
grustnuy@ubuntu:~$
```


Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`


