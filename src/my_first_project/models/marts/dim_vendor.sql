-- dimension: vendor
{{ config(materialized='table') }}

SELECT
  business_entity_id,
  account_number,
  vendor_name,
  credit_rating,
  preferred_vendor_status,
  active_flag,
  purchasing_web_service_url
FROM {{ ref('stg_purchasing_vendor') }}
