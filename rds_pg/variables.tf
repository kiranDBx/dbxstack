variable "db_name" {
  default = "postgres"
}

variable "db_username" {
  default = "pg*****dmin"
}

variable "db_password" {
  default = "******"
}

variable "sg_id" {
  description = "Security Group ID with port 5432 allowed"
  type        = string
}

