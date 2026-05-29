-- staging: production product photo
{{ config(materialized='view') }}

SELECT
  CAST(ProductPhotoID AS INT64)   AS product_photo_id,
  ThumbnailPhotoFileName          AS thumbnail_photo_file_name,
  LargePhotoFileName              AS large_photo_file_name
FROM {{ source('adventureworks', 'production_product_photo') }}
