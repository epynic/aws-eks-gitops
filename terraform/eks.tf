
module "eks_cluster_and_worker_nodes" {
  source                 = "./eks"
  eks_cluster_name       = "${var.infra_name}-eks-cluster"

  eks_cluster_subnet_ids = flatten([module.vpc_for_eks.public_subnet_ids, module.vpc_for_eks.private_subnet_ids])
  public_subnet_ids = module.vpc_for_eks.public_subnet_ids

  disk_size         = "10"
  instance_types    = ["t3.small"]
  pblc_desired_size = 2
  pblc_max_size     = 3
  pblc_min_size     = 1

  vpc_id = module.vpc_for_eks.vpc_id
}

output "eks_cluster_and_worker_nodes-cluster_name" {
  value = module.eks_cluster_and_worker_nodes.cluster_name
}


# module "eks_cluster_argocd" {
#   source           = "./eks"
#   eks_cluster_name = "argocd-${var.infra_name}-eks-cluster"
  
#   eks_cluster_subnet_ids = flatten([module.vpc_for_eks.public_subnet_ids, module.vpc_for_eks.private_subnet_ids])
#   #workers - only on public subnets - add aws_eks_node_group for private subnets
#   public_subnet_ids = module.vpc_for_eks.public_subnet_ids

#   disk_size         = "10"
#   instance_types    = ["t3.small"]
#   pblc_desired_size = 1
#   pblc_max_size     = 1
#   pblc_min_size     = 1

#    vpc_id = module.vpc_for_eks.vpc_id
# }

# output "eks_cluster_argocd-cluster_name" {
#   value = module.eks_cluster_argocd.cluster_name
# }

