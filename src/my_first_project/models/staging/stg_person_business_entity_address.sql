-- staging: person_business_entity_address
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64)   AS business_entity_id,
  CAST(AddressID AS INT64)          AS address_id,
  CAST(AddressTypeID AS INT64)      AS address_type_id
FROM {{ source('adventureworks', 'person_business_entity_address') }}
