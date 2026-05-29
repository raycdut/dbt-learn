-- staging: production unit measure
{{ config(materialized='view') }}

SELECT
  UnitMeasureCode   AS unit_measure_code,
  Name              AS unit_measure_name
FROM {{ source('adventureworks', 'production_unit_measure') }}
