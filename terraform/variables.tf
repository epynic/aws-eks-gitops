variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "infra_name" {}
variable "infra_env" {}
variable "bucket_acl" {
  type        = string
  default     = "private"
  description = "Bucket ACL (Access Control Listing)"
}

variable "repo_name" {}
variable "repo_default_branch" {}

variable "code_build_timeout" {}