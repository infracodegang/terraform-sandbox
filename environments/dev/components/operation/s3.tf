resource "aws_s3_bucket" "operation" {
  bucket        = var.operation_bucket_name
  force_destroy = var.bucket_force_destroy

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "operation" {
  bucket                  = aws_s3_bucket.operation.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}