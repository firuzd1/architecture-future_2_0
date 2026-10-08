# Task2Advanced

Деплой ВМ через github actions, стейт terraform хранится в Yandex Object Storage, не локально.

Модуль тот же что в Task1 (`modules/vm`). Корневой конфиг в `infra/`, один на все окружения, разница только в `infra/envs/<env>.tfvars`.

## Backend

`infra/backend.tf` - s3 backend на бакет `tfstate-firuz-future2` в Yandex Object Storage. На бакете включено версионирование, если стейт сломается можно откатить.

Ключ стейта в коде не прописан, передается при init, у каждого окружения свой файл:

```
envs/dev/terraform.tfstate
envs/stage/terraform.tfstate
envs/prod/terraform.tfstate
```

## Доступы

Для CI заведен отдельный сервисный аккаунт `tf-ci`, у него только роли compute.editor, vpc.user и storage.editor на каталог. Личный токен в CI не используется.

Секреты в github (Settings -> Secrets -> Actions):

- `YC_SA_KEY_JSON` - авторизованный ключ сервисного аккаунта, для провайдера
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` - статический ключ того же аккаунта, для s3 backend
- `SSH_PUBLIC_KEY` - ssh ключ для ВМ, в terraform приходит как TF_VAR_ssh_public_key (переменная sensitive)

Ключ аккаунта пишется во временный файл раннера и удаляется в конце джобы.

## Пайплайн

Файл `.github/workflows/terraform.yml` (лежит в корне репо, по-другому github actions его не видит).

Запускается:
- на pull request если менялось что-то в Task2Advanced - только plan для dev
- вручную через Actions -> terraform -> Run workflow, там выбираешь окружение (dev/stage/prod) и действие (plan/apply/destroy)

Джоба `plan`:
1. terraform fmt -check
2. terraform init с ключом стейта нужного окружения
3. terraform validate
4. terraform plan -out=tfplan (для destroy с флагом -destroy)
5. если действие apply или destroy - план сохраняется артефактом на 1 день

Джоба `apply`:
- запускается только при ручном запуске с apply или destroy
- привязана к github environment (dev/stage/prod), в каждом стоит required reviewer, поэтому пайплайн останавливается и ждет нажатия Approve
- применяет именно тот план что был сохранен в первой джобе, а не считает заново
- stage и prod можно деплоить только из ветки main

Еще есть `concurrency` по окружению, чтобы два запуска не писали в один стейт одновременно.

## Локальный запуск

```bash
export YC_SERVICE_ACCOUNT_KEY_FILE=~/yc-keys/tf-ci-key.json
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_ed25519.pub)"

cd infra
terraform init -backend-config="key=envs/dev/terraform.tfstate"
terraform plan -var-file=envs/dev.tfvars
```