-- intermediate: purchase details
-- joins purchase_order_header, purchase_order_detail, product, vendor, and ship_method
{{ config(materialized='table') }}

SELECT
  poh.purchase_order_id,
  pod.purchase_order_detail_id,
  poh.revision_number,
  poh.status,
  poh.employee_id,
  poh.vendor_id,
  v.vendor_name,
  v.account_number,
  v.credit_rating,
  v.preferred_vendor_status,
  v.active_flag                        AS vendor_active_flag,
  pod.product_id,
  p.product_name,
  p.product_number,
  p.standard_cost,
  p.list_price,
  p.safety_stock_level,
  p.reorder_point,
  p.product_subcategory_id,
  p.product_model_id,
  poh.ship_method_id,
  sm.ship_method_name,
  sm.ship_base,
  sm.ship_rate,
  pod.due_date,
  poh.order_date,
  poh.ship_date,
  pod.order_qty,
  pod.unit_price,
  pod.line_total,
  pod.received_qty,
  pod.rejected_qty,
  pod.stocked_qty,
  poh.sub_total,
  poh.tax_amt,
  poh.freight,
  poh.total_due
FROM {{ ref('stg_purchasing_purchase_order_header') }} AS poh
INNER JOIN {{ ref('stg_purchasing_purchase_order_detail') }} AS pod
  ON poh.purchase_order_id = pod.purchase_order_id
LEFT OUTER JOIN {{ ref('stg_product') }} AS p
  ON pod.product_id = p.product_id
LEFT OUTER JOIN {{ ref('stg_purchasing_vendor') }} AS v
  ON poh.vendor_id = v.business_entity_id
LEFT OUTER JOIN {{ ref('stg_ship_method') }} AS sm
  ON poh.ship_method_id = sm.ship_method_id
