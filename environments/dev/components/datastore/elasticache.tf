resource "aws_elasticache_parameter_group" "main" {
  name   = "elasticache-parameter-group"
  family = "redis5.0"

  parameter {
    name  = "cluster-enabled"
    value = "no"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "elasticache-subnet-group"
  subnet_ids = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id          = "replication-group-1"
  replication_group_description = "Cluster Disabled"
  engine                        = "redis"
  engine_version                = var.elasticache_engine_version
  number_cache_clusters         = var.elasticache_number_cache_clusters
  node_type                     = var.elasticache_node_type
  snapshot_window               = "09:10-10:10"                            # UTC
  snapshot_retention_limit      = var.elasticache_snapshot_retention_limit # キャッシュとしての利用であれば長期保存は不要
  maintenance_window            = "mon:10:40-mon:11:40"
  automatic_failover_enabled    = true
  port                          = 6379
  apply_immediately             = false # true は即時, false であればメンテナンスウインドウで設定変更される
  security_group_ids            = [module.redis_sg.security_group_id]
  parameter_group_name          = aws_elasticache_parameter_group.main.name
  subnet_group_name             = aws_elasticache_subnet_group.main.name
}
