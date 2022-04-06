output "codecommit_repo" {
  value = aws_codecommit_repository.prod_codecommit.clone_url_http
}

output "s3_artifact_bucket" {
  value = aws_s3_bucket.prod_artifact_bucket.bucket
}

output "pipeline_url" {
  value = "https://console.aws.amazon.com/codepipeline/home?region=${var.aws_region}#/view/${aws_codepipeline.pipeline.id}"
}
