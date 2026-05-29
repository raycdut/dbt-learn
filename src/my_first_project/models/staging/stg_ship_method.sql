-- staging: ship method
{{ config(materialized='view') }}

SELECT
  CAST(ShipMethodID AS INT64)       AS ship_method_id,
  Name                              AS ship_method_name,
  CAST(ShipBase AS NUMERIC)         AS ship_base,
  CAST(ShipRate AS NUMERIC)         AS ship_rate
FROM {{ source('adventureworks', 'ship_method') }}
