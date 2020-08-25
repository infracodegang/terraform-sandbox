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

module "kinesis_data_firehose_role" {
  source     = "../../../../modules/iam_role"
  name       = "kinesis-data-firehose"
  identifier = "firehose.amazonaws.com"
  policy     = data.aws_iam_policy_document.kinesis_data_firehose.json
}

module "cloudwatch_logs_role" {
  source     = "../../../../modules/iam_role"
  name       = "cloudwatch-logs"
  identifier = "logs.${var.region}.amazonaws.com"
  policy     = data.aws_iam_policy_document.cloudwatch_logs.json
}
