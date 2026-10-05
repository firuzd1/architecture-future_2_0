variable "env" {
  type = string
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "core_fraction" {
  type = number
}

variable "preemptible" {
  type = bool
}

variable "boot_disk_size" {
  type = number
}

variable "data_disk_size" {
  type = number
}

variable "data_disk_type" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}
