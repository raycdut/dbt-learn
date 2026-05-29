-- staging: production_product_model_pd_culture
{{ config(materialized='view') }}

SELECT
  CAST(ProductModelID AS INT64)         AS product_model_id,
  CAST(ProductDescriptionID AS INT64)   AS product_description_id,
  CultureID                             AS culture_id
FROM {{ source('adventureworks', 'production_product_model_pd_culture') }}
