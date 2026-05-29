-- staging: purchasing purchase order header
{{ config(materialized='view') }}

SELECT
  CAST(PurchaseOrderID AS INT64)  AS purchase_order_id,
  CAST(RevisionNumber AS INT64)   AS revision_number,
  CAST(Status AS INT64)           AS status,
  CAST(EmployeeID AS INT64)       AS employee_id,
  CAST(VendorID AS INT64)         AS vendor_id,
  CAST(ShipMethodID AS INT64)     AS ship_method_id,
  TRY_CAST(OrderDate AS DATE)     AS order_date,
  TRY_CAST(ShipDate AS DATE)      AS ship_date,
  CAST(SubTotal AS NUMERIC)       AS sub_total,
  CAST(TaxAmt AS NUMERIC)         AS tax_amt,
  CAST(Freight AS NUMERIC)        AS freight,
  CAST(TotalDue AS NUMERIC)       AS total_due
FROM {{ source('adventureworks', 'purchasing_purchase_order_header') }}
