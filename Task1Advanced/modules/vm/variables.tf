variable "name" {
  description = "Имя ВМ"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
}

variable "subnet_id" {
  description = "ID подсети"
  type        = string
}

variable "cores" {
  description = "Количество ядер"
  type        = number
}

variable "memory" {
  description = "RAM в ГБ"
  type        = number
}

variable "core_fraction" {
  description = "Гарантированная доля CPU в процентах"
  type        = number
  default     = 100

  validation {
    condition     = contains([20, 50, 100], var.core_fraction)
    error_message = "core_fraction может быть 20, 50 или 100."
  }
}

variable "preemptible" {
  description = "Прерываемая ВМ (дешевле)"
  type        = bool
  default     = false
}

variable "platform_id" {
  description = "Платформа ВМ"
  type        = string
  default     = "standard-v3"
}

variable "image_family" {
  description = "Семейство образа ОС"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "boot_disk_size" {
  description = "Размер загрузочного диска в ГБ"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "Тип загрузочного диска"
  type        = string
  default     = "network-hdd"
}

variable "data_disk_size" {
  description = "Размер подключаемого диска в ГБ"
  type        = number
}

variable "data_disk_type" {
  description = "Тип подключаемого диска"
  type        = string
  default     = "network-hdd"
}

variable "nat" {
  description = "Выдать публичный IP"
  type        = bool
  default     = true
}

variable "ssh_user" {
  description = "Пользователь для SSH"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
}

variable "labels" {
  description = "Метки ресурсов"
  type        = map(string)
  default     = {}
}
