
resource "aws_ecr_repository" "prod_ecr" {
  name                 = var.image_repo_name
  image_tag_mutability = "MUTABLE"

  #  image_scanning_configuration {
  #    scan_on_push = true
  #  }
}

output "image_repo_url" {
  value = aws_ecr_repository.prod_ecr.repository_url
}

output "image_repo_arn" {
  value = aws_ecr_repository.prod_ecr.arn
}