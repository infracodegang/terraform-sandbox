# https://aws.amazon.com/jp/blogs/news/aws-fargate-launches-platform-version-1-4/?sc_channel=sm&sc_campaign=AWS_Blog,launch_&sc_publisher=TWITTER&sc_country=Japan&sc_geo=JAPAN&sc_outcome=awareness&trkCampaign=c&trk=aws-fargate-launches-platform-version-1-4_TWITTER&sc_content=aws-fargate-launches-platform-version-1-4&sc_category=AWS+Fargate&linkId=87467865
# https://blog.fakiyer.com/entry/2020/05/11/184759
# https://dev.classmethod.jp/articles/privatesubnet_ecs/
module "ecs_private_link_sg" {
  source      = "../../../../modules/security_group"
  name        = "ecs-private-link-sg"
  vpc_id      = aws_vpc.main.id
  from_port   = 443
  to_port     = 443
  cidr_blocks = [var.vpc_cidr_block]
}
