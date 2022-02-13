output "codecommit_repo" {
  value = aws_codecommit_repository.prod_codecommit.clone_url_http
}