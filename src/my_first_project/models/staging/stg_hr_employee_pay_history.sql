-- staging: hr_employee_pay_history
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64)           AS business_entity_id,
  TRY_CAST(RateChangeDate AS DATE)          AS rate_change_date,
  CAST(Rate AS NUMERIC)                     AS rate,
  CAST(PayFrequency AS INT64)               AS pay_frequency
FROM {{ source('adventureworks', 'hr_employee_pay_history') }}
