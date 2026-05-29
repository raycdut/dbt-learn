-- staging: sales sales territory history
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64) AS business_entity_id,
  CAST(TerritoryID AS INT64)      AS territory_id,
  TRY_CAST(StartDate AS DATE)     AS start_date,
  TRY_CAST(EndDate AS DATE)       AS end_date
FROM {{ source('adventureworks', 'sales_sales_territory_history') }}
