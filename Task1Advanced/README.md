# Task1Advanced

Модуль terraform для создания ВМ в Yandex Cloud. Лежит в `modules/vm`, создает виртуалку, к ней отдельный диск и сетевой интерфейс в подсети.

Окружения в папке `envs/` - dev, stage, prod. Код у них одинаковый, разница только в tfvars.

## Параметры модуля

- `name` - имя ВМ
- `zone` - зона
- `subnet_id` - подсеть
- `cores` - ядра
- `memory` - RAM в ГБ
- `data_disk_size` - размер доп диска
- `ssh_public_key` - ssh ключ

Остальное (core_fraction, preemptible, размер и тип дисков, образ и тд) имеет дефолты, смотреть в `variables.tf`.

## Outputs

vm_id, vm_name, fqdn, internal_ip, external_ip, data_disk_id

## Окружения

- dev - 2 ядра, 2 ГБ, 20% cpu, прерываемая, диск 10 ГБ hdd
- stage - 2 ядра, 4 ГБ, 50% cpu, прерываемая, диск 20 ГБ hdd
- prod - 2 ядра, 4 ГБ, 100% cpu, не прерываемая, диск 30 ГБ ssd

## Запуск

```bash
export YC_TOKEN=$(yc iam create-token)
cd envs/dev
terraform init
terraform apply -var-file=dev.tfvars
```

Для stage и prod так же, только своя папка и свой tfvars.

dev поднимал реально, ВМ создалась, по ssh зашел, второй диск виден как vdb. Потом удалил через destroy. stage и prod проверил через plan.