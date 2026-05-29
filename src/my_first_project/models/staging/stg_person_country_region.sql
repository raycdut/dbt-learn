-- staging: person_country_region
{{ config(materialized='view') }}

SELECT
  CountryRegionCode   AS country_region_code,
  Name                AS name
FROM {{ source('adventureworks', 'person_country_region') }}
