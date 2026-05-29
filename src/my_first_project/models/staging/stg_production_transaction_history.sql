-- staging: production transaction history
{{ config(materialized='view') }}

SELECT
  CAST(TransactionID AS INT64)          AS transaction_id,
  CAST(ProductID AS INT64)              AS product_id,
  CAST(ReferenceOrderID AS INT64)       AS reference_order_id,
  CAST(ReferenceOrderLineID AS INT64)   AS reference_order_line_id,
  TRY_CAST(TransactionDate AS DATE)     AS transaction_date,
  TransactionType                       AS transaction_type,
  CAST(Quantity AS INT64)               AS quantity,
  CAST(ActualCost AS NUMERIC)           AS actual_cost
FROM {{ source('adventureworks', 'production_transaction_history') }}
