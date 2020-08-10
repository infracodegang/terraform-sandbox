resource "aws_kms_key" "main" {
  description             = "Customer Master Key"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/main_kms_alias"
  target_key_id = aws_kms_key.main.key_id
}
