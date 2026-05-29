-- dimension: product (including category hierarchy)
{{ config(materialized='table') }}

SELECT
  product_id,
  product_name,
  product_number,
  color,
  safety_stock_level,
  reorder_point,
  standard_cost,
  list_price,
  days_to_manufacture,
  product_line,
  class,
  style,
  subcategory_name,
  category_name,
  sell_start_date,
  sell_end_date
FROM {{ ref('int_product_hierarchy') }}
