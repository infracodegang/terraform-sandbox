resource "aws_db_parameter_group" "main" {
  name   = "db-parameter-group-main-${var.env}"
  family = "mysql5.7"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

resource "aws_db_option_group" "main" {
  name                 = "db-option-group-main-${var.env}"
  engine_name          = "mysql"
  major_engine_version = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

resource "aws_db_subnet_group" "main" {
  name = "db-subnet-group-main-${var.env}"
  subnet_ids = [
    module.datasource.private_subnet_1_id,
    module.datasource.private_subnet_2_id
  ]
}

# あとから以下のコマンドでパスワードを更新
# aws rds modify-db-instance --db-instance-identifier 'main' --master-user-password 'NewPassword'
resource "aws_db_instance" "main" {
  identifier                 = "main-${var.env}"
  engine                     = "mysql"
  engine_version             = var.db_instance_engine_version
  instance_class             = var.db_instance_instance_class
  allocated_storage          = 20
  max_allocated_storage      = 100
  storage_type               = var.db_instance_storage_type
  storage_encrypted          = true
  kms_key_id                 = aws_kms_key.main.arn
  username                   = var.db_instance_username
  password                   = "temporalpassword"
  multi_az                   = true
  publicly_accessible        = false
  backup_window              = "09:10-09:40"
  backup_retention_period    = 30
  maintenance_window         = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection        = var.db_instance_deletion_protection # production では true
  skip_final_snapshot        = var.db_instance_skip_final_snapshot # インスタンス削除時にスナップショットを作成するか. production では false
  port                       = 3306
  apply_immediately          = false
  vpc_security_group_ids     = [module.mysql_sg.security_group_id]
  parameter_group_name       = aws_db_parameter_group.main.name
  option_group_name          = aws_db_option_group.main.name
  db_subnet_group_name       = aws_db_subnet_group.main.name

  lifecycle {
    ignore_changes = [password]
  }
}
