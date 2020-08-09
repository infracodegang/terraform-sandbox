module "datasource" {
  source         = "./datasource"
  env            = var.env
  alb_log_bucket = var.alb_log_bucket
}

module "http_redirect_sg" {
  source      = "../../../../modules/security_group"
  name        = "http-redirect-sg"
  vpc_id      = module.datasource.vpc_id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source      = "../../../../modules/security_group"
  name        = "https-sg"
  vpc_id      = module.datasource.vpc_id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}
