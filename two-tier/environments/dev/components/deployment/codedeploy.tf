resource "aws_codedeploy_app" "main" {
  compute_platform = "ECS"
  name             = "codedeploy-app-${var.env}"
}

resource "aws_codedeploy_deployment_group" "main" {
  deployment_group_name  = "codedeploy-deployment-group-${var.env}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  app_name               = aws_codedeploy_app.main.name
  service_role_arn       = module.codedeploy_role.iam_role_arn

  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE"
    ]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = "aws-ecs-cluster-${var.env}"
    service_name = "aws-ecs-service-api-${var.env}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          module.datasource.aws_lb_listener_http.arn
          # aws_lb_listener.https.arn
        ]
      }

      target_group {
        name = "target-group-blue"
      }

      target_group {
        name = "target-group-green"
      }
    }
  }
}
