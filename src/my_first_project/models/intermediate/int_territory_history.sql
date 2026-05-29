-- intermediate: territory history — person territory assignment history
{{ config(materialized='table') }}

SELECT
    sth.business_entity_id,
    sth.territory_id,
    sth.start_date,
    sth.end_date,
    p.full_name,
    p.person_type_code,
    t.territory_name,
    sp.sales_quota,
    sp.bonus,
    sp.commission_pct
FROM {{ ref('stg_sales_sales_territory_history') }} sth
LEFT JOIN {{ ref('stg_sales_sales_person') }} sp ON sth.business_entity_id = sp.business_entity_id
LEFT JOIN {{ ref('stg_person', v=2) }} p ON sth.business_entity_id = p.business_entity_id
LEFT JOIN {{ ref('stg_territory') }} t ON sth.territory_id = t.territory_id
