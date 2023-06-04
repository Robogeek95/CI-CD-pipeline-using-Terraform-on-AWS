variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the load balancer"
  type        = list(string)
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the load balancer will be created"
  type        = string
}

variable "health_check_path" {
  description = "Path for the target group health check"
  type        = string
  default     = "/"
}
