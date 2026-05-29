-- staging: person_person_phone
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64)     AS business_entity_id,
  PhoneNumber                         AS phone_number,
  CAST(PhoneNumberTypeID AS INT64)    AS phone_number_type_id
FROM {{ source('adventureworks', 'person_person_phone') }}
