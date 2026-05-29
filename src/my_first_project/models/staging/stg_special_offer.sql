-- staging: sales special offer
{{ config(materialized='view') }}

SELECT
  CAST(SpecialOfferID AS INT64)   AS special_offer_id,
  Description                     AS offer_description,
  CAST(DiscountPct AS NUMERIC)    AS discount_pct,
  Type                            AS offer_type,
  Category                        AS offer_category,
  TRY_CAST(StartDate AS DATE)     AS start_date,
  TRY_CAST(EndDate AS DATE)       AS end_date,
  CAST(MinQty AS INT64)           AS min_qty,
  CAST(MaxQty AS INT64)           AS max_qty
FROM {{ source('adventureworks', 'special_offer') }}
