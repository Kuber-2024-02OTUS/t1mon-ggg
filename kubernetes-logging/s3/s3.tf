resource "yandex_iam_service_account" "sa" {
  name = "k8s-logging"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "logging" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "loki-t1mon-otus"

}

output "os_access_keys" {
    value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
}
output "os_secret_keys" {
    value = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    sensitive = true
}