resource "aws_lb" "main" {
  name               = var.load_balancer_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnet_ids

  tags = {
    Name = var.load_balancer_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = var.health_check_path
  }

  tags = {
    Name = var.target_group_name
  }
}

resource "aws_lb_listener_rule" "http_redirect" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = ["*"]
    }
  }
}
