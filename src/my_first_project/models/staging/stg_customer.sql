-- staging: customer
{{ config(materialized='view') }}

SELECT
  CAST(CustomerID AS INT64)  AS customer_id,
  CAST(PersonID AS INT64)    AS person_id,
  CAST(StoreID AS INT64)     AS store_id,
  CAST(TerritoryID AS INT64) AS territory_id,
  AccountNumber              AS account_number
FROM {{ source('adventureworks', 'customer') }}
