# my_first_project

dbt learning project using DuckDB with AdventureWorks sample data.

## Models

| Layer | Description | Key Models |
|-------|-------------|------------|
| **staging** | Clean raw data, rename columns, cast types | stg_customer, stg_sales_order_header, stg_product, etc. |
| **intermediate** | Business joins, enrichments | int_person_overview |
| **marts** | Fact tables for analytics | fct_orders (incremental) |

## Key Features

- **Incremental model** — fct_orders uses `incremental` strategy with `merge`
- **Status labels** — Order status codes translated to Chinese labels
- **Post-hook** — Auto-log row counts to `audit.row_counts` after each build
- **Exposure** — Declared downstream consumers for lineage tracking
- **SCD Type 2** — Customer snapshot tracking with dbt snapshots
- **Tests** — Generic tests (not_null, unique, relationships) + custom singular tests

## Run

```bash
cd src/my_first_project
dbt deps          # Install packages
dbt build         # Build all models, seeds, snapshots, tests
dbt docs serve    # View documentation
```

## Dependencies

- dbt-core
- dbt-duckdb
- dbt-utils (packages.yml)
