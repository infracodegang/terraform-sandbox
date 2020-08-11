variable "profile" {
  type        = string
  description = ""
}

variable "env" {
  type        = string
  description = ""
}

variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = ""
}

variable "organization_name" {
  type        = string
  description = ""
}

variable "repository_owner" {
  type        = string
  description = ""
}

variable "repository_name" {
  type        = string
  description = ""
}

variable "target_branch" {
  type        = string
  description = ""
}

variable "artifact_bucket" {
  type        = string
  description = ""
}
