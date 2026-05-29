-- dimension: date (generated from order date range)
{{ config(materialized='table') }}

WITH date_range AS (
  SELECT
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date
  FROM {{ ref('stg_sales_order_header') }}
),

date_spine AS (
  SELECT UNNEST(generate_series(
    CAST((SELECT min_date FROM date_range) AS DATE),
    CAST((SELECT max_date FROM date_range) AS DATE),
    INTERVAL 1 DAY
  )) AS date_day
)

SELECT
  CAST(strftime(date_day, '%Y%m%d') AS INT64) AS date_key,
  date_day                                        AS date,
  EXTRACT(YEAR FROM date_day)                     AS year,
  EXTRACT(QUARTER FROM date_day)                  AS quarter,
  EXTRACT(MONTH FROM date_day)                    AS month,
  EXTRACT(DAY FROM date_day)                      AS day_of_month,
  EXTRACT(DAYOFWEEK FROM date_day)                AS day_of_week,
  EXTRACT(DOY FROM date_day)                      AS day_of_year,
  strftime(date_day, '%A')                        AS day_name,
  strftime(date_day, '%B')                        AS month_name,
  strftime(date_day, '%Y') || '-Q' ||
    CAST(EXTRACT(QUARTER FROM date_day) AS VARCHAR) AS year_quarter,
  strftime(date_day, '%Y-%m')                     AS year_month,
  CASE
    WHEN EXTRACT(DAYOFWEEK FROM date_day) IN (1, 7) THEN TRUE
    ELSE FALSE
  END                                             AS is_weekend
FROM date_spine
