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

variable "github_token" {
  type        = string
  description = ""
}

variable "app_api_registry_name" {
  type        = string
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

variable "artifact_bucket_name" {
  type        = string
  description = ""
}

variable "bucket_force_destroy" {
  type        = bool
  default     = false
  description = ""
}
