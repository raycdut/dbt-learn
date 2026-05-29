-- dimension: contact type
{{ config(materialized='table') }}

SELECT
  contact_type_id,
  name AS contact_type_name
FROM {{ ref('stg_person_contact_type') }}
