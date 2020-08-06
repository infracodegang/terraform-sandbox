variable "profile" {
  type        = string
  description = ""
}

variable "env" {
  type        = string
  description = ""
}

variable "github_organization" {
  type        = string
  description = ""
}

variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = ""
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = ""
}

variable "public_subnet_1_cidr_block" {
  type        = string
  default     = "10.0.1.0/24"
  description = ""
}

variable "public_subnet_2_cidr_block" {
  type        = string
  default     = "10.0.2.0/24"
  description = ""
}

variable "private_subnet_1_cidr_block" {
  type        = string
  default     = "10.0.65.0/24"
  description = ""
}

variable "private_subnet_2_cidr_block" {
  type        = string
  default     = "10.0.66.0/24"
  description = ""
}

variable "public_subnet_1_az" {
  type        = string
  default     = "ap-northeast-1a"
  description = ""
}

variable "public_subnet_2_az" {
  type        = string
  default     = "ap-northeast-1c"
  description = ""
}

variable "private_subnet_1_az" {
  type        = string
  default     = "ap-northeast-1a"
  description = ""
}

variable "private_subnet_2_az" {
  type        = string
  default     = "ap-northeast-1c"
  description = ""
}
