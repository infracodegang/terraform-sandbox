# output "rds_endpoint" {
#   value       = aws_db_instance.main.endpoint
#   description = ""
# }

output "aurora_endpoint" {
  value       = aws_rds_cluster.main.endpoint
  description = ""
}

output "elasticache_primary_endpoint" {
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
  description = ""
}
