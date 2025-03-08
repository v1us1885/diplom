provider "yandex" {
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
}

# Создание сервисного аккаунта
resource "yandex_iam_service_account" "terraform" {
  name        = "terraform-sa"
  description = "Service account for Terraform"
}

# Назначение роли storage.editor сервисному аккаунту (для управления бакетом)
resource "yandex_resourcemanager_folder_iam_binding" "storage_editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.terraform.id}"
  ]
}

# Назначение роли editor сервисному аккаунту (для инициализации terraform)
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.terraform.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-editor" {
  folder_id = var.yc_folder_id
  role      = "k8s.editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.yc_folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.yc_folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "compute_editor" {
  folder_id = var.yc_folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "load-balancer-admin" {
  folder_id = var.yc_folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.terraform.id
  description        = "Static access key for Terraform"
}

# Создание S3-бакета для хранения Terraform state
resource "yandex_storage_bucket" "tfstate" {
  bucket     = "bucket-tfstate"
  folder_id  = var.yc_folder_id
  force_destroy = true
}

# Создание файла ~/.aws/credentials для использования AWS Profile
resource "local_file" "aws_credentials" {
  content  = <<EOT
[yandex]
aws_access_key_id = ${yandex_iam_service_account_static_access_key.sa-static-key.access_key}
aws_secret_access_key = ${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}
EOT
  filename = "/home/v1rus1885/.aws/credentials"
}

# Создание backend.tf для Terraform
resource "local_file" "backend" {
  content  = <<EOT
terraform {
  backend "s3" {
    endpoint   = "https://storage.yandexcloud.net"
    bucket     = "${yandex_storage_bucket.tfstate.bucket}"
    region     = "ru-central1"
    key        = "network/terraform.tfstate"
    profile    = "yandex"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true 
    skip_s3_checksum            = true 
  }
}
EOT
  filename = "../terraform/backend.tf"
}
