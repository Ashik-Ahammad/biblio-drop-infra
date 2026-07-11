# Provision a custom (VPC) for the EKS cluster
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "bibliodrop-vpc"
  cidr = "10.0.0.0/16"

  # Define Availability Zones for high availability in us-west-2
  azs             = ["us-west-2a", "us-west-2b"]
  
  # Private subnets for EKS Worker Nodes (internal traffic only)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  
  # Public subnets for NAT Gateway and Ingress Load Balancers
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # Enable NAT Gateway to allow private subnets to securely access the internet
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Tags required by Kubernetes for external load balancers (Ingress)
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  # Tags required by Kubernetes for internal load balancers
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}