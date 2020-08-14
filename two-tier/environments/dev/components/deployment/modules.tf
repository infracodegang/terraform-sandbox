module "datasource" {
  source = "./datasource"
  env    = var.env
}

module "codepipeline_role" {
  source     = "../../../../modules/iam_role"
  name       = "codepipeline"
  identifier = "codepipeline.amazonaws.com"
  policy     = data.aws_iam_policy_document.codepipeline.json
}

module "codebuild_role" {
  source     = "../../../../modules/iam_role"
  name       = "codebuild"
  identifier = "codebuild.amazonaws.com"
  policy     = data.aws_iam_policy_document.codebuild.json
}

module "codedeploy_role" {
  source     = "../../../../modules/iam_role"
  name       = "codedeploy"
  identifier = "codedeploy.amazonaws.com"
  policy     = data.aws_iam_policy.codedeploy.policy
}
