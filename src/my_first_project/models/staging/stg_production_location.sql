-- staging: production_location
{{ config(materialized='view') }}

SELECT
  CAST(LocationID AS INT64)     AS location_id,
  Name                          AS name,
  CAST(CostRate AS NUMERIC)     AS cost_rate,
  CAST(Availability AS NUMERIC) AS availability
FROM {{ source('adventureworks', 'production_location') }}
