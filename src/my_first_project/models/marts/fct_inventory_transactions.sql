-- mart: inventory transactions — transaction history × product × location
{{ config(materialized='table') }}

SELECT
    th.transaction_id,
    th.product_id,
    p.product_name,
    th.transaction_date,
    th.transaction_type,
    th.quantity,
    th.actual_cost,
    NULL AS location_name
FROM {{ ref('stg_production_transaction_history') }} th
LEFT JOIN {{ ref('stg_product') }} p
    ON th.product_id = p.product_id
