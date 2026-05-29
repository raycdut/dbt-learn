-- staging: sales order header sales reason
{{ config(materialized='view') }}

SELECT
  CAST(SalesOrderID AS INT64)  AS sales_order_id,
  CAST(SalesReasonID AS INT64) AS sales_reason_id
FROM {{ source('adventureworks', 'sales_order_header_sales_reason') }}
