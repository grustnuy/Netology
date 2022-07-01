# Заменить на ID своего облака 
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "<идентификатор облака>"
}

# Заменить на Folder своего облака 
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "<идентификатор каталога>"
}
#Авторизационный токен 
variable "yandex_token_id" {
  default = "<OAuth>"
}   


