variable "aws_region" {
  description = "AWS Region in which to create the project resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short name used to name and tag resources."
  type        = string
  default     = "cloud-status-dashboard"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,31}$", var.project_name))
    error_message = "project_name must be 3-32 lowercase letters, numbers, or hyphens and start with a letter."
  }
}

variable "image_tag" {
  description = "ECR image tag deployed by the ECS task definition."
  type        = string
  default     = "latest"
}

variable "deploy_application" {
  description = "Create the ECS task definition and service after the first container image has been pushed to ECR."
  type        = bool
  default     = false
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
  default     = 8080
}
