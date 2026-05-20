-- singular test: 检查所有订单金额为正
-- 如果有 total_due < 0 的数据，测试失败
SELECT
    sales_order_id,
    total_due,
    order_date
FROM {{ ref('fct_orders') }}
WHERE total_due < 0
