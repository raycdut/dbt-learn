-- staging: sales person credit card
{{ config(materialized='view') }}

SELECT
  CAST(BusinessEntityID AS INT64) AS business_entity_id,
  CAST(CreditCardID AS INT64)     AS credit_card_id
FROM {{ source('adventureworks', 'sales_person_credit_card') }}
