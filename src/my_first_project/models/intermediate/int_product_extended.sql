-- intermediate: product extended — 合并 Production 产品相关 staging 表
{{ config(materialized='table') }}

WITH inventory_agg AS (
    SELECT
        product_id,
        SUM(quantity)   AS total_inventory,
        COUNT(location_id) AS location_count
    FROM {{ ref('stg_production_product_inventory') }}
    GROUP BY product_id
),

review_agg AS (
    SELECT
        product_id,
        AVG(rating)            AS avg_rating,
        COUNT(product_review_id) AS review_count
    FROM {{ ref('stg_production_product_review') }}
    GROUP BY product_id
)

SELECT
    ph.product_id,
    ph.product_name,
    ph.product_number,
    ph.color,
    ph.safety_stock_level,
    ph.reorder_point,
    ph.standard_cost,
    ph.list_price,
    ph.days_to_manufacture,
    ph.product_line,
    ph.class,
    ph.style,
    ph.sell_start_date,
    ph.sell_end_date,
    ph.subcategory_name,
    ph.category_name,
    -- product model info
    pm.name               AS model_name,
    pm.catalog_description,
    -- inventory summary
    COALESCE(ia.total_inventory, 0)   AS total_inventory,
    COALESCE(ia.location_count, 0)    AS location_count,
    -- review summary
    COALESCE(ra.avg_rating, 0)        AS avg_rating,
    COALESCE(ra.review_count, 0)      AS review_count
FROM {{ ref('int_product_hierarchy') }} ph
LEFT JOIN {{ ref('stg_product') }} p
    ON ph.product_id = p.product_id
LEFT JOIN {{ ref('stg_production_product_model') }} pm
    ON p.product_model_id = pm.product_model_id
LEFT JOIN inventory_agg ia
    ON ph.product_id = ia.product_id
LEFT JOIN review_agg ra
    ON ph.product_id = ra.product_id
