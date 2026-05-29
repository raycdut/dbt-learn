-- intermediate: product extended v2 — cost history, list price history, BOM, document
{{ config(materialized='table') }}

WITH cost_history_latest AS (
    SELECT ch.product_id, ch.standard_cost AS latest_standard_cost, ch.start_date AS cost_start_date
    FROM {{ ref('stg_production_product_cost_history') }} ch
    JOIN (
        SELECT product_id, MAX(start_date) AS max_date
        FROM {{ ref('stg_production_product_cost_history') }}
        GROUP BY product_id
    ) m ON ch.product_id = m.product_id AND ch.start_date = m.max_date
),

list_price_history_latest AS (
    SELECT lph.product_id, lph.list_price AS latest_list_price, lph.start_date AS list_price_start_date
    FROM {{ ref('stg_production_product_list_price_history') }} lph
    JOIN (
        SELECT product_id, MAX(start_date) AS max_date
        FROM {{ ref('stg_production_product_list_price_history') }}
        GROUP BY product_id
    ) m ON lph.product_id = m.product_id AND lph.start_date = m.max_date
),

bom_agg AS (
    SELECT product_assembly_id AS product_id,
        COUNT(bill_of_materials_id) AS bom_component_count,
        SUM(per_assembly_qty) AS bom_total_per_assembly_qty
    FROM {{ ref('stg_production_bill_of_materials') }}
    GROUP BY product_assembly_id
),

document_agg AS (
    SELECT product_id, COUNT(document_node) AS document_count
    FROM {{ ref('stg_production_product_document') }}
    GROUP BY product_id
)

SELECT
    pe.*,
    COALESCE(ch.latest_standard_cost, pe.standard_cost) AS historical_standard_cost,
    ch.cost_start_date,
    COALESCE(lph.latest_list_price, pe.list_price) AS historical_list_price,
    lph.list_price_start_date,
    COALESCE(ba.bom_component_count, 0) AS bom_component_count,
    COALESCE(ba.bom_total_per_assembly_qty, 0) AS bom_total_per_assembly_qty,
    COALESCE(da.document_count, 0) AS document_count
FROM {{ ref('int_product_extended') }} pe
LEFT JOIN cost_history_latest ch ON pe.product_id = ch.product_id
LEFT JOIN list_price_history_latest lph ON pe.product_id = lph.product_id
LEFT JOIN bom_agg ba ON pe.product_id = ba.product_id
LEFT JOIN document_agg da ON pe.product_id = da.product_id
