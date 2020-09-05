resource "aws_db_parameter_group" "main" {
  name   = "db-pg-${var.env}"
  family = var.aurora_family
}

resource "aws_rds_cluster_parameter_group" "main" {
  name   = "rds-cluster-pg-${var.env}"
  family = var.aurora_family

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = "UTC"
    apply_method = "immediate"
  }

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "skip_name_resolve"
    value        = "1"
    apply_method = "immediate"
  }
}

resource "aws_db_subnet_group" "main" {
  name = "db-subnet-group-main-${var.env}"
  subnet_ids = [
    module.network.private_subnet_1_id,
    module.network.private_subnet_2_id
  ]
}

# あとから以下のコマンドでパスワードを更新
# aws rds modify-db-instance --db-instance-identifier 'main' --master-user-password 'NewPassword'
resource "aws_rds_cluster" "main" {
  cluster_identifier              = "aurora-cluster-${var.env}"
  engine                          = "aurora-mysql"
  engine_version                  = var.aurora_engine_version
  availability_zones              = var.aurora_availability_zones
  master_username                 = var.aurora_instance_username
  master_password                 = "temporalpassword"
  backup_retention_period         = 5
  preferred_backup_window         = "19:30-20:00"
  preferred_maintenance_window    = "mon:20:15-mon:20:45"
  port                            = 3306
  apply_immediately               = false
  vpc_security_group_ids          = [module.mysql_sg.security_group_id]
  db_subnet_group_name            = aws_db_subnet_group.main.name
  storage_encrypted               = true
  kms_key_id                      = aws_kms_key.main.arn
  deletion_protection             = var.aurora_instance_deletion_protection # production では true
  skip_final_snapshot             = var.aurora_instance_skip_final_snapshot # インスタンス削除時にスナップショットを作成するか. production では false
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]

  lifecycle {
    ignore_changes = [master_password]
  }
}

resource "aws_rds_cluster_instance" "main" {
  # Multi AZ にする場合は, プライマリインスタンス(Writer)とレプリカ(Reader)で最低 2 を設定する
  count = var.aurora_instance_count

  identifier              = "aurora-instance-${var.env}-${count.index + 1}"
  cluster_identifier      = aws_rds_cluster.main.id
  engine                  = "aurora-mysql"
  engine_version          = var.aurora_engine_version
  instance_class          = var.aurora_instance_class
  db_subnet_group_name    = aws_db_subnet_group.main.name
  db_parameter_group_name = aws_db_parameter_group.main.name
  monitoring_role_arn     = module.rds_monitoring_role.iam_role_arn
  monitoring_interval     = 60
  publicly_accessible     = false
}
