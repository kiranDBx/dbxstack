provider "aws" {
  region     = "us-east-1"

}

resource "aws_secretsmanager_secret" "pg_secret" {
  name = "pg-db-secret"
}

resource "aws_secretsmanager_secret_version" "pg_secret_version" {
  secret_id     = aws_secretsmanager_secret.pg_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

resource "aws_db_instance" "postgres17" {
  identifier             = "pg17-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "17.5"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = 5432
  publicly_accessible    = true
  skip_final_snapshot    = true
  backup_retention_period = 0

  vpc_security_group_ids = [var.sg_id]
  db_subnet_group_name = aws_db_subnet_group.pg_subnet_group.name
  parameter_group_name = aws_db_parameter_group.pg17_custom.name

}

resource "aws_db_subnet_group" "pg_subnet_group" {
  name       = "pg-db-subnet-group"
  subnet_ids = [
    "subnet-04a5a2616783899f9",
    "subnet-0b9afa4903db9f1d9"
  ]

  tags = {
    Name = "pg-db-subnet-group"
  }
}
