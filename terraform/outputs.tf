output "codecommit_repo" {
  value = aws_codecommit_repository.prod_repo.repository_name
}