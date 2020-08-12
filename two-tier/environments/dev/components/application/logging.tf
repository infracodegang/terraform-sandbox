resource "aws_cloudwatch_log_group" "for_ecs_api" {
  name              = "/ecs/api"
  retention_in_days = 30
}
