-- staging: product_category
{{ config(materialized='view') }}

SELECT
  CAST(ProductCategoryID AS INT64) AS product_category_id,
  Name                             AS category_name
FROM {{ source('adventureworks', 'product_category') }}
