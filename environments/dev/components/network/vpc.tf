resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-${var.env}"
    Environment = var.env
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "igw-${var.env}"
    Environment = var.env
  }
}

# https://dev.classmethod.jp/articles/fargate_pv14_vpc_endpoint/
# https://dev.classmethod.jp/articles/privatesubnet_ecs/
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]
  security_group_ids  = [module.ecs_private_link_sg.security_group_id]
  private_dns_enabled = true

  tags = {
    Name        = "vpc_endpoint_logs"
    Environment = var.env
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]
  security_group_ids  = [module.ecs_private_link_sg.security_group_id]
  private_dns_enabled = true

  tags = {
    Name        = "vpc_endpoint_ecr_dkr"
    Environment = var.env
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]
  security_group_ids  = [module.ecs_private_link_sg.security_group_id]
  private_dns_enabled = true

  tags = {
    Name        = "vpc_endpoint_ecr_api"
    Environment = var.env
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]
  security_group_ids  = [module.ecs_private_link_sg.security_group_id]
  private_dns_enabled = true

  tags = {
    Name        = "vpc_endpoint_ssm"
    Environment = var.env
  }
}