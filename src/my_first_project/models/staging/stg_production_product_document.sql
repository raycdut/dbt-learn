-- staging: production product document
{{ config(materialized='view') }}

SELECT
  CAST(ProductID AS INT64)  AS product_id,
  DocumentNode              AS document_node
FROM {{ source('adventureworks', 'production_product_document') }}
