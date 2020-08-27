resource "aws_ecs_cluster" "main" {
  name = "aws-ecs-cluster-${var.env}"

  tags = {
    Environment = var.env
  }
}

# ここでの定義は初回のみ適用され, 以降はアプリケーションのデプロイサイクルでタスク定義を更新するものとする.
resource "aws_ecs_task_definition" "api_task_def" {
  family                   = "restapi"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./default_taskdef.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

# https://qiita.com/narisada014/items/fdc18a7e0dedcc511279
resource "aws_ecs_service" "ecs_service_api" {
  name                              = "aws-ecs-service-api-${var.env}"
  cluster                           = aws_ecs_cluster.main.arn
  task_definition                   = aws_ecs_task_definition.api_task_def.arn
  desired_count                     = var.desired_count # 維持するタスク数. 各プライベートサブネットにタスクを按分.
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 180 # ヘルスチェック開始までの猶予期間
  enable_ecs_managed_tags           = true

  network_configuration {
    assign_public_ip = false

    security_groups = [
      module.ecs_sg.security_group_id,
      #      module.alb_health_check_sg.security_group_id,
    ]

    subnets = [
      module.network.private_subnet_1_id,
      module.network.private_subnet_2_id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    # LB からの転送先となるコンテナ名とポート
    container_name = var.load_balancer_container_name
    container_port = var.load_balancer_container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    # Fargate の場合デプロイのたびにタスク定義が更新されるため plan 時に差分が出てしまう.
    # そのため, Terraform ではリソースの初回作成時を除きタスク定義の変更を無視する.
    # つまりタスク定義の更新は, Terraform のライフサイクルではなく, アプリケーションデプロイのライフサイクルとする.
    ignore_changes = [
      task_definition,
      desired_count,
      load_balancer,
    ]
  }

  depends_on = [
    aws_lb_target_group.blue,
    aws_lb_target_group.green,
  ]

  tags = {
    Environment = var.env
  }
}
