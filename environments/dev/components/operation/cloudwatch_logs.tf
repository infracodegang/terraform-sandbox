resource "aws_cloudwatch_log_group" "operation" {
  name              = "/operation"
  retention_in_days = var.operation_log_retention_in_days
}
