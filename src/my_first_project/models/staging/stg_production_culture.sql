-- staging: production_culture
{{ config(materialized='view') }}

SELECT
  CultureID  AS culture_id,
  Name       AS name
FROM {{ source('adventureworks', 'production_culture') }}
