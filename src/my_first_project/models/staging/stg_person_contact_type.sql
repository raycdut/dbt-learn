-- staging: person_contact_type
{{ config(materialized='view') }}

SELECT
  CAST(ContactTypeID AS INT64) AS contact_type_id,
  Name                         AS name
FROM {{ source('adventureworks', 'person_contact_type') }}
