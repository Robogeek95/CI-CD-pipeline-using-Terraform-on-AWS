variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zone for the subnet"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR block for the public subnet"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR block for the private subnet"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}
