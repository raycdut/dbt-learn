-- staging: person_email_address
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64)   AS business_entity_id,
  CAST(EmailAddressID AS INT64)     AS email_address_id,
  EmailAddress                      AS email_address
FROM {{ source('adventureworks', 'person_email_address') }}
