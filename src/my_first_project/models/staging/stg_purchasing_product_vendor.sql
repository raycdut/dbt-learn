-- staging: purchasing product vendor
{{ config(materialized='view') }}

SELECT
  CAST(ProductID AS INT64)        AS product_id,
  CAST(BusinessEntityID AS INT64) AS business_entity_id,
  CAST(AverageLeadTime AS NUMERIC) AS average_lead_time,
  CAST(StandardPrice AS NUMERIC)  AS standard_price,
  CAST(LastReceiptCost AS NUMERIC) AS last_receipt_cost,
  TRY_CAST(LastReceiptDate AS DATE) AS last_receipt_date,
  CAST(MinOrderQty AS INT64)      AS min_order_qty,
  CAST(MaxOrderQty AS INT64)      AS max_order_qty,
  CAST(OnOrderQty AS INT64)       AS on_order_qty,
  UnitMeasureCode                 AS unit_measure_code
FROM {{ source('adventureworks', 'purchasing_product_vendor') }}
