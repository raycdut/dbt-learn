-- dimension: ship method
{{ config(materialized='table') }}

SELECT
  ship_method_id,
  ship_method_name,
  ship_base,
  ship_rate
FROM {{ ref('stg_ship_method') }}
