##Playbook устанавливает
 - Clickhouse 
 - Vector
 
 ## Параметры
 В `group_vars` находяться переменные версий ПО. 
 
 - [Clickhouse](playbook/group_vars/clickhouse/vars.yml) передаеться желаемая версия и перчень компонентов `clickhouse`.
 - [Vector](playbook/group_vars/vector/vars.yml) передаеться ссылка на необходимую версия deb пакета `Vector`.
 
 ##Запуск
 Для запуска используться `ansible-playbook site.yml -i inventory/prod.yml`
 
 ##Зависимости 
 Нет.
 
 ## Тэги
 В `playbook` присутсвуют теги на скачивание `download` и установку `install` Vector. Для запуска по тегам необходимо передать параметр `--tags название тэга`
Пример: `ansible-playbook site.yml -i inventory/prod.yml --tags download`
 
 ##Информация об авторе
 Этот playbook подготовлен в 2022 году в рамках выполнения домашнего задания. 