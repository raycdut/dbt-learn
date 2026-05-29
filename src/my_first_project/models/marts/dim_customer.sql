-- dimension: customer
{{ config(materialized='table') }}

SELECT
  customer_id,
  account_number,
  territory_id,
  -- person details (if individual customer)
  business_entity_id                 AS person_business_entity_id,
  person_type_code,
  full_name,
  first_name,
  middle_name,
  last_name,
  title,
  -- store details (if store customer)
  store_business_entity_id,
  store_name,
  -- customer type classification
  CASE
    WHEN store_business_entity_id IS NOT NULL THEN 'STORE'
    WHEN person_type_code = 'IN' THEN 'INDIVIDUAL'
    WHEN person_type_code = 'SC' THEN 'STORE_CONTACT'
    ELSE 'OTHER'
  END                                AS customer_type
FROM {{ ref('int_customer_info') }}
