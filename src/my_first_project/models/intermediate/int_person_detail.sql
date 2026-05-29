-- intermediate: person_detail — Person 多表合并为宽表
{{ config(materialized='table') }}

WITH
person_email AS (
    SELECT e.business_entity_id, e.email_address
    FROM {{ ref('stg_person_email_address') }} e
    JOIN (SELECT e2.business_entity_id, MIN(e2.email_address_id) AS min_id FROM {{ ref('stg_person_email_address') }} e2 GROUP BY e2.business_entity_id) m
    ON e.business_entity_id = m.business_entity_id AND e.email_address_id = m.min_id
),
person_phone AS (
    SELECT p.business_entity_id, p.phone_number, t.name AS phone_type_name
    FROM {{ ref('stg_person_person_phone') }} p
    JOIN (SELECT p2.business_entity_id, MIN(p2.phone_number) AS min_phone FROM {{ ref('stg_person_person_phone') }} p2 GROUP BY p2.business_entity_id) m
    ON p.business_entity_id = m.business_entity_id AND p.phone_number = m.min_phone
    LEFT JOIN {{ ref('stg_person_phone_number_type') }} t ON p.phone_number_type_id = t.phone_number_type_id
),
person_address AS (
    SELECT bea.business_entity_id, a.address_line_1, a.city, sp.name AS state_province_name, a.postal_code, cr.name AS country_region_name
    FROM (
        SELECT bea.business_entity_id, bea.address_id
        FROM {{ ref('stg_person_business_entity_address') }} bea
        JOIN (SELECT bea2.business_entity_id, MIN(bea2.address_id) AS min_id FROM {{ ref('stg_person_business_entity_address') }} bea2 GROUP BY bea2.business_entity_id) m
        ON bea.business_entity_id = m.business_entity_id AND bea.address_id = m.min_id
    ) bea
    LEFT JOIN {{ ref('stg_person_address') }} a ON bea.address_id = a.address_id
    LEFT JOIN {{ ref('stg_person_state_province') }} sp ON a.state_province_id = sp.state_province_id
    LEFT JOIN {{ ref('stg_person_country_region') }} cr ON sp.country_region_code = cr.country_region_code
)

SELECT
    p.business_entity_id,
    p.person_type_code,
    p.full_name,
    p.first_name,
    p.last_name,
    p.title,
    e.email_address,
    ph.phone_number,
    ph.phone_type_name,
    pa.address_line_1,
    pa.city,
    pa.state_province_name,
    pa.postal_code,
    pa.country_region_name
FROM {{ ref('stg_person', v=2) }} p
LEFT JOIN person_email e ON p.business_entity_id = e.business_entity_id
LEFT JOIN person_phone ph ON p.business_entity_id = ph.business_entity_id
LEFT JOIN person_address pa ON p.business_entity_id = pa.business_entity_id
