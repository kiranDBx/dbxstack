# 🐘 AWS RDS PostgreSQL with Terraform

Deploy a PostgreSQL instance on AWS RDS using Terraform.

## 🔧 Requirements

- AWS account with access keys set (`aws configure`)
- Terraform installed
- Security group that allows port 5432 inbound from your IP

## 📁 Files

- `main.tf` — main infra definition
- `variables.tf` — input variables
- `terraform.tfvars` — actual values
- `outputs.tf` — connection endpoint

## 🚀 Steps to Deploy

```bash
cd terraform/aws-postgresql-rds/

terraform init
terraform plan
terraform apply
