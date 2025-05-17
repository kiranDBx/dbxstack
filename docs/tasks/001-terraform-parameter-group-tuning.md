# Task 001: Terraform Parameter Group Tuning for PostgreSQL 17.5

**Date:** 2025-05-17  
**Objective:** Tune RDS parameter group for autovacuum, pg_stat_statements, and logging settings.

---

## Overview
Added custom AWS RDS parameter group using Terraform with PostgreSQL 17.5 engine family.

## Key Changes
- Created aws_db_parameter_group resource in Terraform
- Set parameters:
  - `log_statement = "ddl"`
  - `log_min_duration_statement = "1000"`
  - `pg_stat_statements.track = "all"`
  - `pg_stat_statements.max = "10000"`
  - `autovacuum_vacuum_cost_limit = "200"`

## Challenges & Notes
- Had to fix AWS CLI config & permissions before Terraform worked
- Ensured parameter group family matches exact PostgreSQL engine version "postgres17"
- Updated Terraform code to merge previous parameters with new ones

## Next Steps
- Apply terraform to US East RDS instance
- Monitor autovacuum logs & pg_stat_statements metrics

---

## Git Commit Reference

```bash
git commit -m "feat(terraform): add custom parameter group for PG 17.5 tuning"

