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

variable "alb_log_bucket_name" {
  type        = string
  description = ""
}

variable "artifact_bucket_name" {
  type        = string
  description = ""
}

variable "athena_bucket_name" {
  type        = string
  description = ""
}

variable "cloud_watch_logs_bucket_name" {
  type        = string
  description = ""
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = ""
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = ""
}

variable "bucket_expiration_days" {
  type = map
  default = {
    alb_log          = "180"
    artifact         = "180"
    athena           = "180"
    cloud_watch_logs = "180"
  }
  description = ""
}
