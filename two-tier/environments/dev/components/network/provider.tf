provider "aws" {
  profile = var.profile
  region  = var.region
  version = "3.0.0"
}

provider "github" {
  organization = var.github_organization
  version      = "2.9.2"
}
