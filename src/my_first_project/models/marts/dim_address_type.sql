-- dimension: address type
{{ config(materialized='table') }}

SELECT
  address_type_id,
  name AS address_type_name
FROM {{ ref('stg_person_address_type') }}
