# Расширенный техрадар

Кольца:
- **Adopt** - используем по умолчанию
- **Trial** - пробуем в пилотных доменах
- **Assess** - изучаем, пока без продакшена
- **Hold** - новое не начинаем, старое выводим

## Паттерны и подходы

| Что | Кольцо | Почему |
|---|---|---|
| Event-Driven Architecture | Adopt | основа целевой архитектуры, домены общаются событиями |
| Domain-Driven Design | Adopt | по нему режем домены и bounded contexts |
| Transactional Outbox | Adopt | надежная публикация событий из сервисов |
| Anti-corruption layer | Adopt | мост к Camel и DWH на время миграции |
| Infrastructure as Code | Adopt | вся инфра через Terraform, см. Task1-2 |
| Self-service BI | Trial | портал самообслуживания, запускаем в пилотных доменах |
| Data Mesh | Trial | домены владеют своими data products, начинаем с 1-2 доменов |
| CDC | Trial | забираем изменения из DWH в Kafka без правок DWH |
| Data Contracts | Trial | контракты на data products, не только на события |
| Saga | Assess | для длинных процессов (рассрочка), смотрим где реально нужна |
| Event Sourcing | Assess | только для платежей и кредитов, если понадобится полный аудит |
| Lakehouse | Trial | единое хранилище данных для доменов вместо одного DWH |
| Централизованный DWH с бизнес-логикой | Hold | новую логику в DWH не добавляем |
| Интеграция точка-точка через ESB | Hold | новые интеграции только через события |
| Batch-отчеты по ночам | Hold | переходим на потоковые витрины |

## Платформы

| Что | Кольцо | Почему |
|---|---|---|
| Yandex Cloud | Adopt | основное облако, есть сегменты под персданные |
| Kubernetes (Managed) | Adopt | платформа для сервисов доменов |
| Apache Kafka (Managed) | Adopt | event backbone |
| PostgreSQL | Adopt | операционные БД доменов |
| ClickHouse | Trial | аналитические витрины, быстрые отчеты |
| Object Storage + Apache Iceberg | Trial | lakehouse |
| Apache Flink | Trial | потоковая обработка, near-real-time витрины |
| Trino | Assess | запросы поверх lakehouse и ClickHouse |
| Microsoft SQL Server 2008 | Hold | без поддержки, выводим |
| Apache Camel ESB | Hold | только как мост на время миграции |
| PowerBuilder | Hold | заменяем на web-кабинет |

## Инструменты

| Что | Кольцо | Почему |
|---|---|---|
| Terraform | Adopt | IaC |
| GitHub Actions / GitLab CI | Adopt | CI/CD |
| Schema Registry | Adopt | контроль схем событий |
| Keycloak | Adopt | SSO и роли |
| OPA | Trial | row/column-level доступ в портале |
| Debezium | Trial | CDC из SQL Server |
| DataHub | Trial | каталог данных, владельцы, lineage |
| Apache Superset / DataLens | Trial | портал отчетов и конструктор |
| Cube | Assess | семантический слой метрик |
| Prometheus + Grafana, Jaeger, ELK | Adopt | наблюдаемость (уже есть опыт) |
| Power BI | Hold | на переходе оставляем, новые отчеты в портале |

## Языки и фреймворки

| Что | Кольцо | Почему |
|---|---|---|
| C# .NET | Adopt | новые сервисы клиник и офиса |
| Go, Java | Adopt | финтех, уже есть команды |
| Python | Adopt | ИИ-сервисы и data engineering |
| React | Adopt | web-кабинет и портал |
| dbt | Trial | трансформации в витринах |
| Avro | Adopt | формат событий |