-- staging: production work order
{{ config(materialized='view') }}

SELECT
  CAST(WorkOrderID AS INT64)    AS work_order_id,
  CAST(ProductID AS INT64)      AS product_id,
  CAST(OrderQty AS INT64)       AS order_qty,
  CAST(StockedQty AS INT64)     AS stocked_qty,
  CAST(ScrappedQty AS INT64)    AS scrapped_qty,
  TRY_CAST(StartDate AS DATE)   AS start_date,
  TRY_CAST(EndDate AS DATE)     AS end_date,
  TRY_CAST(DueDate AS DATE)     AS due_date,
  CAST(ScrapReasonID AS INT64)  AS scrap_reason_id
FROM {{ source('adventureworks', 'production_work_order') }}
