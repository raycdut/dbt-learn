-- intermediate: customer profile (customer → person → store)
{{ config(materialized='table') }}

SELECT
  c.customer_id,
  c.account_number,
  c.territory_id,
  -- person info
  p.business_entity_id,
  p.person_type_code,
  p.full_name,
  p.first_name,
  p.middle_name,
  p.last_name,
  p.title,
  -- store info
  s.business_entity_id              AS store_business_entity_id,
  s.store_name
FROM {{ ref('stg_customer') }} c
LEFT JOIN {{ ref('stg_person', v=2) }} p
  ON c.person_id = p.business_entity_id
LEFT JOIN {{ ref('stg_store') }} s
  ON c.store_id = s.business_entity_id
