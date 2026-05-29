-- dimension: sales reason
{{ config(materialized='table') }}

SELECT
  sales_reason_id,
  reason_name,
  reason_type
FROM {{ ref('stg_sales_sales_reason') }}
