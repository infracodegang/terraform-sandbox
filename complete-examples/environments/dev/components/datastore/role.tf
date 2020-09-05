module "rds_monitoring_role" {
  source     = "../../../../modules/iam_role"
  name       = "rds-monitoring"
  identifier = "monitoring.rds.amazonaws.com"
  policy     = data.aws_iam_policy.rds_monitoring.policy
}
