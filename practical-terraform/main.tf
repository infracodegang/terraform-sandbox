provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

module "web_server" {
  source        = "./http_server"
  instance_type = "t3.micro"
}

module "describe_regions_for_ec2" {
  source     = "./iam_role"
  name       = "describe-regions-for-ec2"
  identifier = "ec2.amazonaws.com"
  policy     = module.describe_regions_for_ec2.describe_regions_json
}

output "public_dns" {
  value = module.web_server.public_dns
}
