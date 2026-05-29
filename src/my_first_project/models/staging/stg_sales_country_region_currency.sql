-- staging: sales country region currency
{{ config(materialized='view') }}

SELECT
  CountryRegionCode   AS country_region_code,
  CurrencyCode        AS currency_code
FROM {{ source('adventureworks', 'sales_country_region_currency') }}
