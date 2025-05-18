variable "aws_region" {}

variable "db_identifier" {}

variable "db_allocated_storage" {}

variable "db_engine_version" {}

variable "db_instance_class" {}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {}
