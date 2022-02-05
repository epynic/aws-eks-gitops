
# CodeCommit resources
resource "aws_codecommit_repository" "prod_repo" {
  repository_name = var.repo_name
  description     = "${var.repo_name} repository."
  default_branch  = var.repo_default_branch
}

# CodeBuild
resource "aws_codebuild_project" "prod_build" {
  name          = "${var.infra_name}_code_build"
  description   = "The CodeBuild project for ${var.repo_name}"
  build_timeout = var.code_build_timeout

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  cache {
    type     = "S3"
    location = "${var.infra_env}-${var.infra_name}-codebuild-cache/_cache/archives"
  }

  tags = {
    Name        = "${var.infra_name}-backend-codebuild-${var.infra_env}"
    Environment = var.infra_env
  }
}