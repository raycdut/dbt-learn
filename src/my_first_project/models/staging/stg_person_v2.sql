-- staging: person (v2 — person_type 改名为 person_type_code)
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64)  AS business_entity_id,
  PersonType                       AS person_type_code,
  Title,
  FirstName                        AS first_name,
  MiddleName                       AS middle_name,
  LastName                         AS last_name,
  CONCAT(COALESCE(FirstName,''),' ',COALESCE(LastName,'')) AS full_name
FROM {{ source('adventureworks', 'person') }}
