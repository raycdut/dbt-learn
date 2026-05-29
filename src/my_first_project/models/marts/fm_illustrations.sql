-- fact: illustrations (diagram XML for analysis)
{{ config(materialized='table') }}

SELECT
  i.illustration_id,
  i.diagram,
  -- related product model (via bridge)
  pmi.product_model_id
FROM {{ ref('stg_production_illustration') }} i
LEFT JOIN {{ ref('stg_production_product_model_illustration') }} pmi
  ON i.illustration_id = pmi.illustration_id
