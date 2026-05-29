-- intermediate: purchase details v2 — 追加 product vendor 信息
{{ config(materialized='table') }}

SELECT
    pd.*,
    -- product vendor info
    pv.average_lead_time,
    pv.standard_price AS vendor_standard_price,
    pv.min_order_qty  AS vendor_min_order_qty,
    pv.max_order_qty  AS vendor_max_order_qty
FROM {{ ref('int_purchase_details') }} pd
LEFT JOIN {{ ref('stg_purchasing_product_vendor') }} pv
    ON pd.product_id = pv.product_id
    AND pd.vendor_id = pv.business_entity_id
