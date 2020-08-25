module "datasource" {
  source = "./datasource"
  env    = var.env
}

module "mysql_sg" {
  source      = "../../../../modules/security_group"
  name        = "mysql-sg"
  vpc_id      = module.datasource.vpc_id
  from_port   = 3306
  to_port     = 3306
  cidr_blocks = [module.datasource.vpc_cidr_block]
}

module "redis_sg" {
  source      = "../../../../modules/security_group"
  name        = "redis-sg"
  vpc_id      = module.datasource.vpc_id
  from_port   = 6379
  to_port     = 6379
  cidr_blocks = [module.datasource.vpc_cidr_block]
}
