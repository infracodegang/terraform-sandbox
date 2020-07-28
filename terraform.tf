terraform {
  backend "remote" {
    organization = "infracodegang"

    workspaces {
      name = "example"
    }
  }
}