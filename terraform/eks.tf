
module "eks_cluster_and_worker_nodes" {
  source                 = "./eks"
  eks_cluster_name       = "${var.infra_name}-eks-cluster"
  eks_cluster_subnet_ids = flatten([module.vpc_for_eks.public_subnet_ids, module.vpc_for_eks.private_subnet_ids])
}


# resource "aws_iam_role" "eks_nodes" {
#   name                 = "${var.infra_name}-worker-role"
#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "aws_eks_worker_node_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks_nodes.name
# }

# resource "aws_iam_role_policy_attachment" "aws_eks_cni_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_nodes.name
# }

# resource "aws_iam_role_policy_attachment" "ec2_read_only" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_nodes.name
# }

# resource "aws_eks_cluster" "main" {
#   name     = "${var.infra_name}-eks-cluster"
#   role_arn = aws_iam_role.eks_cluster.arn

#   vpc_config {
#     # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
#     endpoint_private_access = true
#     endpoint_public_access  = true
#     subnet_ids = module.vpc_for_eks.public_subnet_ids
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.aws_eks_cluster_policy
#   ]
# }

# resource "aws_eks_node_group" "main" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "${var.infra_name}-eks-node-group"
#   node_role_arn   = aws_iam_role.eks_nodes.arn
#   subnet_ids      = module.vpc_for_eks.public_subnet_ids

#   ami_type       = "AL2_x86_64"
#   disk_size      = "10"
#   instance_types = ["t3.small"]

#   scaling_config {
#     desired_size = 2
#     max_size     = 4
#     min_size     = 1
#   }

#   tags = {
#     Name = "${var.infra_name}-eks-node-group"
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
#     aws_iam_role_policy_attachment.aws_eks_cni_policy,
#     aws_iam_role_policy_attachment.ec2_read_only,
#   ]
# }