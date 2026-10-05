terraform {
  required_version = ">= 1.6"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.130"
    }
  }
}

# ключ сервисного аккаунта берется из YC_SERVICE_ACCOUNT_KEY_FILE
provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

module "vm" {
  source = "../modules/vm"

  name           = "${var.env}-vm"
  zone           = var.zone
  subnet_id      = var.subnet_id
  cores          = var.cores
  memory         = var.memory
  core_fraction  = var.core_fraction
  preemptible    = var.preemptible
  boot_disk_size = var.boot_disk_size
  data_disk_size = var.data_disk_size
  data_disk_type = var.data_disk_type
  ssh_public_key = var.ssh_public_key

  labels = {
    env = var.env
  }
}
