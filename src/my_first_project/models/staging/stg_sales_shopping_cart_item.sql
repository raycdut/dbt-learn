-- staging: sales shopping cart item
{{ config(materialized='view') }}

SELECT
  CAST(ShoppingCartItemID AS INT64) AS shopping_cart_item_id,
  ShoppingCartID                    AS shopping_cart_id,
  CAST(Quantity AS INT64)           AS quantity,
  CAST(ProductID AS INT64)          AS product_id,
  TRY_CAST(DateCreated AS DATE)     AS date_created
FROM {{ source('adventureworks', 'sales_shopping_cart_item') }}
