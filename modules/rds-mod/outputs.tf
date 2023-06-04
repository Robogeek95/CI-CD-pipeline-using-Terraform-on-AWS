output "db_instance_endpoint" {
  description = "Endpoint of the RDS database instance"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_identifier" {
  description = "Identifier of the RDS database instance"
  value       = aws_db_instance.main.id
}
