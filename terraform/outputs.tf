output "aws_region" {
  description = "AWS Region containing the project resources."
  value       = var.aws_region
}

output "ecr_repository_name" {
  description = "Name of the ECR repository."
  value       = aws_ecr_repository.app.name
}

output "ecr_repository_url" {
  description = "Repository URL used to tag and push the Docker image."
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.app.name
}

output "application_url" {
  description = "Public HTTP URL. It returns a 503 until deploy_application is enabled and the ECS service becomes healthy."
  value       = "http://${aws_lb.app.dns_name}"
}

output "cloudwatch_log_group" {
  description = "CloudWatch Logs group receiving container output."
  value       = aws_cloudwatch_log_group.app.name
}
