module "vpc_for_eks" {
  source = "./vpc"

  # eks_cluster_name = "${var.infra_name}-eks-cluster"
  # Include all the cluster names to help provision alb
  vpc_tags = {
    "kubernetes.io/cluster/${var.infra_name}-eks-cluster"        = "shared"
    "kubernetes.io/cluster/argocd-${var.infra_name}-eks-cluster" = "shared"
  }

  vpc_name                   = "${var.infra_name}-vpc"
  vpc_cidr_block             = "10.0.0.0/16"
  availability_zones         = ["ap-south-1a", "ap-south-1b"]
  private_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnet_cidr_blocks  = ["10.0.2.0/24", "10.0.3.0/24"]
}