variable "aws_region" {}
variable "db_identifier" {}
variable "db_allocated_storage" {}
variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_name" {}

# Removed db_username and db_password because we're using Secrets Manager
#variable "db_username" {}
#variable "db_password" {}

variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}
