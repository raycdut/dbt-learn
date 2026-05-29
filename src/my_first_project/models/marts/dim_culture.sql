-- dimension: culture (localization)
{{ config(materialized='table') }}

SELECT
  culture_id,
  name AS culture_name
FROM {{ ref('stg_production_culture') }}
