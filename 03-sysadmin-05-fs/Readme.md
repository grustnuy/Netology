1. __Узнайте о sparse (разряженных) файлах.__ 
		Ознакомился.

2. __Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?__
		Немогут. Hardlink имеют один и тотже Inode и фактически являються идентичнымы объектами файловой системы. 

3. __Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:__

		Vagrant.configure("2") do |config| 
		  config.vm.box = "bento/ubuntu-20.04" 
		  config.vm.provider :virtualbox do |vb| 
			lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk" 
			lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk" 
			vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560] 
			vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
			vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
			vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
		  end
		end
		Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб. 
		
	![3](Img/3.JPG)
		
		
4.  __Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.__
	![4](Img/4.JPG)
5.	__Используя sfdisk, перенесите данную таблицу разделов на второй диск.__
	![5](Img/5.JPG)
6.	__Соберите mdadm RAID1 на паре разделов 2 Гб.__

	![6](Img/6.JPG)
7.	__Соберите mdadm RAID0 на второй паре маленьких разделов.__
8.	
	![7](Img/7.JPG)
8.	__Создайте 2 независимых PV на получившихся md-устройствах.__

	![8](Img/8.JPG)
9.	__Создайте общую volume-group на этих двух PV.__

	![9_1](Img/9_1.JPG)
	![9_2](Img/9_2.JPG)
10.	__Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.__
	![10](Img/10.JPG)
11.	__Создайте mkfs.ext4 ФС на получившемся LV.__

	![11](Img/11.JPG)
12.	__Смонтируйте этот раздел в любую директорию, например, /tmp/new.__
	![12](Img/12.JPG)
13.	__Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz__

	![13](Img/13.JPG)
14.	__Прикрепите вывод lsblk.__

	![14](Img/14.JPG)
15.	__Протестируйте целостность файла:__
		__root@vagrant:~# gzip -t /tmp/new/test.gz__
		__root@vagrant:~# echo $?__
		__0__
	![15](Img/15.JPG)
16.	__Используя pvmove, переместите содержимое PV с RAID0 на RAID1.__
	![16](Img/6.JPG)
17.	__Сделайте --fail на устройство в вашем RAID1 md.__

	![17](Img/17.JPG)
18.	__Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.__
	![18](Img/18.JPG)
19.	__Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:__
		__root@vagrant:~# gzip -t /tmp/new/test.gz__
		__root@vagrant:~# echo $?__
		__0__
		
	![19](Img/19.JPG)
20.	__Погасите тестовый хост, vagrant destroy.__
