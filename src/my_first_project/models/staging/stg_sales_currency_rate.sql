-- staging: sales currency rate
{{ config(materialized='view') }}

SELECT
  CAST(CurrencyRateID AS INT64)   AS currency_rate_id,
  TRY_CAST(CurrencyRateDate AS DATE) AS currency_rate_date,
  FromCurrencyCode                AS from_currency_code,
  ToCurrencyCode                  AS to_currency_code,
  CAST(AverageRate AS NUMERIC)    AS average_rate,
  CAST(EndOfDayRate AS NUMERIC)   AS end_of_day_rate
FROM {{ source('adventureworks', 'sales_currency_rate') }}
