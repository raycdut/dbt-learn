-- staging: person_address
{{ config(materialized='view') }}

SELECT
  CAST(AddressID AS INT64)             AS address_id,
  AddressLine1                         AS address_line_1,
  AddressLine2                         AS address_line_2,
  City                                 AS city,
  CAST(StateProvinceID AS INT64)       AS state_province_id,
  PostalCode                           AS postal_code,
  SpatialLocation                      AS spatial_location
FROM {{ source('adventureworks', 'person_address') }}
