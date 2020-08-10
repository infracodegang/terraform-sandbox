data "aws_vpc" "main" {
  tags = {
    Name        = "vpc-${var.env}"
    Environment = var.env
  }
}

data "aws_subnet" "public_1" {
  tags = {
    Name        = "public-subnet-1-${var.env}"
    Environment = var.env
  }
}

data "aws_subnet" "public_2" {
  tags = {
    Name        = "public-subnet-2-${var.env}"
    Environment = var.env
  }
}

data "aws_subnet" "private_1" {
  tags = {
    Name        = "private-subnet-1-${var.env}"
    Environment = var.env
  }
}

data "aws_subnet" "private_2" {
  tags = {
    Name        = "private-subnet-2-${var.env}"
    Environment = var.env
  }
}

data "aws_kms_key" "main" {
  key_id = "alias/main_kms_alias"
}
