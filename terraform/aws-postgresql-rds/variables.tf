variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage size for RDS instance (in GB)"
  type        = number
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_password" {
  description = "Password for the database user"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS placement"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for RDS instance"
  type        = string
}

#variable "alarm_email" {
#  description = "Email to receive CloudWatch alarm notifications"
#  type        = string
#}

variable "sns_topic_arn" {
  description = "SNS topic ARN for alarm notifications"
  type        = string
}
