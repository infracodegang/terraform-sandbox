data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${module.datasource.alb_log_bucket_id}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.alb_logger.ap-northeast-1]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "ecs_events_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  # 既存のポリシーの継承
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"] # 追加で付与する権限
    resources = ["*"]
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = module.datasource.alb_log_bucket_id
  policy = data.aws_iam_policy_document.alb_log.json
}
