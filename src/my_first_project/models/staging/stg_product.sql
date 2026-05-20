-- staging: product
{{ config(materialized='view') }}

SELECT
  CAST(ProductID AS INT64)          AS product_id,
  Name                              AS product_name,
  ProductNumber                     AS product_number,
  Color                             AS color,
  CAST(SafetyStockLevel AS INT64)   AS safety_stock_level,
  CAST(ReorderPoint AS INT64)       AS reorder_point,
  CAST(StandardCost AS NUMERIC)     AS standard_cost,
  CAST(ListPrice AS NUMERIC)        AS list_price,
  CAST(DaysToManufacture AS INT64)  AS days_to_manufacture,
  ProductLine                       AS product_line,
  Class                             AS class,
  Style                             AS style,
  CAST(ProductSubcategoryID AS INT64) AS product_subcategory_id,
  CAST(ProductModelID AS INT64)       AS product_model_id,
  TRY_CAST(SellStartDate AS DATE)    AS sell_start_date,
  TRY_CAST(SellEndDate AS DATE)      AS sell_end_date
FROM {{ source('adventureworks', 'product') }}
