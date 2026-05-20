-- staging: product_subcategory
{{ config(materialized='view') }}

SELECT
  CAST(ProductSubcategoryID AS INT64) AS product_subcategory_id,
  CAST(ProductCategoryID AS INT64)    AS product_category_id,
  Name                                AS subcategory_name
FROM {{ source('adventureworks', 'product_subcategory') }}
