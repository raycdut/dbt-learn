{{ config(
    materialized='incremental',
    unique_key='sales_order_id',
    incremental_strategy='merge',
    post_hook="""
        INSERT INTO audit.row_counts (model_name, row_count, checked_at)
        SELECT '{{ this.name }}', COUNT(*), CURRENT_TIMESTAMP
        FROM {{ this }}
    """
) }}

SELECT
    h.sales_order_id,
    h.order_date,
    h.customer_id,
    c.account_number,
    h.subtotal,
    h.tax_amt,
    h.freight,
    h.total_due,
    h.status_code,
    h.is_online_order,
    CASE
        WHEN h.status_code = 1 THEN '进行中'
        WHEN h.status_code = 2 THEN '已批准'
        WHEN h.status_code = 3 THEN '已退回'
        WHEN h.status_code = 4 THEN '已拒绝'
        WHEN h.status_code = 5 THEN '已发货'
        WHEN h.status_code = 6 THEN '已取消'
        ELSE '未知'
    END AS status_label
FROM {{ ref('stg_sales_order_header') }} h
LEFT JOIN {{ ref('stg_customer') }} c
    ON h.customer_id = c.customer_id

{% if is_incremental() %}
  WHERE h.order_date > (SELECT MAX(order_date) FROM {{ this }})
{% endif %}
