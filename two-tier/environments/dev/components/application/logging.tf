resource "aws_cloudwatch_log_group" "for_ecs_api" {
  name              = "/ecs/api"
  retention_in_days = var.cloudwatch_log_group_for_ecs_api_retention_in_days
}
