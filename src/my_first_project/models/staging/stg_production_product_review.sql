-- staging: production product review
{{ config(materialized='view') }}

SELECT
  CAST(ProductReviewID AS INT64) AS product_review_id,
  CAST(ProductID AS INT64)       AS product_id,
  ReviewerName                   AS reviewer_name,
  TRY_CAST(ReviewDate AS DATE)   AS review_date,
  EmailAddress                   AS email_address,
  CAST(Rating AS INT64)          AS rating,
  Comments                       AS comments
FROM {{ source('adventureworks', 'production_product_review') }}
