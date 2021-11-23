1. __������� � sparse (�����������) ������.__

2. __����� �� �����, ���������� ������� ������� �� ���� ������, ����� ������ ����� ������� � ���������? ������?__
		�������. ����� ��������� �� �������� �������. ������ ����� ����� ������ �� Simlink.

3. __�������� vagrant destroy �� ��������� ������� Ubuntu. �������� ���������� Vagrantfile ���������:__
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
		������ ������������ ������� ����� ����������� ������ � ����� ��������������� �������������� ������� �� 2.5 ��.
		![3](img/3.JPG)
4.  __��������� fdisk, �������� ������ ���� �� 2 �������: 2 ��, ���������� ������������.__
		![4](img/4.JPG)
5.	__��������� sfdisk, ���������� ������ ������� �������� �� ������ ����.__
		![5](img/5.JPG)
6.	__�������� mdadm RAID1 �� ���� �������� 2 ��.__
		![6](img/6.JPG)
7.	__�������� mdadm RAID0 �� ������ ���� ��������� ��������.__
		![7](img/7.JPG)
8.	__�������� 2 ����������� PV �� ������������ md-�����������.__
		![8](img/8.JPG)
9.	__�������� ����� volume-group �� ���� ���� PV.__
		![9_1](img/9_1.JPG)
		![9_2](img/9_2.JPG)
10.	__�������� LV �������� 100 ��, ������ ��� ������������ �� PV � RAID0.__
		![10](img/10.JPG)
11.	__�������� mkfs.ext4 �� �� ������������ LV.__
		![11](img/11.JPG)
12.	__����������� ���� ������ � ����� ����������, ��������, /tmp/new.__
		![12](img/12.JPG)
13.	__��������� ���� �������� ����, �������� wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz__
		![13](img/13.JPG)
14.	__���������� ����� lsblk.__
		![14](img/14.JPG)
15.	__������������� ����������� �����:__
		__root@vagrant:~# gzip -t /tmp/new/test.gz__
		__root@vagrant:~# echo $?__
		__0__
		![15](img/15.JPG)
16.	__��������� pvmove, ����������� ���������� PV � RAID0 �� RAID1.__
		![16](img/6.JPG)
17.	__�������� --fail �� ���������� � ����� RAID1 md.__
		![17](img/17.JPG)
18.	__����������� ������� dmesg, ��� RAID1 �������� � ��������������� ���������.__
		![18](img/18.JPG)
19.	__������������� ����������� �����, �������� �� "�������" ���� �� ������ ���������� ���� ��������:__
		__root@vagrant:~# gzip -t /tmp/new/test.gz__
		__root@vagrant:~# echo $?__
		__0__
		![19](img/19.JPG)
20.	__�������� �������� ����, vagrant destroy.__
