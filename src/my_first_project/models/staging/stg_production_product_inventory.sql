-- staging: production_product_inventory
{{ config(materialized='view') }}

SELECT
  CAST(ProductID AS INT64)     AS product_id,
  CAST(LocationID AS INT64)    AS location_id,
  Shelf                        AS shelf,
  CAST(Bin AS INT64)           AS bin,
  CAST(Quantity AS INT64)      AS quantity
FROM {{ source('adventureworks', 'production_product_inventory') }}
