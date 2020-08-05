terraform {
  required_version = ">= 0.12.28"

  required_providers {
    aws    = ">= 2.69.0"
    github = ">= 2.9.2"
  }

  backend "remote" {
    organization = "infracodegang"

    workspaces {
      name = "example"
    }
  }
}
