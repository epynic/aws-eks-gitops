# CodeBuild cache 
resource "aws_s3_bucket" "prod_codebuild_bucket" {
  bucket = "${var.infra_env}-${var.infra_name}-codebuild-cache"
  acl    = var.bucket_acl

  tags = {
    Name = "${var.infra_env}-${var.infra_name}-codebuild_cache"
    Env  = var.infra_env
  }
}