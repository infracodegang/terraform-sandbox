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

variable "vpc_cidr_block" {
  type        = string
  description = ""
}

variable "public_subnet_1_cidr_block" {
  type        = string
  description = ""
}

variable "public_subnet_2_cidr_block" {
  type        = string
  description = ""
}

variable "private_subnet_1_cidr_block" {
  type        = string
  description = ""
}

variable "private_subnet_2_cidr_block" {
  type        = string
  description = ""
}

variable "public_subnet_1_az" {
  type        = string
  description = ""
}

variable "public_subnet_2_az" {
  type        = string
  description = ""
}

variable "private_subnet_1_az" {
  type        = string
  description = ""
}

variable "private_subnet_2_az" {
  type        = string
  description = ""
}
