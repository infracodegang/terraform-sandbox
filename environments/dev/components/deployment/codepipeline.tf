resource "aws_codepipeline" "api" {
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
      output_artifacts = ["SourceArtifact"]

      configuration = {
        OAuthToken           = var.github_token
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
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.api.id
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      run_order       = 3
      input_artifacts = ["BuildArtifact"]

      configuration = {
        ApplicationName                = "codedeploy-api-${var.env}"
        DeploymentGroupName            = var.api_deployment_group_name
        TaskDefinitionTemplateArtifact = "BuildArtifact"
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact"
        AppSpecTemplatePath            = "appspec.yaml"
        Image1ArtifactName             = "BuildArtifact"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.artifact.id
  }

  depends_on = [aws_codebuild_project.api, aws_codedeploy_app.api]
}

resource "aws_codepipeline_webhook" "api" {
  name            = "aws_codepipeline_webhook-${var.env}"
  target_pipeline = aws_codepipeline.api.name
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

resource "github_repository_webhook" "api" {
  repository = var.repository_name

  configuration {
    url          = aws_codepipeline_webhook.api.url
    secret       = "VfwY7F3nFMdVx9NbuPDS"
    content_type = "json"
    insecure_ssl = false
  }

  events = ["push"]
}
