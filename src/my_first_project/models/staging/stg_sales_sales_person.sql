-- staging: sales sales person
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64) AS business_entity_id,
  CAST(TerritoryID AS INT64)      AS territory_id,
  CAST(SalesQuota AS NUMERIC)     AS sales_quota,
  CAST(Bonus AS NUMERIC)          AS bonus,
  CAST(CommissionPct AS NUMERIC)  AS commission_pct,
  CAST(SalesYTD AS NUMERIC)       AS sales_ytd,
  CAST(SalesLastYear AS NUMERIC)  AS sales_last_year
FROM {{ source('adventureworks', 'sales_sales_person') }}
