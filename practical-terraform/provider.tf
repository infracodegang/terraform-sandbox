provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
  version = "2.69.0"
}

provider "github" {
  organization = "infracodegang"
  version      = "2.9.2"
}