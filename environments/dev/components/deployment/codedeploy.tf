resource "aws_codedeploy_app" "api" {
  compute_platform = "ECS"
  name             = "codedeploy-api-${var.env}"
}

resource "aws_codedeploy_deployment_group" "api" {
  app_name               = aws_codedeploy_app.api.name
  deployment_config_name = var.api_deployment_config_name
  deployment_group_name  = var.api_deployment_group_name
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
      termination_wait_time_in_minutes = 60
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
          module.application.aws_lb_listener_http.arn
          #module.application.aws_lb_listener_https.arn
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
