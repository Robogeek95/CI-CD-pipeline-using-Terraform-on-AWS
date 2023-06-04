locals {
  private_security_group_name = "private security group"
  public_security_group_name  = "public security group"
  private_subnet_name         = "private subnet"
  public_subnet_name          = "public subnet"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = length(var.public_subnet_cidr_blocks) == length(var.availability_zones) ? var.public_subnet_cidr_blocks[count.index] : cidrsubnet(var.vpc_cidr_block, 8, count.index + 1)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-%s", var.availability_zones[count.index], local.public_subnet_name)
  }
}

resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = length(var.private_subnet_cidr_blocks) == length(var.availability_zones) ? var.private_subnet_cidr_blocks[count.index] : cidrsubnet(var.vpc_cidr_block, 8, count.index + 2)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = format("%s-%s", var.availability_zones[count.index], local.private_subnet_name)
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public.*.id)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "public" {
  name        = local.public_security_group_name
  description = "Security group for the public subnet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.public_security_group_name
  }
}

resource "aws_security_group" "private" {
  name        = local.private_security_group_name
  description = "Security group for the private subnet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.private_security_group_name
  }
}
