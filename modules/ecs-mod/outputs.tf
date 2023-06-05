output "ecs_service_id" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.ecs.id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.ecs.name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.ecs.name
}

output "ecr_name" {
  description = "Name of the ECR"
  value       = aws_ecr_repository.prospa-app_repository.name
}

output "ecr_arn" {
  description = "ARN of the ECR"
  value       = aws_ecr_repository.prospa-app_repository.arn
}
