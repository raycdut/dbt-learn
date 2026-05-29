-- staging: person_business_entity_contact
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64)   AS business_entity_id,
  CAST(PersonID AS INT64)           AS person_id,
  CAST(ContactTypeID AS INT64)      AS contact_type_id
FROM {{ source('adventureworks', 'person_business_entity_contact') }}
