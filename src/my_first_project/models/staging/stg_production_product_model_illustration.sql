-- staging: production_product_model_illustration
{{ config(materialized='view') }}

SELECT
  CAST(ProductModelID AS INT64)    AS product_model_id,
  CAST(IllustrationID AS INT64)    AS illustration_id
FROM {{ source('adventureworks', 'production_product_model_illustration') }}
