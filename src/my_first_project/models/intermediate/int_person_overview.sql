-- intermediate: person 概览 — 类型分类 + 名称清洗
{{ config(materialized='table') }}

SELECT
    business_entity_id,
    full_name,
    person_type,
    {{ person_type_label() }},
    title,
    first_name,
    last_name,
    CASE
        WHEN middle_name IS NOT NULL AND middle_name != '' THEN CONCAT(first_name, ' ', middle_name, ' ', last_name)
        ELSE full_name
    END AS full_name_detailed,
    middle_name IS NOT NULL AND middle_name != '' AS has_middle_name
FROM {{ ref('stg_person', version=1) }}
