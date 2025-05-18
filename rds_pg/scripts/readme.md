# RDS PostgreSQL Static Parameter Update Scripts

## Purpose

This folder contains scripts used to:
- Backup the DB parameter group
- Modify static parameters (like `shared_preload_libraries`)
- Trigger a reboot to apply changes
- Log the update process

## Files

| File                                | Description |
|-------------------------------------|-------------|
| `update_static_param_and_reboot.sh` | Bash script to update static param and reboot |
| `pg17-custom-params-backup.json`    | Backup of parameter group before change        |
| `static_param_reboot.log`           | Log output of the script run                   |
| `readme.md`                         | This file                                      |

## Commands Used

### Backup parameter group:
```bash
aws rds describe-db-parameters \
  --db-parameter-group-name pg17-custom-params \
  --region us-east-1 \
  --output json > pg17-custom-params-backup.json
