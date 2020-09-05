## DO NOT write secret information in this file ##

profile = "default"
env = "dev"

# RDS
db_instance_username = "root"
db_instance_class = "db.t3.small"
db_instance_deletion_protection = false
db_instance_skip_final_snapshot = true

# Elasticache
elasticache_engine_version = "5.0.4"
elasticache_number_cache_clusters = 3
elasticache_node_type = "cache.t2.micro"
elasticache_snapshot_retention_limit = 7

# RDS Aurora
aurora_instance_username = "root"
aurora_instance_deletion_protection = false
aurora_instance_skip_final_snapshot = true
aurora_family = "aurora-mysql5.7"
aurora_engine_version = "5.7.mysql_aurora.2.08.2"
# ストレージの 3AZ
aurora_availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
aurora_instance_count = 2
# https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
#aurora_instance_class = "db.m4.2xlarge"
aurora_instance_class = "db.t3.small"
