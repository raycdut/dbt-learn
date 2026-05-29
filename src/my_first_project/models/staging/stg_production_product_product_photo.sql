-- staging: production product product photo
{{ config(materialized='view') }}

SELECT
  CAST(ProductID AS INT64)      AS product_id,
  CAST(ProductPhotoID AS INT64) AS product_photo_id,
  CASE WHEN "Primary" = 1 THEN TRUE ELSE FALSE END AS is_primary
FROM {{ source('adventureworks', 'production_product_product_photo') }}
