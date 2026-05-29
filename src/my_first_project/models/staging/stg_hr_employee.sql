-- staging: hr_employee
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64)            AS business_entity_id,
  NationalIDNumber                           AS national_id_number,
  LoginID                                    AS login_id,
  CAST(OrganizationNode AS VARCHAR)          AS organization_node,
  CAST(OrganizationLevel AS INT64)           AS organization_level,
  JobTitle                                   AS job_title,
  TRY_CAST(BirthDate AS DATE)                AS birth_date,
  MaritalStatus                              AS marital_status,
  Gender                                     AS gender,
  TRY_CAST(HireDate AS DATE)                 AS hire_date,
  CASE WHEN SalariedFlag = 1 THEN TRUE ELSE FALSE END AS salaried_flag,
  CAST(VacationHours AS INT64)               AS vacation_hours,
  CAST(SickLeaveHours AS INT64)              AS sick_leave_hours,
  CASE WHEN CurrentFlag = 1 THEN TRUE ELSE FALSE END AS current_flag
FROM {{ source('adventureworks', 'hr_employee') }}
