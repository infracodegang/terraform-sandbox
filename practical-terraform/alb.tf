data "aws_route53_zone" "example" {
  name = "perforb.net"
}

resource "aws_lb" "example" {
  name                       = "example"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false # production では削除保護を有効化する

  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTP』です"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.example.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.example.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTPS』です"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.example.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "example" {
  name                 = "example"
  target_type          = "ip"
  vpc_id               = aws_vpc.example.id
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

  depends_on = [aws_lb.example]
}

resource "aws_lb_listener_rule" "example" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_route53_record" "example" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = data.aws_route53_zone.example.name
  type    = "A"

  alias {
    name                   = aws_lb.example.dns_name
    zone_id                = aws_lb.example.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "example" {
  domain_name               = aws_route53_record.example.name
  subject_alternative_names = []
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example_certificate" {
  name    = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.example.domain_validation_options[0].resource_record_value]
  zone_id = data.aws_route53_zone.example.id
  ttl     = 60
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [aws_route53_record.example_certificate.fqdn]
}

module "http_sg" {
  source      = "./modules/security_group"
  name        = "http-sg"
  vpc_id      = aws_vpc.example.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source      = "./modules/security_group"
  name        = "https-sg"
  vpc_id      = aws_vpc.example.id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source      = "./modules/security_group"
  name        = "http-redirect-sg"
  vpc_id      = aws_vpc.example.id
  port        = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
}

output "domain_name" {
  value = aws_route53_record.example.name
}

