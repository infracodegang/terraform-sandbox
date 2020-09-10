terraform {
  required_version = "0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.3.0"
    }

    github = {
      source  = "hashicorp/github"
      version = "3.0.0"
    }
  }

  backend "s3" {
    bucket = "infracodegang-remote-state-dev"
    key    = "dev/deployment/terraform.state"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
  version = "3.3.0"
}

provider "github" {
  organization = var.repository_owner
  version      = "3.0.0"
}
