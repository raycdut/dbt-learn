-- dimension: product description
{{ config(materialized='table') }}

SELECT
  pd.product_description_id,
  pd.description AS product_description,
  -- also attach culture via bridge table
  bpc.culture_id,
  bpc.product_model_id
FROM {{ ref('stg_production_product_description') }} pd
LEFT JOIN {{ ref('stg_production_product_model_pd_culture') }} bpc
  ON pd.product_description_id = bpc.product_description_id
