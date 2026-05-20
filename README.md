# dbt Learn

A hands-on dbt learning project with DuckDB, covering the full dbt development lifecycle from staging to production-grade deployment.

## Project Structure

```
src/
  my_first_project/       # Main dbt project
    models/
      staging/           # Raw data → staging (sources.yml, stg_*)
      intermediate/      # Business logic, joins
      marts/             # Final fact & dimension tables
    seeds/               # AdventureWorks sample data
    snapshots/           # SCD Type 2 snapshots
    tests/               # Custom + generic data tests
    macros/              # Reusable Jinja macros
    analyses/            # Ad-hoc queries
```

## Architecture

```
Raw Seeds → Staging Layer → Intermediate → Marts → Exposure (Dashboard)
                        ↓
              Tests + Documentation
```

## Pipeline

- **staging:** Raw CSV seeds → cleaned staging models
- **intermediate:** Business joins, aggregation
- **marts:** Fact tables + dimension-like outputs
- **snapshots:** Slowly Changing Dimension Type 2
- **tests:** Generic + singular tests with dbt-utils

## Tech Stack

| Component | Tool |
|-----------|------|
| Transformation | dbt-core + dbt-duckdb |
| Database | DuckDB (local dev) |
| CI | GitHub Actions (dbt build per PR) |
| Scheduling | Airflow + astronomer-cosmos (planned) |

## Getting Started

```bash
# Install dependencies
pip install dbt-core dbt-duckdb

# Install dbt packages
cd src/my_first_project
dbt deps

# Run full pipeline
dbt build

# Generate docs
dbt docs generate
dbt docs serve
```

## Prerequisites

This is a learning project based on [dbt Learn](https://github.com/raycdut/dbt-learn). It uses AdventureWorks sample data seeded directly into DuckDB — no external database required.

## License

MIT
