-- dimension: tax rate
{{ config(materialized='table') }}

SELECT
    tr.sales_tax_rate_id,
    tr.state_province_id,
    sp.name AS state_province_name,
    sp.country_region_code,
    tr.tax_type,
    tr.tax_rate,
    tr.tax_rate_name
FROM {{ ref('stg_sales_sales_tax_rate') }} tr
LEFT JOIN {{ ref('stg_person_state_province') }} sp ON tr.state_province_id = sp.state_province_id
