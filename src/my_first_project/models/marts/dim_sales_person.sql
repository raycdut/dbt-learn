-- dimension: sales person
{{ config(materialized='table') }}

SELECT
  business_entity_id,
  territory_id,
  sales_quota,
  bonus,
  commission_pct,
  sales_ytd,
  sales_last_year
FROM {{ ref('stg_sales_sales_person') }}
