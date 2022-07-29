# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

```
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: <host_ip>
      ansible_connection: ssh
      ansible_ssh_user: grustnuy
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

```
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Flush handlers
      ansible.builtin.meta: flush_handlers   
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0

- name: Install vector
  hosts: clickhouse
  handlers:
    - name: restart vector service
      become: true
      ansible.builtin.service:
         name: vector
         state: restarted
  tasks:
    - name: get vector distrib
      ansible.builtin.get_url:
        url: "{{ vector_url }}"
        dest: ./vector.rpm
      tags:
         - download
    - name: install vector packages
      become: true
      ansible.builtin.yum:
        name:
         - vector.rpm
      notify: restart vector service
      tags:
         - install
```		 
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
grustnuy@DESKTOP-M9GD4QV:/mnt/f/Skills/Netology/DZ/08-ansible-02-playbook/playbook$ ansible-lint site.yml inventory/prod.yml
[201] Trailing whitespace
site.yml:40
      become: true 

[206] Variables should have spaces before and after: {{ var_name }}
site.yml:47
        url: "{{vector_url}}"

[201] Trailing whitespace
site.yml:49
      tags: 

[201] Trailing whitespace
site.yml:50
        - download 

[201] Trailing whitespace
site.yml:57
      tags: 
```
Исправил ошибки.	  
```
grustnuy@DESKTOP-M9GD4QV:/mnt/f/Skills/Netology/DZ/08-ansible-02-playbook/playbook$ ansible-lint site.yml inventory/prod.yml 
grustnuy@DESKTOP-M9GD4QV:/mnt/f/Skills/Netology/DZ/08-ansible-02-playbook/playbook$ 

```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```
rustnuy@DESKTOP-M9GD4QV:/mnt/f/Skills/Netology/DZ/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --check

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", 
"msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************changed: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP *****************************************************************************************************************************************************************************************************clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```
grustnuy@DESKTOP-M9GD4QV:/mnt/f/Skills/Netology/DZ/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", 
"msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************changed: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************changed: [clickhouse-01]

TASK [Flush handlers] ******************************************************************************************************************************************************************************************
RUNNING HANDLER [Start clickhouse service] *********************************************************************************************************************************************************************changed: [clickhouse-01]

TASK [Create database] *****************************************************************************************************************************************************************************************changed: [clickhouse-01]

PLAY [Install vector] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************ok: [clickhouse-01]

TASK [get vector distrib] **************************************************************************************************************************************************************************************changed: [clickhouse-01]

TASK [install vector packages] *********************************************************************************************************************************************************************************changed: [clickhouse-01]

RUNNING HANDLER [restart vector service] ***********************************************************************************************************************************************************************changed: [clickhouse-01]

PLAY RECAP *****************************************************************************************************************************************************************************************************clickhouse-01              : ok=9    changed=7    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```
grustnuy@DESKTOP-M9GD4QV:/mnt/f/Skills/Netology/DZ/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "grustnuy", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "grustnuy", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************ok: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************ok: [clickhouse-01]

TASK [Flush handlers] ******************************************************************************************************************************************************************************************
TASK [Create database] *****************************************************************************************************************************************************************************************ok: [clickhouse-01]

PLAY [Install vector] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************ok: [clickhouse-01]

TASK [get vector distrib] **************************************************************************************************************************************************************************************ok: [clickhouse-01]

TASK [install vector packages] *********************************************************************************************************************************************************************************ok: [clickhouse-01]

PLAY RECAP *****************************************************************************************************************************************************************************************************clickhouse-01              : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
```

