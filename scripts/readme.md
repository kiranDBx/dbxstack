RDS Static Parameter Update Script
This script handles updating static parameters in an AWS RDS parameter group and reboots the RDS instance to apply changes. It complements Terraform-managed dynamic parameters which don’t require reboot.

Prerequisites
AWS CLI installed & configured with appropriate IAM permissions

RDS instance and parameter group exist and names updated in the script

Recommended: Create a manual DB snapshot before running (see below)

Before You Run
Create a DB Snapshot (Backup)
bash
Copy
Edit
aws rds create-db-snapshot \
  --db-instance-identifier <your-db-instance-id> \
  --db-snapshot-identifier <snapshot-name> \
  --region <your-region>
Verify Snapshot Status
bash
Copy
Edit
aws rds describe-db-snapshots \
  --db-snapshot-identifier <snapshot-name> \
  --region <your-region> \
  --query 'DBSnapshots[0].[Status,SnapshotCreateTime]'
Running the Script
bash
Copy
Edit
bash update_static_param_and_reboot.sh > static_param_reboot.log 2>&1
This will update static parameters and reboot the instance.

All output, including errors, will be logged to static_param_reboot.log.

Monitor the log to check progress or errors.

Check RDS Instance Status
bash
Copy
Edit
aws rds describe-db-instances \
  --db-instance-identifier <your-db-instance-id> \
  --region <your-region> \
  --query 'DBInstances[0].[DBInstanceStatus,LatestRestorableTime]'
Rollback (if needed)
If something goes wrong, you can restore your instance from the snapshot:

bash
Copy
Edit
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier <new-db-instance-id> \
  --db-snapshot-identifier <snapshot-name> \
  --region <your-region>
Git Commit & Push
After successful validation, commit and push your updated scripts:

bash
Copy
Edit
git add scripts/
git commit -m "Add static param update script with reboot and logging"
git push origin main
Pro tip: Keep your infrastructure changes versioned and backed up for safe rollback and audit.
