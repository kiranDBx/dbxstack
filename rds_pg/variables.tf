variable "db_name" {
  default = "postgres"
}

variable "db_username" {
  default = "postgresadmin"
}

variable "db_password" {
  default = "k1ran123"
}

variable "sg_id" {
  description = "Security Group ID with port 5432 allowed"
  type        = string
}

