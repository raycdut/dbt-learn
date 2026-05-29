-- staging: production illustration
{{ config(materialized='view') }}

SELECT
  CAST(IllustrationID AS INT64) AS illustration_id,
  Diagram                       AS diagram
FROM {{ source('adventureworks', 'production_illustration') }}
