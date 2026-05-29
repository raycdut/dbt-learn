-- fact: job candidate (resume XML text for analysis)
{{ config(materialized='table') }}

SELECT
  jc.job_candidate_id,
  jc.business_entity_id,
  p.full_name              AS candidate_name,
  jc.resume
FROM {{ ref('stg_hr_job_candidate') }} jc
LEFT JOIN {{ ref('stg_person', v=2) }} p ON jc.business_entity_id = p.business_entity_id
