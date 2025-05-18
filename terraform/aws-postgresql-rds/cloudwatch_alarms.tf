variable "rds_instance_identifier" {
  description = "The RDS instance identifier"
  type        = string
}

variable "alarm_email" {
  description = "Email for alarm notifications"
  type        = string
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.rds_instance_identifier}-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80% for 15 minutes"
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }
  alarm_actions       = [aws_sns_topic.rds_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "free_storage_low" {
  alarm_name          = "${var.rds_instance_identifier}-FreeStorageSpace-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 20000000000  # 20 GB (adjust as needed)
  alarm_description   = "Alarm when free storage drops below 20GB"
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }
  alarm_actions       = [aws_sns_topic.rds_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "db_connections_high" {
  alarm_name          = "${var.rds_instance_identifier}-DBConnections-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 90  # % of max connections if you want to calculate max externally or fixed number
  alarm_description   = "Alarm when DB connections exceed threshold"
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }
  alarm_actions       = [aws_sns_topic.rds_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_low" {
  alarm_name          = "${var.rds_instance_identifier}-FreeableMemory-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 500000000  # ~500MB
  alarm_description   = "Alarm when freeable memory is low"
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }
  alarm_actions       = [aws_sns_topic.rds_alerts.arn]
}

resource "aws_sns_topic" "rds_alerts" {
  name = "${var.rds_instance_identifier}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.rds_alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}
