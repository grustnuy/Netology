terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

# Backend 
 backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netbacket"
    region     = "ru-central1-a"
    key        = "./state.tfstate"
    access_key = "YCAJ**********"
    secret_key = "YCMA***********"

    skip_region_validation      = true
    skip_credentials_validation = true
 }
}
provider "yandex" {
  token                    = "${var.yandex_token_id}"
  cloud_id                 = "${var.yandex_cloud_id}"
  folder_id                = "${var.yandex_folder_id}"
  zone                     = "ru-central1-a"
}

