# 🛠️ AWS PostgreSQL RDS Deployment using Terraform + Secrets Manager

This module demonstrates deploying a secure PostgreSQL RDS instance using Terraform, AWS Secrets Manager, and best practices to avoid hardcoded credentials.

---

## ✅ Workflow Summary

### 1. **Initial RDS Setup via Terraform**
- Used `terraform.tfvars` to pass:
  - `db_username = "postgres"`
  - `db_password = "MySecurePassword123"`
- Created:
  - Custom VPC + Subnets
  - Security Group allowing port 5432
  - RDS instance with PostgreSQL engine

---

### 2. **Moved to Secrets Manager for Credentials**
- Created AWS secret:  
  `rds/dev-postgres/testdb/testuser`
- Initially stored:
  ```json
  {
    "username": "testuser",
    "password": "Test@123"
  }
  ```
- Replaced hardcoded creds in Terraform:
  ```hcl
  data "aws_secretsmanager_secret_version" "db_secret" {
    secret_id = "rds/dev-postgres/testdb/testuser"
  }

  username = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)["password"]
  ```

---

### 3. **Issues Faced & Fixes**
- ❌ Terraform tried to recreate RDS because `testuser ≠ postgres` (RDS master user mismatch)
- ✅ Solution:
  - Updated the secret to:
    ```json
    {
      "username": "postgres",
      "password": "MySecurePassword123"
    }
    ```
  - Used:
    ```bash
    aws secretsmanager update-secret --secret-id rds/dev-postgres/testdb/testuser --secret-string file://secret.json
    ```

---

### 4. **IAM Permissions**
- ❌ `AccessDeniedException` while updating secret
- ✅ Fix:
  - Updated IAM policy to allow:
    ```json
    "Action": [
      "secretsmanager:UpdateSecret",
      "secretsmanager:GetSecretValue"
    ]
    ```

---

### 5. **Final Stable State**
- Terraform shows:
  ```
  aws_db_instance.postgres: Modifying... [id=...]
  aws_db_instance.postgres: Modifications complete after 0s
  ```
- Secret has the correct master user creds
- Terraform no longer triggers RDS replacement

---

## 🔑 Best Practices

- **Use Secrets Manager** to store sensitive data
- Match RDS `master_username` with secret `"username"`
- Use `jsondecode()` for secret access
- Avoid hardcoding creds in any `.tfvars` or `.tf` files
- Use descriptive secret names like:  
  `rds/<instance>/<role>/<user>`

---

## 🧪 Tested With
- AWS Free Tier (eu-north-1)
- PostgreSQL engine 15.x
- Terraform v1.5+
- AWS CLI v2

---

## 📂 Directory Structure

```
aws-postgresql-rds/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── secret.json (for manual updates)
└── README.md
```

---

## 🙌 Author

Kiran | [GitHub @kiranDBx](https://github.com/kiranDBx)  
Blog: *Coming Soon — `Beyond Titles — The Quiet Power of Owning Your Stack`*