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

variable "db_instance_engine_version" {
  type        = string
  default     = "5.7.25"
  description = ""
}

variable "db_instance_instance_class" {
  type        = string
  description = ""
}

variable "db_instance_storage_type" {
  type        = string
  default     = "gp2"
  description = ""
}

variable "db_instance_username" {
  type        = string
  description = ""
}

variable "db_instance_deletion_protection" {
  type        = bool
  description = ""
}

variable "db_instance_skip_final_snapshot" {
  type        = bool
  description = ""
}

variable "elasticache_engine_version" {
  type        = string
  description = ""
}

variable "elasticache_number_cache_clusters" {
  type        = number
  description = ""
}

variable "elasticache_node_type" {
  type        = string
  description = ""
}

variable "elasticache_snapshot_retention_limit" {
  type        = number
  description = ""
}
