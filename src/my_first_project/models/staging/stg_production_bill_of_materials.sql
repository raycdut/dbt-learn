-- staging: production_bill_of_materials
{{ config(materialized='view') }}

SELECT
  CAST(BillOfMaterialsID AS INT64)   AS bill_of_materials_id,
  CAST(ProductAssemblyID AS INT64)   AS product_assembly_id,
  CAST(ComponentID AS INT64)         AS component_id,
  TRY_CAST(StartDate AS DATE)        AS start_date,
  TRY_CAST(EndDate AS DATE)          AS end_date,
  UnitMeasureCode                    AS unit_measure_code,
  CAST(BOMLevel AS INT64)            AS bom_level,
  CAST(PerAssemblyQty AS INT64)      AS per_assembly_qty
FROM {{ source('adventureworks', 'production_bill_of_materials') }}
