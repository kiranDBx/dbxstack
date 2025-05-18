#!/bin/bash

# Set variables
DB_INSTANCE_ID="pg17-db"
PARAMETER_GROUP_NAME="pg17-custom-params"
REGION="us-east-1"

# Optional: Check RDS instance uptime before reboot (for logs/blog)
echo "🔍 Current RDS instance uptime and status:"
aws rds describe-db-instances \
  --db-instance-identifier "$DB_INSTANCE_ID" \
  --region "$REGION" \
  --query "DBInstances[0].{Status:DBInstanceStatus,InstanceCreateTime:InstanceCreateTime}" \
  --output table

echo ""
echo "⚙️  Modifying static parameters..."
aws rds modify-db-parameter-group \
  --db-parameter-group-name "$PARAMETER_GROUP_NAME" \
  --parameters "ParameterName=shared_preload_libraries,ParameterValue=pg_stat_statements,ApplyMethod=pending-reboot" \
  --region "$REGION"

echo ""
echo "🔁 Rebooting the RDS instance to apply static parameters..."
aws rds reboot-db-instance \
  --db-instance-identifier "$DB_INSTANCE_ID" \
  --region "$REGION"

echo ""
echo "⏳ Waiting for instance to become available again..."
aws rds wait db-instance-available \
  --db-instance-identifier "$DB_INSTANCE_ID" \
  --region "$REGION"

echo ""
echo "✅ Done. Fetching post-reboot instance info..."
aws rds describe-db-instances \
  --db-instance-identifier "$DB_INSTANCE_ID" \
  --region "$REGION" \
  --query "DBInstances[0].{Status:DBInstanceStatus,InstanceCreateTime:InstanceCreateTime}" \
  --output table
