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
      input_artifacts  = ["Source"]
      output_artifacts = ["Build"]

      configuration = {
        ProjectName = aws_codebuild_project.main.id
      }
    }
  }

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.artifact.id
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
