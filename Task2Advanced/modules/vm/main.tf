terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.130"
    }
  }
}

data "yandex_compute_image" "this" {
  family = var.image_family
}

# доп диск, цепляется к ВМ как secondary
resource "yandex_compute_disk" "data" {
  name   = "${var.name}-data"
  zone   = var.zone
  type   = var.data_disk_type
  size   = var.data_disk_size
  labels = var.labels
}

resource "yandex_compute_instance" "this" {
  name        = var.name
  hostname    = var.name
  zone        = var.zone
  platform_id = var.platform_id
  labels      = var.labels

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.this.id
      size     = var.boot_disk_size
      type     = var.boot_disk_type
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.data.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}
