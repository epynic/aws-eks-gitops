
# CodePipeline artifact_bucket
resource "aws_s3_bucket" "prod_artifact_bucket" {
  bucket = "${var.infra_name}-artifact"
  acl    = var.bucket_acl

  tags = {
    Name = "${var.infra_name}-artifact"
    Env  = var.infra_env
  }
}