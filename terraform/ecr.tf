//db
//redis
//result
//vote
//worker

resource "aws_ecr_repository" "image_db" {
  name                 = "${var.image_repo_name}-db"
  image_tag_mutability = "MUTABLE"
  #  image_scanning_configuration {
  #    scan_on_push = true
  #  }
}

resource "aws_ecr_repository" "image_redis" {
  name                 = "${var.image_repo_name}-redis"
  image_tag_mutability = "MUTABLE"
  #  image_scanning_configuration {
  #    scan_on_push = true
  #  }
}

resource "aws_ecr_repository" "image_result" {
  name                 = "${var.image_repo_name}-result"
  image_tag_mutability = "MUTABLE"
  #  image_scanning_configuration {
  #    scan_on_push = true
  #  }
}

resource "aws_ecr_repository" "image_vote" {
  name                 = "${var.image_repo_name}-vote"
  image_tag_mutability = "MUTABLE"
  #  image_scanning_configuration {
  #    scan_on_push = true
  #  }
}

resource "aws_ecr_repository" "image_worker" {
  name                 = "${var.image_repo_name}-worker"
  image_tag_mutability = "MUTABLE"
  #  image_scanning_configuration {
  #    scan_on_push = true
  #  }
}

# output "image_repo_url" {
#   value = aws_ecr_repository.prod_ecr.repository_url
# }

# output "image_repo_arn" {
#   value = aws_ecr_repository.prod_ecr.arn
# }