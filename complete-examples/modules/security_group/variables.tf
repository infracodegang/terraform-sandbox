variable "name" {
  description = ""
}

variable "vpc_id" {
  description = ""
}

variable "from_port" {
  description = ""
}

variable "to_port" {
  description = ""
}

variable "cidr_blocks" {
  type        = list(string)
  description = ""
}
