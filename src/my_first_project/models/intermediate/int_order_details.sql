-- intermediate: order details (order header × detail × product × special_offer × territory × ship_method)
{{ config(materialized='table') }}

SELECT
  -- detail level
  d.sales_order_id,
  d.sales_order_detail_id,
  d.order_qty,
  d.unit_price,
  d.unit_price_discount,
  d.line_total,
  d.product_id,
  d.special_offer_id,
  -- header level
  h.order_date,
  h.due_date,
  h.ship_date,
  h.status_code,
  h.is_online_order,
  h.customer_id,
  h.subtotal,
  h.tax_amt,
  h.freight,
  h.total_due,
  -- product
  p.product_name,
  p.product_number,
  p.subcategory_name,
  p.category_name,
  -- special offer
  o.offer_description,
  o.discount_pct,
  -- territory
  t.territory_name,
  t.country_region_code,
  t.region_group,
  -- ship method
  s.ship_method_name
FROM {{ ref('stg_sales_order_detail') }} d
JOIN {{ ref('stg_sales_order_header') }} h
  ON d.sales_order_id = h.sales_order_id
LEFT JOIN {{ ref('int_product_hierarchy') }} p
  ON d.product_id = p.product_id
LEFT JOIN {{ ref('stg_special_offer') }} o
  ON d.special_offer_id = o.special_offer_id
LEFT JOIN {{ ref('stg_territory') }} t
  ON h.territory_id = t.territory_id
LEFT JOIN {{ ref('stg_ship_method') }} s
  ON h.ship_method_id = s.ship_method_id
