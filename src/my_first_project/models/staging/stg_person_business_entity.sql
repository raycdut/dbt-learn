-- staging: person_business_entity
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64) AS business_entity_id
FROM {{ source('adventureworks', 'person_business_entity') }}
