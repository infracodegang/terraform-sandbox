# DB の仮のエンドポイントをあとから以下のコマンドで正式なものに更新
# aws ssm put-parameter --name '/db/endpoint' --value 'XXXXX.XXXXXXXXX.ap-northeast-1.rds.amazonaws.com' --type SecureString --overwrite
resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/db/endpoint"
  value       = "temporalendpoint"
  type        = "SecureString"
  description = "DB endpoint"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  value       = "root"
  type        = "String"
  description = "DB user name"

  lifecycle {
    ignore_changes = [value]
  }
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

# Elasticache の仮のプライマリエンドポイントをあとから以下のコマンドで正式なものに更新
# aws ssm put-parameter --name '/elasticache/primaryendpoint' --value 'XXXXX.XXXXXXXXX.XXXX.cache.amazonaws.com:6379' --type SecureString --overwrite
resource "aws_ssm_parameter" "elasticache_primary_endpoint" {
  name        = "/elasticache/primaryendpoint"
  value       = "temporalprimaryendpoint"
  type        = "SecureString"
  description = "Elasticache primary endpoint"

  lifecycle {
    ignore_changes = [value]
  }
}

# Elasticache の仮のリーダーエンドポイントをあとから以下のコマンドで正式なものに更新
# aws ssm put-parameter --name '/elasticache/readerendpoint' --value 'XXXXX.XXXXXXXXX.XXXX.cache.amazonaws.com:6379' --type SecureString --overwrite
resource "aws_ssm_parameter" "elasticache_reader_endpoint" {
  name        = "/elasticache/readerendpoint"
  value       = "temporalreaderendpoint"
  type        = "SecureString"
  description = "Elasticache reader endpoint"

  lifecycle {
    ignore_changes = [value]
  }
}
