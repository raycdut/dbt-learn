-- staging: person_address_type
{{ config(materialized='view') }}

SELECT
  CAST(AddressTypeID AS INT64) AS address_type_id,
  Name                         AS name
FROM {{ source('adventureworks', 'person_address_type') }}
