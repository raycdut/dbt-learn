-- staging: person_state_province
{{ config(materialized='view') }}

SELECT
  CAST(StateProvinceID AS INT64)                             AS state_province_id,
  StateProvinceCode                                          AS state_province_code,
  CountryRegionCode                                          AS country_region_code,
  CASE WHEN IsOnlyStateProvinceFlag = 1 THEN TRUE ELSE FALSE END AS is_only_state_province_flag,
  Name                                                       AS name,
  CAST(TerritoryID AS INT64)                                 AS territory_id
FROM {{ source('adventureworks', 'person_state_province') }}
