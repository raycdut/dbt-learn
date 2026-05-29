-- staging: person_phone_number_type
{{ config(materialized='view') }}

SELECT
  CAST(PhoneNumberTypeID AS INT64) AS phone_number_type_id,
  Name                             AS name
FROM {{ source('adventureworks', 'person_phone_number_type') }}
