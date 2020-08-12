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
