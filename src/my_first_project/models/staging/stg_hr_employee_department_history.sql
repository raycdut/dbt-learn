-- staging: hr_employee_department_history
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64)           AS business_entity_id,
  CAST(DepartmentID AS INT64)               AS department_id,
  CAST(ShiftID AS INT64)                    AS shift_id,
  TRY_CAST(StartDate AS DATE)               AS start_date,
  TRY_CAST(EndDate AS DATE)                 AS end_date
FROM {{ source('adventureworks', 'hr_employee_department_history') }}
