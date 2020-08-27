resource "aws_ecr_repository" "app_api_registry" {
  name = var.app_api_registry_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "api" {
  repository = aws_ecr_repository.app_api_registry.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 10,
        "description": "Keep last 30 untagged images",
        "selection": {
          "tagStatus": "untagged",
          "countType": "imageCountMoreThan",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}
