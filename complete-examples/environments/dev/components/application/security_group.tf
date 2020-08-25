module "http_sg" {
  source      = "../../../../modules/security_group"
  name        = "http-sg"
  vpc_id      = module.network.vpc_id
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
}

# module "https_sg" {
#   source      = "../../../../modules/security_group"
#   name        = "https-sg"
#   vpc_id      = module.network.vpc_id
#   from_port   = 443
#   to_port     = 443
#   cidr_blocks = ["0.0.0.0/0"]
# }

module "ecs_sg" {
  source      = "../../../../modules/security_group"
  name        = "ecs-sg"
  vpc_id      = module.network.vpc_id
  from_port   = var.load_balancer_container_port
  to_port     = var.load_balancer_container_port
  cidr_blocks = [module.network.vpc_cidr_block]
}
