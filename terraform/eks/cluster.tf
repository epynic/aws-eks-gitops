resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = var.eks_cluster_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_cluster_policy
  ]
}