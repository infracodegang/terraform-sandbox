data "aws_lb" "public_alb" {
  tags = {
    Environment = var.env
    Name        = "public-alb-${var.env}"
  }
}

data "aws_lb_listener" "http" {
  load_balancer_arn = data.aws_lb.public_alb.arn
  port              = 80
}

# data "aws_lb_listener" "https" {
#   load_balancer_arn = data.aws_lb.public_alb.arn
#   port              = 443
# }
