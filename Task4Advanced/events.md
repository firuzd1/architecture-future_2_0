# Каталог доменных событий

Все события идут через Kafka, схема хранится в Schema Registry (Avro, совместимость backward). Топик = `<домен>.<событие>.v<версия>`.

## Общий конверт

У каждого события есть одинаковые поля:

```json
{
  "event_id": "uuid",
  "event_type": "PatientRegistered",
  "version": 1,
  "occurred_at": "2026-10-05T10:00:00Z",
  "source": "clinic.registry",
  "correlation_id": "uuid",
  "payload": { }
}
```

`event_id` нужен подписчикам для идемпотентности, `correlation_id` - для трейсинга сквозного сценария.

## События

| Событие | Источник | Что значит | Минимальный payload | Подписчики |
|---|---|---|---|---|
| ПациентЗарегистрирован (PatientRegistered) | Регистрация пациентов | Новый пациент заведен, согласия получены | patient_id, clinic_id, region | Пациентский поток, Счета и платежи, Аналитика |
| ПриемНазначен (AppointmentScheduled) | Пациентский поток | Пациент записан к врачу | visit_id, patient_id, doctor_id, slot_at | Аналитика |
| ВизитЗавершен (VisitCompleted) | Пациентский поток | Прием закончен, услуги зафиксированы | visit_id, patient_id, doctor_id, completed_at | Медкарты, Аналитика |
| УслугаОказана (ServiceProvided) | Пациентский поток | Услуга оказана и подлежит оплате | visit_id, patient_id, service_code, price, currency | Расчеты за услуги |
| МатериалыСписаны (MaterialsConsumed) | Пациентский поток | В ходе визита использованы материалы | visit_id, clinic_id, items[sku, qty] | Склад |
| ИсследованиеЗагружено (StudyUploaded) | Медкарты | Загружены данные исследования | study_id, patient_id, study_type, storage_ref | ИИ-диагностика |
| ИИАнализЗавершен (AiAnalysisCompleted) | ИИ-диагностика | Модель дала рекомендацию | analysis_id, study_id, model_version, confidence, needs_review | Медкарты, Аналитика (без медданных, только счетчики) |
| ИИАнализНеУдался (AiAnalysisFailed) | ИИ-диагностика | Анализ не выполнен | analysis_id, study_id, reason | Медкарты, DLQ |
| СчетВыставлен (InvoiceIssued) | Расчеты за услуги | Пациенту выставлен счет | invoice_id, patient_id, amount, currency, due_date | Счета и платежи, Аналитика |
| ЗапрошенаРассрочка (InstallmentRequested) | Расчеты за услуги | Клиент хочет оплатить в кредит | invoice_id, client_id, amount | Кредиты |
| КредитныйДоговорСоздан (LoanAgreementCreated) | Кредиты | Договор оформлен после скоринга | loan_id, client_id, amount, rate, term_months | Аналитика, Фин отчетность |
| КредитВыдан (LoanDisbursed) | Кредиты | Деньги по кредиту перечислены | loan_id, client_id, amount, invoice_id | Счета и платежи |
| ПлатежПроведен (PaymentCompleted) | Счета и платежи | Деньги списаны и зачислены | payment_id, invoice_id, amount, currency | Расчеты за услуги, Фин отчетность, Аналитика |
| СчетОплачен (InvoicePaid) | Расчеты за услуги | Счет закрыт полностью | invoice_id, patient_id, paid_at | Фин отчетность, Аналитика |
| ЗапасНижеМинимума (StockBelowMinimum) | Склад | Остаток упал ниже порога | sku, clinic_id, qty, min_qty | Фарма |
| ПоставкаПолучена (DeliveryReceived) | Фарма | Поставка пришла на склад | delivery_id, clinic_id, items[sku, qty] | Склад, Фин отчетность |
| ОборудованиеНеисправно (DeviceFaultDetected) | Медтехника | Телеметрия показала сбой | device_id, clinic_id, fault_code | Склад, Пациентский поток |
| ГрафикВрачаИзменен (DoctorScheduleChanged) | Персонал | Поменялся график врача | employee_id, clinic_id, valid_from | Пациентский поток |

## Правила

- в событиях нет диагнозов, результатов исследований и других медданных, только id
- новое поле добавляем как необязательное, удаление поля = новая версия события
- если подписчик не смог обработать событие 3 раза, оно уходит в DLQ топика `<топик>.dlq` с алертом