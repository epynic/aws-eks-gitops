
resource "aws_eks_node_group" "public_node_group" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.eks_cluster_name}-public-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.public_subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.pblc_desired_size
    max_size     = var.pblc_max_size
    min_size     = var.pblc_min_size
  }

  tags = {
    Name = "${var.eks_cluster_name}-public-node-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
  ]
}