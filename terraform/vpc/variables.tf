
variable "eks_cluster_name" {
  default     = "eks-cluster"
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_name" {
  type        = string
  default     = "vpc"
  description = "Name of the VPC"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
  description = "List of availability zones for the selected region"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
  description = "CIDR block range for the private subnet"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
  description = "CIDR block range for the public subnet"
}
