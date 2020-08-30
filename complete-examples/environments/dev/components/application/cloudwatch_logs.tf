resource "aws_cloudwatch_log_group" "for_ecs_api" {
  name              = "/ecs/api"
  retention_in_days = 30
}

resource "aws_kinesis_firehose_delivery_stream" "api" {
  name        = "kinesis_firehose_delivery_stream-${var.env}"
  destination = "s3"

  s3_configuration {
    role_arn   = module.kinesis_data_firehose_role.iam_role_arn
    bucket_arn = aws_s3_bucket.cloudwatch_logs.arn
    prefix     = "ecs/api/"
  }
}

resource "aws_cloudwatch_log_subscription_filter" "api" {
  name            = "cloudwatch_log_subscription_filter-${var.env}"
  log_group_name  = aws_cloudwatch_log_group.for_ecs_api.name
  destination_arn = aws_kinesis_firehose_delivery_stream.api.arn
  filter_pattern  = "[]"
  role_arn        = module.cloudwatch_logs_role.iam_role_arn
}
