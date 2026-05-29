-- dimension: person contact
{{ config(materialized='table') }}

SELECT
  be.business_entity_id,
  be.person_id,
  be.contact_type_id,
  ct.name AS contact_type_name
FROM {{ ref('stg_person_business_entity_contact') }} be
LEFT JOIN {{ ref('stg_person_contact_type') }} ct
  ON be.contact_type_id = ct.contact_type_id
