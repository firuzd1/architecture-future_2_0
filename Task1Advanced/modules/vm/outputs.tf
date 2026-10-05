output "vm_id" {
  value = yandex_compute_instance.this.id
}

output "vm_name" {
  value = yandex_compute_instance.this.name
}

output "fqdn" {
  value = yandex_compute_instance.this.fqdn
}

output "internal_ip" {
  value = yandex_compute_instance.this.network_interface[0].ip_address
}

output "external_ip" {
  value = yandex_compute_instance.this.network_interface[0].nat_ip_address
}

output "data_disk_id" {
  value = yandex_compute_disk.data.id
}
