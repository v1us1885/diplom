output "service_account_id" {
  value = yandex_iam_service_account.terraform.id
}

output "bucket_name" {
  value = yandex_storage_bucket.tfstate.bucket
}

output "access_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  sensitive = true
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}
