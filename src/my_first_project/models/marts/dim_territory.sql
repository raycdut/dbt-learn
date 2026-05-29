-- dimension: sales territory
{{ config(materialized='table') }}

SELECT
  territory_id,
  territory_name,
  country_region_code,
  region_group,
  sales_ytd,
  sales_last_year,
  cost_ytd,
  cost_last_year
FROM {{ ref('stg_territory') }}
