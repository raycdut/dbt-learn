-- staging: hr_department
{{ config(materialized='view') }}

SELECT
  CAST(DepartmentID AS INT64) AS department_id,
  Name                        AS name,
  GroupName                   AS group_name
FROM {{ source('adventureworks', 'hr_department') }}
