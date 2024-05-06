variable "token_id" {
    description = "yandex cloud token" 
    type = string
    sensitive   = true 
}
variable "cloud_id" {
    description = "cloud id"
    default = "b1gits9gqlqvij5tepgv"
}
variable "folder_id" {
    description = "folder id"
    default = "b1g63vh6asv8bqdgs914"
}
variable "zone" {
    description = "comute instance zone name"
    default = "ru-central1-a"
}
