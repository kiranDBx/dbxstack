# Task 001: Terraform Parameter Group Tuning for PostgreSQL 17.5
**Date:** 2025-05-17
**Objective:** Tune RDS parameter group for autovacuum, pg_stat_statements, and logging settings.

---

## Overview

- Added custom AWS RDS parameter group using Terraform with PostgreSQL 17.5 engine family.
- Applied and verified parameter group settings via psql and AWS CLI.

---

## Key Changes

- Created `aws_db_parameter_group` resource in Terraform
- Set parameters:
  - `log_statement = "ddl"`
  - `log_min_duration_statement = "1000"`
  - `pg_stat_statements.track = "all"`
  - `pg_stat_statements.max = "10000"`
  - `autovacuum_vacuum_cost_limit = "200"`
  - `shared_preload_libraries = "pg_stat_statements"`

---

## Steps Performed

1. **Terraform apply:** Created and applied parameter group with tuned settings.
2. **Attached parameter group** to target PostgreSQL 17.5 RDS instance.
3. **Verified settings via psql:**

```sql
-- Check if autovacuum is enabled
SHOW autovacuum;

-- Check shared libraries include pg_stat_statements
SHOW shared_preload_libraries;

-- Enable pg_stat_statements extension
CREATE EXTENSION pg_stat_statements;

-- Confirm it's active
SELECT * FROM pg_extension WHERE extname = 'pg_stat_statements';
```

4. **Verified AWS-side configuration**:
```bash
aws rds describe-db-instances --db-instance-identifier <your-instance> --query "DBInstances[0].DBParameterGroups[*].DBParameterGroupName" --output text

aws rds describe-db-parameters --db-parameter-group-name <your-param-group> --query "Parameters[?ParameterName=='autovacuum' || ParameterName=='pg_stat_statements'].[ParameterName,ParameterValue]" --output table
```

---

## Outcome

- ✅ `autovacuum` is ON  
- ✅ `pg_stat_statements` loaded and working  
- ✅ Parameter group is applied and effective on the instance

---

## Challenges & Notes

- Fixed AWS CLI config and IAM permissions before Terraform succeeded
- Ensured exact parameter group family (`postgres17`) matched RDS engine version

---

## Next Steps

- Setup CloudWatch alarms for CPU, connections
- Install PG Exporter and Grafana for real-time dashboarding
- Add Secrets Manager rotation logic via Terraform

---

## Git Commit Reference

```bash
git commit -m "feat(terraform): add custom parameter group for PG 17.5 tuning and verified autovacuum + pg_stat_statements"
```
