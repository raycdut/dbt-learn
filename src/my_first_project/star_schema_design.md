# 星型模型设计文档

> AdventureWorks → 星型模型（生产级）
> 设计时间：2026-05-14

---

## 设计思路（7步法）

### 第一步：确定业务过程

核心业务是**销售自行车及配件**。事实表围绕"销售订单"设计。

### 第二步：确定粒度

事实表粒度 = **SalesOrderDetail 行级**（一笔订单买多个产品，每行一个产品）。

订单头级别的度量（SubTotal、Freight、Tax）在每行会重复。

**解决方案：拆两张事实表**

```
fact_order_header ← 每单一条，存 SubTotal/Freight/TaxAmt/TotalDue
                     ↑ 通过 sales_order_id 关联
fact_order_detail ← 每行一条，存 OrderQty/UnitPrice/LineTotal
```

**亿级数据下的理由：**
- 一张表：SubTotal 在每行重复，1 亿行 ≈ 额外 400MB 存储
- 拆两张：查订单聚合扫 header（约 2500 万行），查产品分析扫 detail（1 亿行）

### 第三步：确定维度

| 问题 | 维度 | 说明 |
|------|------|------|
| 谁买的？ | dim_customer | 个人买家 or 商店 |
| 什么产品？ | dim_product | 含品类层级（拉平） |
| 在哪买的？ | dim_territory | 销售区域 |
| 何时买的？ | dim_date | 日期维度（年/季/月/周预处理） |
| 怎么送？ | dim_ship_method | 运输方式 |
| 有折扣？ | dim_special_offer | 促销（可选，无变化时直接做字段） |

### 第四步：缓慢变化维度（SCD）

| 维度 | SCD 策略 | 理由 |
|------|---------|------|
| Product | **SCD2** | 价格/颜色/分类变化频繁，历史分析需回溯 |
| Customer | **SCD2** | 客户换区域或更名 |
| Territory | SCD1 | 几乎不变 |
| ShipMethod | SCD1 | 运输方式名不会变 |

**SCD2 设计：**
```sql
product_sk | product_id | product_name | list_price | valid_from | valid_to | is_current
```

### 第五步：代理键策略

不用源系统的 ProductID/CustomerID 做维度主键（源系统重构后 ID 可能变，SCD2 需要多行）。

```sql
-- 首次加载
ROW_NUMBER() OVER (ORDER BY product_id) AS product_sk
-- 增量加载
COALESCE(MAX(product_sk), 0) + 1
```

保留业务键 `product_id` 做追溯用。

### 第六步：事实表不可变性

事实表一旦写入，永不修改。增量策略：

```sql
{% if is_incremental() %}
  WHERE sales_order_id > (SELECT MAX(sales_order_id) FROM {{ this }})
{% endif %}
```

如果发现事实错误，用"冲销分录"修正（另写一行负数），不去改原行。

### 第七步：维度拉平

用户要看到 `category_name` 时，不需要 JOIN 三张表。

```
Product → Subcategory → Category（3NF）
            ↓ 拉平
dim_product：product_name | subcategory_name | category_name
```

---

## 模型目录结构

```
models/
├── staging/              ← view，仅清洗+类型转换
│   ├── sources.yml
│   ├── stg_sales_order_header.sql
│   ├── stg_sales_order_detail.sql
│   ├── stg_customer.sql
│   ├── stg_product.sql
│   ├── stg_product_subcategory.sql
│   ├── stg_product_category.sql
│   ├── stg_territory.sql
│   ├── stg_person.sql
│   ├── stg_store.sql
│   └── stg_ship_method.sql
├── dim/                  ← table（SCD2 走 merge）
│   ├── dim_product.sql
│   ├── dim_customer.sql
│   ├── dim_territory.sql
│   ├── dim_ship_method.sql
│   ├── dim_special_offer.sql
│   └── dim_date.sql
├── fact/                 ← incremental
│   ├── fact_order_header.sql
│   └── fact_order_detail.sql
└── schema.yml
```

### materialized 配置

```yaml
models:
  my_first_project:
    staging:
      +materialized: view
    dim:
      +materialized: table
    fact:
      +materialized: incremental
```

---

## 三层映射（Bronze → Silver → Gold）

| 层 | 做什么 | 对应 dbt 目录 |
|---|---|---|
| Bronze | 原始数据落盘 | seeds/ |
| Silver | 类型转换 + 拉通各表 | staging/ |
| Gold | 星型建模（SCD2 + 事实表） | dim/ + fact/ |

---

## 关键设计决策

1. **两张事实表**：避免订单级度量在明细行重复
2. **SCD2 只对 Product/Customer**：变动的才开版本，稳定的用 SCD1
3. **代理键独立**：ROW_NUMBER() 生成，不依赖源系统 ID
4. **维度拉平**：用户不需要做多级 JOIN
5. **事实不可变**：只有 INSERT，没有 UPDATE/DELETE

---

## ⚠️ 三个已知问题 & 解决方案

### 问题 1：dim_date 怎么生成

日期维度表不能从 AdventureWorks 的源数据自动生成，需要额外准备。

**方案：用种子 CSV**

创建 `seeds/dim_date.csv`，Python 生成脚本：

```python
# 在 dbt 项目根目录下运行
import csv
from datetime import date, timedelta

start = date(2010, 1, 1)
end = date(2016, 1, 1)
rows = []

d = start
while d < end:
    rows.append({
        "date_sk": d.strftime("%Y%m%d"),
        "date": d.isoformat(),
        "year": d.year,
        "quarter": (d.month - 1) // 3 + 1,
        "month": d.month,
        "month_name": d.strftime("%B"),
        "day_of_month": d.day,
        "day_of_week": d.isoweekday(),
        "day_name": d.strftime("%A"),
        "is_weekend": 1 if d.isoweekday() >= 6 else 0
    })
    d += timedelta(days=1)

with open("seeds/dim_date.csv", "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=rows[0].keys())
    w.writeheader()
    w.writerows(rows)

print(f"生成 {len(rows)} 行日期数据")
```

**然后 dbt 里直接 `ref('dim_date')`，不需要写 SQL 模型。**

### 问题 2：SCD2 怎么实现

**不要手写 merge。用 dbt 自带的 snapshot 功能。**

在项目根目录下创建 `snapshots/` 目录，放一个产品快照文件：

```sql
-- snapshots/snp_product.sql
{% snapshot snp_product %}
{{
    config(
        target_schema='gold',
        unique_key='product_id',
        strategy='check',
        check_cols=['list_price', 'color', 'product_subcategory_id']
    )
}}
SELECT
    CAST(ProductID AS INT64) AS product_id,
    Name AS product_name,
    CAST(ListPrice AS NUMERIC) AS list_price,
    Color,
    CAST(ProductSubcategoryID AS INT64) AS product_subcategory_id
FROM {{ source('adventureworks', 'product') }}
{% endsnapshot %}
```

dbt snapshot 会自动生成 `dbt_valid_from` / `dbt_valid_to` / `dbt_updated_at` 三个字段，不需要手写 SCD2 逻辑。

**然后 dim_product 直接从 snapshot 读取：**

```sql
-- models/dim/dim_product.sql
SELECT
    product_id AS product_sk,       -- snapshot 不会重复 product_id
    product_name,
    list_price,
    ps.subcategory_name,
    pc.category_name,
    dbt_valid_from AS valid_from,
    COALESCE(dbt_valid_to, '9999-12-31') AS valid_to,
    CASE WHEN dbt_valid_to IS NULL THEN TRUE ELSE FALSE END AS is_current
FROM {{ ref('snp_product') }} p
LEFT JOIN {{ ref('stg_product_subcategory') }} ps ...
LEFT JOIN {{ ref('stg_product_category') }} pc ...
```

**注意：** snapshot 基于 `check_cols` 的变化来开版本。如果源数据没有变化（AdventureWorks 是静态的），那 snapshot 永远不会产生新版本。要测试 SCD2 的正确性，需要手动往源表里 INSERT 一条 product_id 相同但 list_price 不同的记录。

### 问题 3：事实表被源系统修改怎么办

假设今天增量跑了 id=50000-51000，明天源系统给 id=49000 退款了。`WHERE id > MAX(id)` 会漏掉。

**方案：加 CDC 字段 + 宽窗口增量**

```sql
{{ config(materialized='incremental', unique_key='sales_order_id') }}

SELECT
    *,
    CURRENT_TIMESTAMP() AS loaded_at      -- 记录加载时间
FROM stg_sales_order_header

{% if is_incremental() %}
  -- 不要用 sales_order_id 做增量边界
  -- 用 ModifiedDate（源表自带的时间戳）
  WHERE ModifiedDate > (
    SELECT MAX(loaded_at) FROM {{ this }}
  )
{% endif %}
```

但这要求源表有 `ModifiedDate` 字段且能正确反映数据变更——AdventureWorks 的 SalesOrderHeader 表有这个字段，可以用。

**如果源表没有 ModifiedDate：**

加一个 `stg_sales_order_header_delta` 层，每次全量对比新旧数据，找到变化的行。但亿级数据下全量对比成本太高——此时应该用真正的 CDC 工具（Debezium、Flink CDC）而不是 dbt 来处理。

**这个项目的建议：**

| 场景 | 方案 |
|------|------|
| 练手用 | 接受"事实不可改"的假设，简单增量即可 |
| 生产用（有 ModifiedDate） | 用 ModifiedDate 做宽窗口增量 |
| 生产用（无 ModifiedDate） | 上游接 CDC 工具，dbt 只做清洗不碰增量逻辑 |

---

## 补充：dbt_project.yml 完整配置

```yaml
models:
  my_first_project:
    staging:
      +materialized: view
    dim:
      +materialized: table
    fact:
      +materialized: incremental

snapshots:
  my_first_project:
    +target_schema: gold
    +strategy: check
    +unique_key: product_id

---

## 待补完的 4 项设计

### ① dim_customer 的 SCD2 check_cols

```sql
-- snapshots/snp_customer.sql
{% snapshot snp_customer %}
{{
    config(
        target_schema='gold',
        unique_key='customer_id',
        strategy='check',
        check_cols=['territory_id', 'store_id', 'person_id']
    )
}}
SELECT
    CAST(CustomerID AS INT64) AS customer_id,
    CAST(TerritoryID AS INT64) AS territory_id,
    CAST(StoreID AS INT64) AS store_id,
    CAST(PersonID AS INT64) AS person_id
FROM {{ source('adventureworks', 'customer') }}
{% endsnapshot %}
```

**check_cols 选型逻辑：**

| 字段变化 | 是否触发 SCD2 | 理由 |
|---------|-------------|------|
| territory_id 变了 | ✅ 触发 | 客户换了区域，历史订单要分开看 |
| store_id 变了 | ✅ 触发 | 商店改了归属 |
| person_id 变了 | ✅ 触发 | 个人客户换了人（罕见，但严谨起见监视） |
| account_number 变了 | ❌ 不触发 | 纯系统字段，不影响分析 |

### ② 代理键冲突预防（多源场景）

当前设计：`product_id AS product_sk`

如果未来接入第二个数据源（比如另一个 ERP 系统），两个系统的 `product_id=1` 会冲突。

**生产级方案：source + ID 复合键**

```sql
-- 方法一：源前缀拼接（简单，可读）
CONCAT('AW-', product_id) AS product_sk  -- "AW-1", "AW-2"

-- 方法二：HASH 合并（稳定，长度固定）
FARM_FINGERPRINT(CONCAT('AdventureWorks', '_', product_id)) AS product_sk

-- 方法三：统一序列（推荐用于增量场景）
ROW_NUMBER() OVER (ORDER BY product_id) + (
  SELECT COALESCE(MAX(product_sk), 0) FROM dim_product
) AS product_sk
```

方法一可读性好，适合这个项目。方法三适合真正的亿级增量。选一种，在 dim_product 和 dim_customer 统一使用。

### ③ 亿级分区策略

两张事实表在亿级数据下需要分区，不然全表扫描扛不住。

```sql
-- fact_order_header 按年分区
{{ config(
    materialized='incremental',
    unique_key='sales_order_id',
    partition_by={
        'field': 'order_date',
        'data_type': 'date',
        'granularity': 'year'
    }
) }}

-- fact_order_detail 按年分区（继承 header 的 order_date）
-- 如果 detail 表没有 order_date，通过 sales_order_id 关联 header 获得
-- 在 stg 层就把 order_date 带进来
```

**日期维度也要分区？** 不用。dim_date 只有几千行，全表扫描成本几乎为零。

**dim_product 要分区吗？** 看版本数量。SCD2 如果产生了几百万个版本（极端情况），按 product_category 分区。正常情况不用。

### ④ schema.yml 测试配置

```yaml
version: 2

models:
  - name: dim_product
    description: "产品维度（SCD2，含品类层级）"
    columns:
      - name: product_sk
        description: "产品代理键"
        data_tests: [unique, not_null]
      - name: product_id
        description: "源系统产品ID"
        data_tests: [not_null]
      - name: is_current
        description: "是否为当前有效版本"
        data_tests: [not_null]

  - name: fact_order_detail
    description: "销售订单明细事实表"
    columns:
      - name: sales_order_detail_id
        data_tests: [unique, not_null]
      - name: product_sk
        data_tests: [not_null]
        # referential integrity test
      - name: order_qty
        data_tests:
          - not_null
          - dbt_utils.expression_is_true:
              expression: ">= 0"
```

**至少加的测试：**
- 所有 sk 字段：`not_null`
- 唯一键字段：`unique`
- 度量字段：`>= 0`（数量/金额不能为负）
- 维度引用：`relationships`（验证 fact.product_sk 在 dim_product 中存在）

---

## 命名规范

| 对象 | 命名规则 | 例子 |
|------|---------|------|
| 事实表 | `fact_<业务过程>` | fact_order_detail |
| 维度表 | `dim_<业务主体>` | dim_product |
| staging | `stg_<源表名>` | stg_sales_order_header |
| snapshot | `snp_<维度名>` | snp_product |
| 代理键 | `<主体>_sk` | product_sk |
| 布尔字段 | `is_<状态>` | is_current, is_weekend |
| 日期字段 | `<事件>_date` | order_date |
| 数字字段 | 全名不缩写 | order_qty (不写 qty) |

---

## 生产部署检查清单

- [ ] seeds 导入成功（`dbt seed`）
- [ ] staging models 运行正常（`dbt run -s staging`）
- [ ] dim_date 已生成（seed CSV 正确加载）
- [ ] snapshots 首次运行成功（`dbt snapshot`）
- [ ] dim 模型运行成功（`dbt run -s dim`）
- [ ] fact 模型全量运行成功（`dbt run -s fact`）
- [ ] 增量模式测试（删除一行事实表数据后 `dbt run` 验证只追加不覆盖）
- [ ] schema.yml 测试全部通过（`dbt test`）
- [ ] dim_customer snapshot 的 check_cols 按实际业务确认
- [ ] 代理键策略确认（单源用 product_id，多源用 CONCAT 前缀）
