-- staging: sales sales person quota history
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64) AS business_entity_id,
  TRY_CAST(QuotaDate AS DATE)     AS quota_date,
  CAST(SalesQuota AS NUMERIC)     AS sales_quota
FROM {{ source('adventureworks', 'sales_sales_person_quota_history') }}
