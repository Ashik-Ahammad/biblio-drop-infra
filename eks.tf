# Provision Elastic Kubernetes Service (EKS) Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "bibliodrop-cluster"
  cluster_version = "1.30"

  # Network configuration mapping to the custom VPC
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Enable public access to the cluster endpoint for kubectl operations
  cluster_endpoint_public_access = true

  # Grant Admin permissions to the IAM User creating the cluster (Fixes credential issue)
  enable_cluster_creator_admin_permissions = true

  # Configure AWS EKS Managed Node Groups
  eks_managed_node_groups = {
    main_node_group = {
      min_size     = 1
      max_size     = 2
      desired_size = 2

      # Define the EC2 instance type for the worker nodes
      instance_types = ["t3.medium"]

      # Define EBS volume size per node (in GiB)
      disk_size = 20
    }
  }
}
