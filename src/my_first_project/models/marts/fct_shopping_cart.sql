-- fact: shopping cart items
{{ config(materialized='table') }}

SELECT
    sci.shopping_cart_item_id,
    sci.shopping_cart_id,
    sci.product_id,
    p.product_name,
    p.list_price,
    sci.quantity,
    ROUND(sci.quantity * COALESCE(p.list_price, 0), 2) AS estimated_total,
    sci.date_created
FROM {{ ref('stg_sales_shopping_cart_item') }} sci
LEFT JOIN {{ ref('stg_product') }} p ON sci.product_id = p.product_id
