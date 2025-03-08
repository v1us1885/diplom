data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "bucket-tfstate"
    key    = "network/terraform.tfstate"
    region = "ru-central1"
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


locals {
  network_id = data.terraform_remote_state.network.outputs.network_id
  subnet_ids = [
    data.terraform_remote_state.network.outputs.subnet_a_id,
    data.terraform_remote_state.network.outputs.subnet_b_id,
    data.terraform_remote_state.network.outputs.subnet_d_id
  ]
}
