-- fact: order details (line-level granularity)
{{ config(materialized='table') }}

SELECT
  sales_order_detail_id              AS order_detail_key,
  sales_order_id,
  sales_order_detail_id,
  customer_id,
  product_id,
  special_offer_id,
  -- dates
  order_date,
  due_date,
  ship_date,
  -- measures
  order_qty,
  unit_price,
  unit_price_discount,
  line_total,
  -- order header measures (allocated per line)
  subtotal,
  tax_amt,
  freight,
  total_due,
  -- attributes
  status_code,
  is_online_order,
  territory_name,
  region_group,
  ship_method_name,
  category_name,
  subcategory_name
FROM {{ ref('int_order_details') }}
