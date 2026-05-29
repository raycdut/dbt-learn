-- staging: production_product_description
{{ config(materialized='view') }}

SELECT
  CAST(ProductDescriptionID AS INT64) AS product_description_id,
  Description                         AS description
FROM {{ source('adventureworks', 'production_product_description') }}
