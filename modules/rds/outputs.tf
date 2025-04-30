output "rds_endpoint" {
  description = "The RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.address
}

output "rds_id" {
  description = "The RDS PostrgreSQL id"
  value       = aws_db_instance.postgres.id
}