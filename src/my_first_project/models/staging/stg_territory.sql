-- staging: sales territory
{{ config(materialized='view') }}

SELECT
  CAST(TerritoryID AS INT64)        AS territory_id,
  Name                              AS territory_name,
  CountryRegionCode                 AS country_region_code,
  "Group"                           AS region_group,
  CAST(SalesYTD AS NUMERIC)         AS sales_ytd,
  CAST(SalesLastYear AS NUMERIC)    AS sales_last_year,
  CAST(CostYTD AS NUMERIC)          AS cost_ytd,
  CAST(CostLastYear AS NUMERIC)     AS cost_last_year
FROM {{ source('adventureworks', 'territory') }}
