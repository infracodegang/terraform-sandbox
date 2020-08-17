resource "aws_s3_bucket" "alb_log" {
  bucket        = var.alb_log_bucket_name
  force_destroy = var.bucket_force_destroy

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }

  tags = {
    Name        = "aws_s3_bucket_alb_log"
    Environment = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "alb_log" {
  bucket                  = aws_s3_bucket.alb_log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudWatch Logs
resource "aws_s3_bucket" "cloudwatch_logs" {
  bucket        = var.cloud_watch_logs_bucket_name
  force_destroy = var.bucket_force_destroy

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }

  tags = {
    Name        = "aws_s3_bucket_cloudwatch_logs"
    Environment = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "cloudwatch_logs" {
  bucket                  = aws_s3_bucket.cloudwatch_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
