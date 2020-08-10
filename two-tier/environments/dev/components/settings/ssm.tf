resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  value       = "root"
  type        = "String"
  description = "DB user name"
}

# 仮のパスワードをあとから以下のコマンドで正式なものに更新
# aws ssm put-parameter --name '/db/password' --value 'NewPassword' --type SecureString --overwrite
resource "aws_ssm_parameter" "db_password" {
  name        = "/db/password"
  value       = "temporalpassword"
  type        = "SecureString"
  description = "DB password"

  lifecycle {
    ignore_changes = [value]
  }
}
