resource "aws_db_subnet_group" "main" {
  name       = var.subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = var.subnet_group_name
  }
}

resource "aws_db_instance" "main" {
  identifier             = var.db_instance_identifier
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_type
  allocated_storage      = var.storage_size
  storage_type           = "gp2"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  publicly_accessible    = false

  tags = {
    Name = var.db_instance_identifier
  }
}
