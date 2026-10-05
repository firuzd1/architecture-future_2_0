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

# в CI приходит из секрета через TF_VAR_ssh_public_key
variable "ssh_public_key" {
  type      = string
  sensitive = true
}
