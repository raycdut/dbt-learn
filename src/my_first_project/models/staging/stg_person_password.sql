-- staging: person_password
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64) AS business_entity_id,
  PasswordHash                    AS password_hash,
  PasswordSalt                    AS password_salt
FROM {{ source('adventureworks', 'person_password') }}
