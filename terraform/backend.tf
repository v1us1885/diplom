terraform {
  backend "s3" {
    endpoint   = "https://storage.yandexcloud.net"
    bucket     = "bucket-tfstate"
    region     = "ru-central1"
    key        = "network/terraform.tfstate"
    profile    = "yandex"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true 
    skip_s3_checksum            = true 
  }
}
