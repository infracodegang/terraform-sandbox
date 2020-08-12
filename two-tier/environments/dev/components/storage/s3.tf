# Athena bucket
resource "aws_s3_bucket" "athena" {
  bucket        = var.athena_bucket_name
  force_destroy = var.force_destroy

  lifecycle_rule {
    enabled = true

    expiration {
      days = var.bucket_expiration_days.athena
    }
  }

  tags = {
    Name        = "aws_s3_bucket_athena"
    Environment = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "athena" {
  bucket                  = aws_s3_bucket.athena.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudWatch Logs
resource "aws_s3_bucket" "cloud_watch_logs" {
  bucket        = var.cloud_watch_logs_bucket_name
  force_destroy = var.force_destroy

  lifecycle_rule {
    enabled = true

    expiration {
      days = var.bucket_expiration_days.cloud_watch_logs
    }
  }

  tags = {
    Name        = "aws_s3_bucket_cloud_watch_logs"
    Environment = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "cloud_watch_logs" {
  bucket                  = aws_s3_bucket.cloud_watch_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
