terraform {
  required_version = "0.12.29"

  required_providers {
    aws    = "3.0.0"
  }

  backend "s3" {
    bucket = "infracodegang-remote-state-dev"
    key    = "dev/application/terraform.state"
    region = "ap-northeast-1"
  }
}
