{% docs fct_orders_description %}

# 订单事实表

## 业务口径
包含所有销售订单头数据，关联客户信息，含金额和状态中文标签。
已取消、已退回的订单保留在原表，不做过滤。

## 刷新策略
每日增量刷新（incremental merge）。
首次全量构建，之后按 `order_date > MAX(order_date)` 增量插入/更新。

## 关键字段说明
| 字段 | 口径 |
|------|------|
| total_due | 总金额 = subtotal + tax_amt + freight |
| status_label | 状态代码的中文翻译，由 CASE WHEN 生成 |
| is_online_order | 0=门店 / 1=在线 |

## 下游消费
- BI 销售看板
- 财务对账

{% enddocs %}


{% docs stg_sales_order_header_description %}

# 订单清洗层

## 业务逻辑
从 `Sales_SalesOrderHeader` 原始 CSV 加载，做以下处理：
- 日期字段从字符串转为 DATE（TRY_CAST 安全转换）
- 金额字段从字符串转为 NUMERIC 类型
- 列名从驼峰改为下划线命名法

## 上游
adventureworks.sales_order_header（seed 数据）

## 下游
fct_orders

{% enddocs %}


{% docs fct_orders_total_due %}

订单总金额，由三部分组成：
- **subtotal**：商品金额小计
- **tax_amt**：税费
- **freight**：运费

计算公式：`total_due = subtotal + tax_amt + freight`

{% enddocs %}
