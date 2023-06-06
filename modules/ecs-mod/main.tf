resource "aws_ecs_cluster" "ecs" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "ecs" {
  family                   = var.task_definition_family
  execution_role_arn       = aws_iam_role.execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  task_role_arn            = aws_iam_role.task.arn

  container_definitions    = <<DEFINITION
[
  {
    "name": "app",
    "image": "${var.container_image}",
    "cpu": ${var.task_cpu},
    "memory": ${var.task_memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.host_port},
        "protocol": "HTTP"
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "ecs" {
  name            = "${var.cluster_name}_service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    security_groups  = var.security_ids
    subnets          = var.subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }
}

resource "aws_ecr_repository" "prospa-app_repository" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = var.cluster_name

  retention_in_days = var.log_retention_in_days
  /* kms_key_id        = var.logs_kms_key */
}
