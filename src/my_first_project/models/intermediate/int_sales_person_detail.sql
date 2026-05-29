-- intermediate: sales person detail
{{ config(materialized='table') }}

WITH latest_quota AS (
    SELECT q.business_entity_id, q.sales_quota, q.quota_date
    FROM {{ ref('stg_sales_sales_person_quota_history') }} q
    JOIN (
        SELECT business_entity_id, MAX(quota_date) AS max_date
        FROM {{ ref('stg_sales_sales_person_quota_history') }}
        GROUP BY business_entity_id
    ) m ON q.business_entity_id = m.business_entity_id AND q.quota_date = m.max_date
)

SELECT
    sp.business_entity_id,
    p.full_name,
    p.title,
    -- employee
    e.job_title,
    e.hire_date,
    -- territory
    sp.territory_id,
    t.territory_name,
    t.region_group,
    t.country_region_code,
    -- sales metrics
    sp.sales_quota,
    sp.bonus,
    sp.commission_pct,
    sp.sales_ytd,
    sp.sales_last_year,
    -- latest quota history
    lq.sales_quota         AS historical_latest_quota,
    lq.quota_date          AS latest_quota_date
FROM {{ ref('stg_sales_sales_person') }} sp
LEFT JOIN {{ ref('stg_person', v=2) }} p ON sp.business_entity_id = p.business_entity_id
LEFT JOIN {{ ref('stg_hr_employee') }} e ON sp.business_entity_id = e.business_entity_id
LEFT JOIN {{ ref('stg_territory') }} t ON sp.territory_id = t.territory_id
LEFT JOIN latest_quota lq ON sp.business_entity_id = lq.business_entity_id
