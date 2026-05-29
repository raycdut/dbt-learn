-- staging: production work order routing
{{ config(materialized='view') }}

SELECT
  CAST(WorkOrderID AS INT64)            AS work_order_id,
  CAST(ProductID AS INT64)              AS product_id,
  CAST(OperationSequence AS INT64)      AS operation_sequence,
  CAST(LocationID AS INT64)             AS location_id,
  TRY_CAST(ScheduledStartDate AS DATE)  AS scheduled_start_date,
  TRY_CAST(ScheduledEndDate AS DATE)    AS scheduled_end_date,
  TRY_CAST(ActualStartDate AS DATE)     AS actual_start_date,
  TRY_CAST(ActualEndDate AS DATE)       AS actual_end_date,
  CAST(ActualResourceHrs AS NUMERIC)    AS actual_resource_hrs,
  CAST(PlannedCost AS NUMERIC)          AS planned_cost,
  CAST(ActualCost AS NUMERIC)           AS actual_cost
FROM {{ source('adventureworks', 'production_work_order_routing') }}
