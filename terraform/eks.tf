
module "eks_cluster_and_worker_nodes" {
  source                 = "./eks"
  eks_cluster_name       = "${var.infra_name}-eks-cluster"
  eks_cluster_subnet_ids = flatten([module.vpc_for_eks.public_subnet_ids, module.vpc_for_eks.private_subnet_ids])

  public_subnet_ids = module.vpc_for_eks.public_subnet_ids
}
