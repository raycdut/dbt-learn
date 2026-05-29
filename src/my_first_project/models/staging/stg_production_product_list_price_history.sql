-- staging: production_product_list_price_history
{{ config(materialized='view') }}

SELECT
  CAST(ProductID AS INT64)           AS product_id,
  TRY_CAST(StartDate AS DATE)        AS start_date,
  TRY_CAST(EndDate AS DATE)          AS end_date,
  CAST(ListPrice AS NUMERIC)         AS list_price
FROM {{ source('adventureworks', 'production_product_list_price_history') }}
