-- staging: production_product_model
{{ config(materialized='view') }}

SELECT
  CAST(ProductModelID AS INT64)  AS product_model_id,
  Name                           AS name,
  CatalogDescription             AS catalog_description,
  Instructions                   AS instructions
FROM {{ source('adventureworks', 'production_product_model') }}
