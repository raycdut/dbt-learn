-- singular test: 检查订单日期没有未来日期
-- 如果 order_date > 今天，测试失败
SELECT
    sales_order_id,
    order_date
FROM {{ ref('fct_orders') }}
WHERE order_date > CURRENT_DATE
