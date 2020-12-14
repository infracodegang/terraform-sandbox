resource "aws_iam_instance_profile" "ec2_for_ssm" {
  name = "ec2-for-ssm"
  role = module.ec2_for_ssm_role.iam_role_name
}

resource "aws_instance" "for_admin" {
  ami                  = "ami-0c3fd0f5d33134a76" # Amazon Linux 2 AMI
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_for_ssm.name
  subnet_id            = module.network.private_subnet_1_id
  user_data            = data.template_file.provisioning_sh.rendered

  security_groups = [
    module.http_sg.security_group_id,
  ]

  tags = {
    Name        = "admin-${var.env}"
    Environment = var.env
  }
}

data "template_file" "provisioning_sh" {
  template = file("provisioning.sh")

  vars {
    docker_compose_version = "1.27.4"
    pma_version            = "5.0.0"
    vpc_cidr               = module.network.vpc_cidr_block
    admin_host             = var.admin_host
  }
}
