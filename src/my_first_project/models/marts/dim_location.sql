-- dimension: production location
{{ config(materialized='table') }}

SELECT
    location_id,
    name,
    cost_rate,
    availability
FROM {{ ref('stg_production_location') }}
