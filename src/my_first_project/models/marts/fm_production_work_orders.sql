-- fact: production work orders (work_order grain)
{{ config(materialized='table') }}

SELECT
    work_order_id,
    product_id,
    order_qty,
    stocked_qty,
    scrapped_qty,
    start_date,
    end_date,
    due_date,
    scrap_reason_id,
    scrap_reason_name,
    first_operation_sequence,
    last_operation_sequence,
    first_scheduled_start_date,
    last_scheduled_end_date,
    first_actual_start_date,
    last_actual_end_date,
    total_actual_resource_hrs,
    total_planned_cost,
    total_actual_cost,
    location_id,
    location_name,
    location_cost_rate,
    location_availability
FROM {{ ref('int_work_order_details') }}
