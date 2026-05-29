-- dimension: currency
{{ config(materialized='table') }}

WITH latest_rates AS (
    SELECT r.from_currency_code, r.average_rate, r.end_of_day_rate, r.currency_rate_date
    FROM {{ ref('stg_sales_currency_rate') }} r
    JOIN (
        SELECT from_currency_code, MAX(currency_rate_date) AS max_date
        FROM {{ ref('stg_sales_currency_rate') }}
        GROUP BY from_currency_code
    ) m ON r.from_currency_code = m.from_currency_code AND r.currency_rate_date = m.max_date
)

SELECT
    c.currency_code,
    c.currency_name,
    lr.average_rate          AS latest_average_rate,
    lr.end_of_day_rate       AS latest_end_of_day_rate,
    lr.currency_rate_date    AS latest_rate_date
FROM {{ ref('stg_sales_currency') }} c
LEFT JOIN latest_rates lr ON c.currency_code = lr.from_currency_code
