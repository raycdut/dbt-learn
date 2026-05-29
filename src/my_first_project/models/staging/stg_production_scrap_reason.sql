-- staging: production scrap reason
{{ config(materialized='view') }}

SELECT
  CAST(ScrapReasonID AS INT64) AS scrap_reason_id,
  Name                         AS scrap_reason_name
FROM {{ source('adventureworks', 'production_scrap_reason') }}
