-- intermediate: product hierarchy (product → subcategory → category)
{{ config(materialized='table') }}

SELECT
  p.product_id,
  p.product_name,
  p.product_number,
  p.color,
  p.safety_stock_level,
  p.reorder_point,
  p.standard_cost,
  p.list_price,
  p.days_to_manufacture,
  p.product_line,
  p.class,
  p.style,
  p.sell_start_date,
  p.sell_end_date,
  -- subcategory
  ps.subcategory_name,
  -- category
  pc.category_name
FROM {{ ref('stg_product') }} p
LEFT JOIN {{ ref('stg_product_subcategory') }} ps
  ON p.product_subcategory_id = ps.product_subcategory_id
LEFT JOIN {{ ref('stg_product_category') }} pc
  ON ps.product_category_id = pc.product_category_id
