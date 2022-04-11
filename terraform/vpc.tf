resource "random_string" "suffix" {
  length  = 8
  special = false
}

data "aws_availability_zones" "available" {}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name            = "${var.infra_name}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.infra_name}-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.infra_name}-public-subnet" = "shared"
    "kubernetes.io/role/elb"                                = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.infra_name}-private-subnet" = "shared"
    "kubernetes.io/role/internal-elb"                        = "1"
  }
}