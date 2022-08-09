# Заменить на ID своего облака <идентификатор облака>
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "<идентификатор облака>"
}

# Заменить на Folder своего облака <идентификатор каталога>
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "<идентификатор каталога>"
}
#Авторизационный токен <OAuth>
variable "yandex_token_id" {
  default = "<OAuth>"
}   

variable "ubuntu_2004" {
  default = "fd8mfc6omiki5govl68h"
}


