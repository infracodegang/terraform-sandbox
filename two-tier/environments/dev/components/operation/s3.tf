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
