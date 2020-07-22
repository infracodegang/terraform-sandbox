# module "web_server" {
#   source        = "./modules/http_server"
#   instance_type = "t3.micro"
# }

# module "describe_regions_for_ec2" {
#   source     = "./modules/iam_role"
#   name       = "describe-regions-for-ec2"
#   identifier = "ec2.amazonaws.com"
#   policy     = module.describe_regions_for_ec2.describe_regions_json
# }

# module "example_sg" {
#   source      = "./modules/security_group"
#   name        = "module-sg"
#   vpc_id      = aws_vpc.example.id
#   port        = 80
#   cidr_blocks = ["0.0.0.0/0"]
# }

# output "public_dns" {
#   value = module.web_server.public_dns
# }
