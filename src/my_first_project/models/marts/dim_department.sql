-- dimension: department
{{ config(materialized='table') }}

SELECT
  department_id,
  name,
  group_name
FROM {{ ref('stg_hr_department') }}
