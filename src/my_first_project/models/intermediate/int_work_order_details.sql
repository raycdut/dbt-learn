-- intermediate: work order details (work_order × scrap_reason × work_order_routing × location)
{{ config(materialized='table') }}

WITH routing_agg AS (
    SELECT
        work_order_id,
        MIN(operation_sequence)            AS first_operation_sequence,
        MAX(operation_sequence)            AS last_operation_sequence,
        MIN(scheduled_start_date)          AS first_scheduled_start_date,
        MAX(scheduled_end_date)            AS last_scheduled_end_date,
        MIN(actual_start_date)             AS first_actual_start_date,
        MAX(actual_end_date)               AS last_actual_end_date,
        SUM(actual_resource_hrs)           AS total_actual_resource_hrs,
        SUM(planned_cost)                  AS total_planned_cost,
        SUM(actual_cost)                   AS total_actual_cost,
        -- pick the location from the first routing operation
        FIRST(location_id ORDER BY operation_sequence ASC) AS location_id
    FROM {{ ref('stg_production_work_order_routing') }}
    GROUP BY work_order_id
)

SELECT
    -- work order fields
    wo.work_order_id,
    wo.product_id,
    wo.order_qty,
    wo.stocked_qty,
    wo.scrapped_qty,
    wo.start_date,
    wo.end_date,
    wo.due_date,
    wo.scrap_reason_id,
    -- scrap reason
    sr.scrap_reason_name,
    -- routing summaries
    ra.first_operation_sequence,
    ra.last_operation_sequence,
    ra.first_scheduled_start_date,
    ra.last_scheduled_end_date,
    ra.first_actual_start_date,
    ra.last_actual_end_date,
    ra.total_actual_resource_hrs,
    ra.total_planned_cost,
    ra.total_actual_cost,
    -- location (from first routing operation)
    ra.location_id,
    loc.name           AS location_name,
    loc.cost_rate      AS location_cost_rate,
    loc.availability   AS location_availability
FROM {{ ref('stg_production_work_order') }} wo
LEFT JOIN {{ ref('stg_production_scrap_reason') }} sr
    ON wo.scrap_reason_id = sr.scrap_reason_id
LEFT JOIN routing_agg ra
    ON wo.work_order_id = ra.work_order_id
LEFT JOIN {{ ref('stg_production_location') }} loc
    ON ra.location_id = loc.location_id
