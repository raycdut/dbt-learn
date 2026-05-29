-- staging: purchasing vendor
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64) AS business_entity_id,
  AccountNumber                   AS account_number,
  Name                            AS vendor_name,
  CAST(CreditRating AS INT64)     AS credit_rating,
  CASE WHEN PreferredVendorStatus = 1 THEN TRUE ELSE FALSE END AS preferred_vendor_status,
  CASE WHEN ActiveFlag = 1 THEN TRUE ELSE FALSE END             AS active_flag,
  PurchasingWebServiceURL         AS purchasing_web_service_url
FROM {{ source('adventureworks', 'purchasing_vendor') }}
