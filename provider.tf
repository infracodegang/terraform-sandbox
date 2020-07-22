terraform {
  required_version = "0.12.28"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
  version = "2.69.0"
}

provider "github" {
  organization = "refurbishedcodes"
  version      = "2.9.2"
}
