-- staging: production_document
{{ config(materialized='view') }}

SELECT
  CAST(DocumentNode AS VARCHAR)              AS document_node,
  CAST(DocumentLevel AS INT64)               AS document_level,
  Title                                      AS title,
  CAST(Owner AS INT64)                       AS owner,
  CASE WHEN FolderFlag = 1 THEN TRUE ELSE FALSE END AS folder_flag,
  FileName                                   AS file_name,
  FileExtension                              AS file_extension,
  Revision                                   AS revision,
  CAST(ChangeNumber AS INT64)                AS change_number,
  CASE WHEN Status = 1 THEN TRUE ELSE FALSE END AS status,
  DocumentSummary                            AS document_summary
FROM {{ source('adventureworks', 'production_document') }}
