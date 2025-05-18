resource "aws_db_parameter_group" "pg17_custom" {
  name        = "pg17-custom-params"
  family      = "postgres17"
  description = "PostgreSQL 17.5 tuning: autovacuum, logging, stat_statements"

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  parameter {
    name  = "pg_stat_statements.track"
    value = "all"
  }

  parameter {
    name  = "pg_stat_statements.max"
    value = "10000"
  }

  parameter {
    name  = "autovacuum_vacuum_cost_limit"
    value = "200"
  }
}
