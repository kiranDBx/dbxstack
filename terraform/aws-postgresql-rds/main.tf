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

# SNS Topic for alarms
resource "aws_sns_topic" "alarm_topic" {
  name = "${var.db_identifier}-alarm-topic"
}

# SNS Subscription for email alert
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# CloudWatch Alarm for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "${var.db_identifier}-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU exceeds 70%"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgres1.identifier
  }
}

