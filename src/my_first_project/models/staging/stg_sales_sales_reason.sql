-- staging: sales sales reason
{{ config(materialized='view') }}

SELECT
  CAST(SalesReasonID AS INT64)  AS sales_reason_id,
  Name                          AS reason_name,
  ReasonType                    AS reason_type
FROM {{ source('adventureworks', 'sales_sales_reason') }}
