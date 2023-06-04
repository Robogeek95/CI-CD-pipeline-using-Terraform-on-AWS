output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.*.id
}

output "private_security_group_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private.id
}

output "public_security_group_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public.id
}
