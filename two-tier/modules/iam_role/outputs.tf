output "iam_role_arn" {
  value       = aws_iam_role.default.arn
  description = ""
}

output "iam_role_name" {
  value       = aws_iam_role.default.name
  description = ""
}

output "describe_regions_json" {
  value       = data.aws_iam_policy_document.allow_describe_regions.json
  description = ""
}
