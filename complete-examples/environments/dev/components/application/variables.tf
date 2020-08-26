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

variable "cloud_watch_logs_bucket_name" {
  type        = string
  description = ""
}

variable "bucket_force_destroy" {
  type        = bool
  default     = false
  description = ""
}

# https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
variable "alb_logger" {
  type = map
  default = {
    ap-northeast-1 = "582318560864"
    ap-northeast-3 = "383597477331"
  }
  description = ""
}

# variable "domain_name" {
#   type        = string
#   description = ""
# }

variable "enable_deletion_protection" {
  type        = bool
  description = ""
}

variable "public_alb_access_logs_enabled" {
  type        = bool
  default     = true
  description = ""
}

variable "load_balancer_container_name" {
  type        = string
  description = ""
}

variable "load_balancer_container_port" {
  type        = number
  description = ""
}

variable "health_check_path" {
  type        = string
  description = ""
}

variable "desired_count" {
  type        = number
  description = ""
}
