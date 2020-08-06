# ALB log bucket
resource "aws_s3_bucket" "alb_log" {
  bucket        = var.alb_log_bucket_name
  force_destroy = var.force_destroy

  lifecycle_rule {
    enabled = true

    expiration {
      days = var.bucket_expiration_days.alb_log
    }
  }
}

resource "aws_s3_bucket_public_access_block" "alb_log" {
  bucket                  = aws_s3_bucket.alb_log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# artifact bucket
resource "aws_s3_bucket" "artifact" {
  bucket        = var.artifact_bucket_name
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = var.bucket_expiration_days.artifact
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifact" {
  bucket                  = aws_s3_bucket.artifact.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

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
}

resource "aws_s3_bucket_public_access_block" "cloud_watch_logs" {
  bucket                  = aws_s3_bucket.cloud_watch_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
