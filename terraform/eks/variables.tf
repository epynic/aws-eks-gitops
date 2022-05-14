variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_cluster_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs."
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
  type        = string
  default     = "AL2_x86_64"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes. Defaults to 20."
  type        = number
  default     = 10
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.small"]
  description = "Set of instance types associated with the EKS Node Group."
}

variable "pblc_desired_size" {
  description = "Desired number of worker nodes in public subnet"
  default     = 2
  type        = number
}

variable "pblc_max_size" {
  description = "Maximum number of worker nodes in public subnet."
  default     = 3
  type        = number
}

variable "pblc_min_size" {
  description = "Minimum number of worker nodes in public subnet."
  default     = 1
  type        = number
}

variable vpc_id {
  description = "VPC ID from which belogs the subnets"
  type        = string
}