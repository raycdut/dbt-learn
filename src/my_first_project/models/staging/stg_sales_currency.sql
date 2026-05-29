-- staging: sales currency
{{ config(materialized='view') }}

SELECT
  CurrencyCode  AS currency_code,
  Name          AS currency_name
FROM {{ source('adventureworks', 'sales_currency') }}
