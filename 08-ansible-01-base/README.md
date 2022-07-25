# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************ok: [localhost]

TASK [Print OS] ************************************************************************************************************************************************************************************************ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *****************************************************************************************************************************************************************************************************localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
`some_fact: 12`

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ cat group_vars/all/examp.yml 
---
  some_fact: all default fact
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml 

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ cat group_vars/deb/examp.yml ;echo ""
---
  some_fact: "deb default fact"
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ cat group_vars/el/examp.yml ;echo ""
---
  some_fact: "el default fact"
```  
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ cat group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
65356639313130633934346230346665323864633862313637346361353064303832303638393161
6632613033303762626531386165363238383231663464640a363737633736333732343037373738
65393531396139316263616439636532313865313763623430666332343865393761373666356465
3563396537376531320a383764316463326635643235313239626561393665613766373966343038
36326438653239316631306332323663653035653662373936643866343531333932656332653538
3838366237393039613161323638613532376665316564353236
grustnuy@DESKTOP-M9GD4QV:/mnt/f/Skills/Netology/DZ/08-ansible-01-base/playbook$ cat group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
38393064343633373561653531663937326466653262626439663461653762396164333661336439
6363396533613539333135303737306636366536326132350a663661643233306561636232393365
33363331343536336137303937343863666430633566373163313736656330373966613437383536
3038643937323238640a366136633161373761653939343264333361333131636665306264313936
32663765323635373032643262356638303337633338316636636135376532633438393061626562
3766633336376266653734666363356465393661633566386663
```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

	PLAY [Print os facts] **********************************************************************************************************************

	TASK [Gathering Facts] *********************************************************************************************************************
	ok: [ubuntu]
	ok: [centos7]

	TASK [Print OS] ****************************************************************************************************************************
	ok: [centos7] => {
	    "msg": "CentOS"
	}
	ok: [ubuntu] => {
	    "msg": "Ubuntu"
	}

	TASK [Print fact] **************************************************************************************************************************
	ok: [centos7] => {
	    "msg": "el default fact"
	}
	ok: [ubuntu] => {
	    "msg": "deb default fact"
	}

	PLAY RECAP *********************************************************************************************************************************
	centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
  ```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ ansible-doc --type=connection -l | grep "execute on controller"
local                          execute on controller
```
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ cat inventory/prod.yml ; echo ""
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
     hosts:
       localhost:
          ansible_connection: local
```         
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```
grustnuy@ubuntu:~/08-ansible-01-base/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
	Vault password: 

	PLAY [Print os facts] *********************************************************************************************************

	TASK [Gathering Facts] ********************************************************************************************************
	ok: [localhost]
	ok: [ubuntu]
	ok: [centos7]

	TASK [Print OS] ***************************************************************************************************************
	ok: [centos7] => {
	    "msg": "CentOS"
	}
	ok: [ubuntu] => {
	    "msg": "Ubuntu"
	}
	ok: [localhost] => {
	    "msg": "Ubuntu"
	}

	TASK [Print fact] *************************************************************************************************************
	ok: [centos7] => {
	    "msg": "el default fact"
	}
	ok: [ubuntu] => {
	    "msg": "deb default fact"
	}
	ok: [localhost] => {
	    "msg": "all default fact"
	}

	PLAY RECAP ********************************************************************************************************************
	centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
	ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
  ```

