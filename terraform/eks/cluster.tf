resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = var.eks_cluster_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_cluster_policy
  ]
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.main.identity.0.oidc.0.issuer
}


