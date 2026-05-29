-- staging: hr_job_candidate
{{ config(materialized='view') }}

SELECT
  CAST(JobCandidateID AS INT64)             AS job_candidate_id,
  CAST(BusinessEntityID AS INT64)           AS business_entity_id,
  Resume                                    AS resume
FROM {{ source('adventureworks', 'hr_job_candidate') }}
