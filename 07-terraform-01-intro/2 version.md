```
Скачать и распаковать двоичный файл for Terraform 0.11в отдельный каталог:
$ cd /usr/local/tf/11
$ wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
$ unzip terraform_0.11.14_linux_amd64.zip
$ rm terraform_0.11.14_linux_amd64.zip
Скачать и распаковать двоичный файл for Terraform 0.12в отдельный каталог:
$ cd /usr/local/tf/12
$ wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
$ unzip terraform_0.12.20_linux_amd64.zip
$ rm terraform_0.12.20_linux_amd64.zip
Создайте символические ссылки для обеих версий Terraform в /usr/bin/каталоге:
ln -s /usr/local/tf/11/terraform /usr/bin/terraform13
ln -s /usr/local/tf/12/terraform /usr/bin/terraform12
# Make both the symlinks executable
chmod ugo+x /usr/bin/terraform*
```
---
