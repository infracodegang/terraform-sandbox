resource "aws_codebuild_project" "main" {
  name         = "codebuild-${var.env}"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type            = "LINUX_CONTAINER"
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    privileged_mode = true
  }

  lifecycle {
    ignore_changes = [environment]
  }
}

resource "aws_codepipeline" "main" {
  name     = "codepipeline-${var.env}"
  role_arn = module.codepipeline_role.iam_role_arn

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = 1
      output_artifacts = ["Source"]

      configuration = {
        Owner                = var.repository_owner
        Repo                 = var.repository_name
        Branch               = var.target_branch
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["Source"]
      output_artifacts = ["Build"]

      configuration = {
        ProjectName = aws_codebuild_project.main.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["Build"]

      configuration = {
        ClusterName = aws_ecs_cluster.example.name
        ServiceName = aws_ecs_service.example.name
        FileName    = "imagedefinitions.json"
      }
    }
  }

  artifact_store {
    location = module.datasource.artifact_bucket_id
    type     = "S3"
  }
}

resource "aws_codepipeline_webhook" "main" {
  name            = "example"
  target_pipeline = aws_codepipeline.main.name
  target_action   = "Source"
  authentication  = "GITHUB_HMAC"

  authentication_configuration {
    secret_token = "VfwY7F3nFMdVx9NbuPDS"
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

resource "github_repository_webhook" "main" {
  repository = var.repository_name

  configuration {
    url          = aws_codepipeline_webhook.main.url
    secret       = "VfwY7F3nFMdVx9NbuPDS"
    content_type = "json"
    insecure_ssl = false
  }

  events = ["push"]
}
