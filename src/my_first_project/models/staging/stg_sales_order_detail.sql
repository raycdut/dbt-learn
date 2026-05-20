-- staging: sales_order_detail
{{ config(materialized='view') }}

SELECT
  SalesOrderID             AS sales_order_id,
  SalesOrderDetailID       AS sales_order_detail_id,
  CAST(OrderQty AS INT64)  AS order_qty,
  CAST(ProductID AS INT64) AS product_id,
  CAST(SpecialOfferID AS INT64) AS special_offer_id,
  CAST(UnitPrice AS NUMERIC)    AS unit_price,
  CAST(UnitPriceDiscount AS NUMERIC) AS unit_price_discount,
  CAST(LineTotal AS NUMERIC)    AS line_total
FROM {{ source('adventureworks', 'sales_order_detail') }}
