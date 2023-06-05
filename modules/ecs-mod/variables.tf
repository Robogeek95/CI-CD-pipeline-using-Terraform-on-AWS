variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "task_definition_family" {
  description = "Family name of the ECS task definition"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the ECS task (in MiB)"
  type        = number
  default     = 512
}

variable "container_image" {
  description = "Container image for the ECS task"
  type        = string
}

variable "container_port" {
  description = "Port number exposed by the container"
  type        = number
}

variable "host_port" {
  description = "Port number on the host (optional, 0 for dynamic port assignment)"
  type        = number
  default     = 0
}

variable "log_retention_in_days" {
  description = "Number of days the logs will be retained in CloudWatch."
  default     = 30
  type        = number
}

variable "desired_count" {
  description = "Desired number of tasks running in the ECS service"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "Path for the target group health check"
  type        = string
  default     = "/"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "region" {
  description = "AWS region to provision resources"
  type        = string
  default     = "us-west"
}

variable "security_id" {
  description = "Security Group ID to attach to ecs instance"
  type        = string
}

variable "ecr_name" {
  description = "Name of the ECR"
  type        = string
  default     = "prospa-app-ecr-repo"
}

variable "lb_target_group_arn" {
  description = "Loadbalancer target group arn"
  type        = string
}
