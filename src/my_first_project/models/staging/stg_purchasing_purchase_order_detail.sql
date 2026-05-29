-- staging: purchasing purchase order detail
{{ config(materialized='view') }}

SELECT
  CAST(PurchaseOrderID AS INT64)       AS purchase_order_id,
  CAST(PurchaseOrderDetailID AS INT64) AS purchase_order_detail_id,
  TRY_CAST(DueDate AS DATE)            AS due_date,
  CAST(OrderQty AS INT64)              AS order_qty,
  CAST(ProductID AS INT64)             AS product_id,
  CAST(UnitPrice AS NUMERIC)           AS unit_price,
  CAST(LineTotal AS NUMERIC)           AS line_total,
  CAST(ReceivedQty AS INT64)           AS received_qty,
  CAST(RejectedQty AS INT64)           AS rejected_qty,
  CAST(StockedQty AS INT64)            AS stocked_qty
FROM {{ source('adventureworks', 'purchasing_purchase_order_detail') }}
