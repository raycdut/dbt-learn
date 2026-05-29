-- intermediate: order reasons — 按 sales_order_id 聚合销售原因
{{ config(materialized='table') }}

WITH reasons AS (
    SELECT
        ohr.sales_order_id,
        sr.reason_name,
        sr.reason_type
    FROM {{ ref('stg_sales_order_header_sales_reason') }} ohr
    LEFT JOIN {{ ref('stg_sales_sales_reason') }} sr
        ON ohr.sales_reason_id = sr.sales_reason_id
)

SELECT
    sales_order_id,
    STRING_AGG(reason_name, ', ' ORDER BY reason_name) AS reason_names,
    STRING_AGG(reason_type, ', ' ORDER BY reason_type) AS reason_types
FROM reasons
GROUP BY sales_order_id
