-- staging layer: raw cast + rename + basic cleanse
-- materialized as view (no storage cost)
{{ config(materialized='view') }}

SELECT
  SalesOrderID               AS sales_order_id,
  TRY_CAST(OrderDate AS DATE) AS order_date,
  TRY_CAST(DueDate AS DATE)   AS due_date,
  TRY_CAST(ShipDate AS DATE)  AS ship_date,
  Status                     AS status_code,
  OnlineOrderFlag            AS is_online_order,
  CAST(CustomerID AS INT64)  AS customer_id,
  CAST(TerritoryID AS INT64) AS territory_id,
  CAST(ShipMethodID AS INT64) AS ship_method_id,
  CAST(SubTotal AS NUMERIC)  AS subtotal,
  CAST(TaxAmt AS NUMERIC)    AS tax_amt,
  CAST(Freight AS NUMERIC)   AS freight,
  CAST(TotalDue AS NUMERIC)  AS total_due
FROM {{ source('adventureworks', 'sales_order_header') }}
