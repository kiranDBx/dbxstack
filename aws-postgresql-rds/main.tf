provider "aws" {
  region = var.aws_region
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "rds/dev-postgres/postgres1/kkpostgres"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "kkpostgres"
    password = var.db_password
  })
}

locals {
  db_creds = jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string)
}

resource "aws_db_instance" "postgres1" {
  identifier             = var.db_identifier           # will be "postgres1"
  allocated_storage      = var.db_allocated_storage
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = local.db_creds.username     
  password               = local.db_creds.password
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.security_group_id]
  parameter_group_name = aws_db_parameter_group.pg17_custom.name   #updated Implementation of Parameter Group Tuning

}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}
