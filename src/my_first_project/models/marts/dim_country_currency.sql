-- dimension: country currency
{{ config(materialized='table') }}

SELECT
  country_region_code,
  currency_code
FROM {{ ref('stg_sales_country_region_currency') }}
