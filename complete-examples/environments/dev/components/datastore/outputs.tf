output "rds_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = ""
}

output "elasticache_primary_endpoint" {
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
  description = ""
}
