-- staging: sales sales tax rate
{{ config(materialized='view') }}

SELECT
  CAST(SalesTaxRateID AS INT64)   AS sales_tax_rate_id,
  CAST(StateProvinceID AS INT64)  AS state_province_id,
  CAST(TaxType AS INT64)          AS tax_type,
  CAST(TaxRate AS NUMERIC)        AS tax_rate,
  Name                            AS tax_rate_name
FROM {{ source('adventureworks', 'sales_sales_tax_rate') }}
