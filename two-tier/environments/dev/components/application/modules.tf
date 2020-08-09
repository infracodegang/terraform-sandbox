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

module "ecs_sg" {
  source      = "../../../../modules/security_group"
  name        = "ecs-sg"
  vpc_id      = module.datasource.vpc_id
  port        = 80
  cidr_blocks = [module.datasource.vpc_cidr_block]
}

module "ecs_task_execution_role" {
  source     = "../../../../modules/iam_role"
  name       = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}

module "ecs_events_role" {
  source     = "../../../../modules/iam_role"
  name       = "ecs-events"
  identifier = "events.amazonaws.com"
  policy     = data.aws_iam_policy.ecs_events_role_policy.policy
}
