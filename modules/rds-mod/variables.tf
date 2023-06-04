variable "subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

variable "db_instance_identifier" {
  description = "Identifier for the DB instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the DB instance"
  type        = string
  default     = "db.t2.micro"
}

variable "storage_size" {
  description = "Allocated storage size for the DB instance (in GB)"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Username for the DB instance"
  type        = string
}

variable "db_password" {
  description = "Password for the DB instance"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(string)
}
