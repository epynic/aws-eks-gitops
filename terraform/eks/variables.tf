variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_cluster_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}
