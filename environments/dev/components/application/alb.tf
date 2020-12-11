resource "aws_lb" "public_alb" {
  name                       = "public-alb-${var.env}"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = var.enable_deletion_protection # production では true にして削除保護を有効化する

  # ALB が所属するサブネット
  subnets = [
    module.network.public_subnet_1_id,
    module.network.public_subnet_2_id,
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = var.public_alb_access_logs_enabled
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
  ]

  tags = {
    Environment = var.env
    Name        = "public-alb-${var.env}"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HTTP"
      status_code  = "200"
    }
  }

  # Blue-Green Deployment 時の target-group 切り替えは無視
  lifecycle {
    ignore_changes = [default_action]
  }

  depends_on = [aws_lb.public_alb]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.acm_cert_arn_api # リスナーのデフォルト証明書(必須).
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HTTPS"
      status_code  = "200"
    }
  }

  # Blue-Green Deployment 時の target-group 切り替えは無視
  lifecycle {
    ignore_changes = [default_action]
  }

  depends_on = [aws_lb.public_alb]
}

# セカンダリーの証明書
resource "aws_lb_listener_certificate" "acm_cert_admin" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.acm_cert_arn_admin
}

# for Web API
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority = 1 # 低いほど優先度が高い. また, 同じ priority では定義できない.

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    host_header {
      values = [var.api_host_header]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  # Blue-Green Deployment 時に差分が出るため無視
  lifecycle {
    ignore_changes = [action]
  }

  depends_on = [aws_lb_target_group.green]
}

# for phpMyAdmin
resource "aws_lb_listener_rule" "myadmin" {
  listener_arn = aws_lb_listener.https.arn
  priority = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myadmin.arn
  }

  condition {
    host_header {
      values = [var.admin_host_header]
    }
  }

  condition {
    path_pattern {
      values = ["/index.php"]
    }
  }

  # Blue-Green Deployment 時に差分が出るため無視
  lifecycle {
    ignore_changes = [action]
  }

  depends_on = [aws_lb_target_group.admin_site]
}

# for Admin site
resource "aws_lb_listener_rule" "admin_site" {
  listener_arn = aws_lb_listener.https.arn
  priority = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_site.arn
  }

  condition {
    host_header {
      values = [var.admin_host_header]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  # Blue-Green Deployment 時に差分が出るため無視
  lifecycle {
    ignore_changes = [action]
  }

  depends_on = [aws_lb_target_group.admin_site]
}

resource "aws_lb_target_group" "blue" {
  name                 = "target-group-blue"
  target_type          = "ip"
  vpc_id               = module.network.vpc_id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.public_alb]
}

resource "aws_lb_target_group" "green" {
  name                 = "target-group-green"
  target_type          = "ip"
  vpc_id               = module.network.vpc_id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.public_alb]
}

resource "aws_lb_target_group" "myadmin" {
  name                 = "target-group-myadmin"
  vpc_id               = module.network.vpc_id
  port                 = 8081
  protocol             = "HTTP"

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.public_alb, aws_instance.for_admin]
}

resource "aws_lb_target_group_attachment" "myadmin" {
  target_group_arn = aws_lb_target_group.myadmin.arn
  target_id        = aws_instance.for_admin.id
  port             = 8081
}

resource "aws_lb_target_group" "admin_site" {
  name                 = "target-group-admin-site"
  vpc_id               = module.network.vpc_id
  port                 = 9000
  protocol             = "HTTP"

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.public_alb, aws_instance.for_admin]
}

resource "aws_lb_target_group_attachment" "admin_site" {
  target_group_arn = aws_lb_target_group.admin_site.arn
  target_id        = aws_instance.for_admin.id
  port             = 9000
}