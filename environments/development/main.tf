module "vpc" {
  source = "../../modules/vpc-mod"

  vpc_cidr_block             = "10.0.0.0/16"
  vpc_name                   = "prospa_app-vpc"
  availability_zones         = ["us-west-2a", "us-west-2b"]
  public_subnet_cidr_blocks  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnet_cidr_blocks = ["10.0.32.0/20", "10.0.48.0/20"]
}

module "ecs_frontend_app" {
  source = "../../modules/ecs-mod"

  cluster_name           = "ecs_frontend_app"
  task_definition_family = "ecs_frontend_app-definition"
  task_cpu               = 256
  task_memory            = 512
  container_image        = "ecs_frontend_app:latest"
  container_port         = 80
  host_port              = 80
  log_group_name         = "/ecs/ecs_frontend_app-logs"
  desired_count          = 2
  health_check_path      = "/health"
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.public_subnet_ids[0]
  security_id            = module.vpc.public_security_group_id
  lb_target_group_arn    = module.load_balancer.target_group_arn
}

/* module "database" {
  source = "../../modules/rds-mod"

  subnet_group_name      = "prospa-app-db-subnet-group"
  db_instance_identifier = "prospa-app-db-instance"
  instance_type          = "db.t2.micro"
  storage_size           = 20
  db_username            = "admin"
  db_password            = "password123"
  security_group_id      = module.vpc.private_security_group_id
  private_subnet_ids     = module.vpc.private_subnet_ids
} */

module "load_balancer" {
  source             = "../../modules/alb-mod"
  load_balancer_name = "prospa-app-load-balancer"
  subnet_ids         = module.vpc.public_subnet_ids
  target_group_name  = "prospa-app-target-group"
  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc.public_security_group_id]
  health_check_path  = "/health"
}
