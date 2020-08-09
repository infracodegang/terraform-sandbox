output "vpc_id" {
  value       = data.aws_vpc.main.id
  description = ""
}

output "vpc_cidr_block" {
  value       = data.aws_vpc.main.cidr_block
  description = ""
}

output "public_subnet_1_id" {
  value       = data.aws_subnet.public_1.id
  description = ""
}

output "public_subnet_2_id" {
  value       = data.aws_subnet.public_2.id
  description = ""
}

output "private_subnet_1_id" {
  value       = data.aws_subnet.private_1.id
  description = ""
}

output "private_subnet_2_id" {
  value       = data.aws_subnet.private_2.id
  description = ""
}

output "alb_log_bucket_id" {
  value       = data.aws_s3_bucket.alb_log.id
  description = ""
}
