-- bridge: special offer product mapping
{{ config(materialized='table') }}

SELECT
    sop.special_offer_id,
    sop.product_id,
    so.discount_pct,
    so.offer_type,
    so.offer_category,
    so.start_date,
    so.end_date,
    so.offer_description
FROM {{ ref('stg_sales_special_offer_product') }} sop
LEFT JOIN {{ ref('stg_special_offer') }} so ON sop.special_offer_id = so.special_offer_id
