-- dimension: unit of measure
{{ config(materialized='table') }}

SELECT
  unit_measure_code,
  unit_measure_name
FROM {{ ref('stg_production_unit_measure') }}
