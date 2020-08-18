resource "aws_iam_instance_profile" "ec2_for_ssm" {
  name = "ec2-for-ssm"
  role = module.ec2_for_ssm_role.iam_role_name
}

resource "aws_instance" "for_operation" {
  ami                  = "ami-0c3fd0f5d33134a76" # Amazon Linux 2 AMI
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_for_ssm.name
  subnet_id            = module.datasource.private_subnet_1_id
  user_data            = file("./user_data.sh")
}
