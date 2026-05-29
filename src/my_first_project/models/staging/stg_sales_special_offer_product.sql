-- staging: sales special offer product
{{ config(materialized='view') }}

SELECT
  CAST(SpecialOfferID AS INT64) AS special_offer_id,
  CAST(ProductID AS INT64)      AS product_id
FROM {{ source('adventureworks', 'sales_special_offer_product') }}
