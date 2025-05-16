provider "aws" {
  region = var.aws_region
}


resource "aws_db_instance" "postgres" {
  identifier             = var.db_identifier
  allocated_storage      = var.db_allocated_storage
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  #username               = var.db_username
  #password               = var.db_password
  username               = local.db_creds.username
  password               = local.db_creds.password 
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.security_group_id]
}

data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = "rds/dev-postgres/testdb/testuser"
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)
}


resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}
