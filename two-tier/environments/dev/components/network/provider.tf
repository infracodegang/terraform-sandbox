provider "aws" {
  profile = var.profile
  region  = "ap-northeast-1"
  version = "3.0.0"
}

provider "github" {
  organization = "infracodegang"
  version      = "2.9.2"
}
