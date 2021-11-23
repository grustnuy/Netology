1.������� � sparse (�����������) ������.

2.����� �� �����, ���������� ������� ������� �� ���� ������, ����� ������ ����� ������� � ���������? ������?
�������. ����� ��������� �� �������� �������.
������ ����� ����� ������ �� Simlink.

3.�������� vagrant destroy �� ��������� ������� Ubuntu. �������� ���������� Vagrantfile ���������:

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

4.��������� fdisk, �������� ������ ���� �� 2 �������: 2 ��, ���������� ������������.

5.��������� sfdisk, ���������� ������ ������� �������� �� ������ ����.

6.�������� mdadm RAID1 �� ���� �������� 2 ��.

7.�������� mdadm RAID0 �� ������ ���� ��������� ��������.



8.�������� 2 ����������� PV �� ������������ md-�����������.



9.�������� ����� volume-group �� ���� ���� PV.

10.�������� LV �������� 100 ��, ������ ��� ������������ �� PV � RAID0.

11.�������� mkfs.ext4 �� �� ������������ LV.

12.����������� ���� ������ � ����� ����������, ��������, /tmp/new.

13.��������� ���� �������� ����, �������� wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

14.���������� ����� lsblk.

15.������������� ����������� �����:

root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
16.��������� pvmove, ����������� ���������� PV � RAID0 �� RAID1.

17.�������� --fail �� ���������� � ����� RAID1 md.

18.����������� ������� dmesg, ��� RAID1 �������� � ��������������� ���������.

19.������������� ����������� �����, �������� �� "�������" ���� �� ������ ���������� ���� ��������:

root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
20.�������� �������� ����, vagrant destroy.