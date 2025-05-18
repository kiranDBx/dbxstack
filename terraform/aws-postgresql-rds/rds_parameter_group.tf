resource "aws_db_parameter_group" "pg17_custom" {
  name        = "pg17-custom-params"
  family      = "postgres17"
  description = "PostgreSQL 17.5 tuning: autovacuum, logging, stat_statements"

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
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
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  parameter {
    name  = "autovacuum_naptime"
    value = "20"
    apply_method = "pending-reboot"  # for static params
  }

  parameter {
    name  = "autovacuum_vacuum_cost_limit"
    value = "200"
  }

  parameter {
    name  = "autovacuum_vacuum_threshold"
    value = "50"
  }

  parameter {
    name  = "autovacuum_analyze_threshold"
    value = "50"
  }
}
