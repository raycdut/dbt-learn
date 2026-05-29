-- staging: hr_shift
{{ config(materialized='view') }}

SELECT
  CAST(ShiftID AS INT64) AS shift_id,
  Name                   AS name,
  StartTime              AS start_time,
  EndTime                AS end_time
FROM {{ source('adventureworks', 'hr_shift') }}
