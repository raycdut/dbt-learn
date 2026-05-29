-- staging: sales credit card
{{ config(materialized='view') }}

SELECT
  CAST(CreditCardID AS INT64)   AS credit_card_id,
  CardType                      AS card_type,
  CardNumber                    AS card_number,
  CAST(ExpMonth AS INT64)       AS exp_month,
  CAST(ExpYear AS INT64)        AS exp_year
FROM {{ source('adventureworks', 'sales_credit_card') }}
