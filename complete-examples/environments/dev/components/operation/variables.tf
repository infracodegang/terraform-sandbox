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

variable "instance_type" {
  type        = string
  description = ""
}

variable "operation_bucket_name" {
  type        = string
  description = ""
}

variable "bucket_force_destroy" {
  type        = bool
  default     = false
  description = ""
}
