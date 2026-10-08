terraform {
  required_version = ">= 1.5"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.130"
    }
  }
}

# токен берется из переменной окружения YC_TOKEN
provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

module "vm" {
  source = "../../modules/vm"

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
  ssh_public_key = file(pathexpand(var.ssh_public_key_path))

  labels = {
    env = var.env
  }
}
