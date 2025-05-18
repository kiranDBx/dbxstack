output "db_endpoint" {
  value = aws_db_instance.postgres17.endpoint
}

output "secrets_arn" {
  value = aws_secretsmanager_secret.pg_secret.arn
}
