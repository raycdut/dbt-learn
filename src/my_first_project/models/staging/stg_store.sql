-- staging: store
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64) AS business_entity_id,
  Name                            AS store_name
FROM {{ source('adventureworks', 'store') }}
