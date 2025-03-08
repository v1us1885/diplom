terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.13"
    }
  }

  backend "s3" {
    bucket = "bucket-tfstate"
    region = "ru-central1"
    key    = "mks-cluster/terraform.tfstate"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    profile    = "yandex"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  service_account_key_file = "../sa-key-init.json"
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
}