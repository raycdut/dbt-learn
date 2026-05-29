-- fact: documents (XML text for analysis)
{{ config(materialized='table') }}

SELECT
  d.document_node,
  d.document_level,
  d.title,
  d.owner,
  d.folder_flag,
  d.file_name,
  d.file_extension,
  d.revision,
  d.change_number,
  d.status,
  d.document_summary,
  -- related product (via bridge table)
  pd.product_id
FROM {{ ref('stg_production_document') }} d
LEFT JOIN {{ ref('stg_production_product_document') }} pd
  ON d.document_node = pd.document_node
