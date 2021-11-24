1. __���������� �������� ������������� Oracle VirtualBox.__
	���������
2. __���������� �������� ������������� Hashicorp Vagrant.__
	���������
3. __� ����� �������� ��������� ����������� ������� ��� ���������� ������ ��������.__
	���������
4. __� ������� �������� ����� ������������ ��������� Ubuntu 20.04 � VirtualBox ����������� Vagrant.__
	
	![4](img/4.JPG)
5. __������������ � ����������� ����������� VirtualBox, ���������� ��� �������� ����������� ������, ������� ������ ��� ��� Vagrant,
 ����� ���������� ������� �� ��������. ����� ������� �������� ��-���������?__
	
		![5](img/5.JPG)

6. __������������ � ������������� ������������ VirtualBox ����� Vagrantfile: ������������. ��� �������� ����������� ������ ��� ��������
 ���������� ����������� ������?__

		config.vm.provider "virtualbox" do |vb|
		  vb.memory = 1024
		  vb.cpus = 2
		end

7. ������� vagrant ssh �� ����������, � ������� ���������� Vagrantfile, �������� ��� ��������� ������ ����������� ������ ��� �����-���� �������������� ��������. ��������������� � ���������� ����������� ������ � ��������� Ubuntu.
	![7](img/7.JPG)
8. ������������ � ��������� man bash, �������� � ���������� ������ bash:
	����� ���������� ����� ������ ����� ������� history, � �� ����� ������� manual ��� �����������?
	HISTSIZE - ���������� ������ ��� ����������. 
	������ 1178
	HISTFILESIZE - ����� ������ ��� ����������.
	������ 1155

	
	��� ������ ��������� ignoreboth � bash?
	���������� ������������� ������ � ������� ������������ � ������� 

9. � ����� ��������� ������������� ��������� ������ {} � �� ����� ������� man bash ��� �������?

	��������� ���������� ������ � ������������ �������� mkdir ./int_{1..10} - ������� �������� �������� int_1, int_2 � �.�. �� int_10
		��� rmdir ./int_{1..10} - ������ �������� int_1 - int_10
		������ 343
	

10. ����������� �� ���������� �������, ��� ������� ����������� ������� touch 100000 ������? 
	touch {1..100000}
	� ���������� �� ������� 300000? ���� ���, �� ������?
	���. ������� ������� ������ ����������

11. � man bash ������� �� /\[\[. ��� ������ ����������� [[ -d /tmp ]]
	
	��������� ���������� �� ������� /tmp

12. ����������� �� ������� � ��������� ������� (��������, PATH) � ��������� ����� ����������; ��������, ������� �� �������������, ��������� � ������ type -a bash � ����������� ������ ������� ������ ������� � ������:

bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
(������ ������ ����� ���������� ���������� � ��������) � �������� ������ ��������� �������, ������� ��������� ��� �������� ���������� ������ ��� ��������������� ���������.
	![12](img/12.JPG)
13. ��� ���������� ������������ ������ � ������� batch � at?
������� at ������������ ��� ���������� ������������ ������� �� �������� �����, 
� ������� batch � ��� ���������� ����������� �����, ������� ������ �����������, ����� �������� ������� ���������� ������ 0,8.