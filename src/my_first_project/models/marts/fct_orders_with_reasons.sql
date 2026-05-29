-- mart: orders with reasons — int_order_details × int_order_reasons
{{ config(materialized='table') }}

SELECT
    od.*,
    COALESCE(ir.reason_names, '') AS reason_names,
    COALESCE(ir.reason_types, '') AS reason_types
FROM {{ ref('int_order_details') }} od
LEFT JOIN {{ ref('int_order_reasons') }} ir
    ON od.sales_order_id = ir.sales_order_id
