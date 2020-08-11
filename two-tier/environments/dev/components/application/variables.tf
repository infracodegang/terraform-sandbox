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

variable "alb_log_bucket" {
  type        = string
  description = ""
}

# https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
variable "alb_logger" {
  type    = map
  default = {
    ap-northeast-1 = "582318560864"
    ap-northeast-3 = "383597477331"
  }
  description = ""
}

variable "domain_name" {
  type        = string
  description = ""
}

variable "enable_deletion_protection" {
  type        = bool
  description = ""
}

variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
  description = ""
}

variable "public_alb_idle_timeout" {
  type        = number
  default     = 60
  description = ""
}

variable "public_alb_access_logs_enabled" {
  type        = bool
  default     = true
  description = ""
}

variable "ecs_service_platform_version" {
  type        = string
  default     = "1.4.0"
  description = ""
}

variable "ecs_service_api_desired_count" {
  type        = number
  default     = 2
  description = ""
}

variable "ecs_service_api_health_check_grace_period_seconds" {
  type        = number
  default     = 60
  description = ""
}

variable "api_load_balancer_container_name" {
  type        = string
  default     = "api_gateway_container"
  description = ""
}

variable "api_load_balancer_container_port" {
  type        = number
  default     = 80
  description = ""
}

variable "cloudwatch_log_group_for_ecs_api_retention_in_days" {
  type        = number
  default     = 30
  description = ""
}
