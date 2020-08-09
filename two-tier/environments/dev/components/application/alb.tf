resource "aws_lb" "public_alb" {
  name                       = "public-alb-${var.env}"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = var.public_alb_idle_timeout
  enable_deletion_protection = var.enable_deletion_protection # production では true にして削除保護を有効化する

  subnets = [
    module.datasource.public_subnet_1_id,
    module.datasource.public_subnet_2_id,
  ]

  access_logs {
    bucket  = module.datasource.alb_log_bucket_id
    enabled = var.public_alb_access_logs_enabled
  }

  security_groups = [
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]

  tags = {
    Environment = var.env
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_lb.public_alb]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.acm_cert.arn
  ssl_policy        = var.ssl_policy

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }

  depends_on = [aws_lb.public_alb, aws_acm_certificate.acm_cert]
}

resource "aws_lb_target_group" "ecs_1" {
  name                 = "target-group-ecs-1"
  target_type          = "ip"
  vpc_id               = module.datasource.vpc_id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.public_alb]
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_1.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  depends_on = [aws_lb_target_group.ecs_1]
}
