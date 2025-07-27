#eks.tf

# EKS Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # EKS will use the VPC and private subnets from the VPC module
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Enable public access to the Kubernetes API server
  cluster_endpoint_public_access = true

  # Define a managed node group
  eks_managed_node_groups = {
    main = {
      name = "main-node-group"

      # Instance types for worker nodes
      instance_types = var.node_group_instance_types
      # ami_type       = "AL2023_ARM_64_STANDARD" # Use this case in case you use the ARM machine.

      # Autoscaling configuration
      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      # Bootstrap script to initialize the worker nodes
      pre_bootstrap_user_data = <<-EOT
      #!/bin/bash
      set -ex
      /etc/eks/bootstrap.sh ${var.cluster_name}
      EOT

      # Additional security group for the nodes
      vpc_security_group_ids = [aws_security_group.additional.id]

      # Tags for node group resources
      tags = var.tags
    }
  }

  # Automatically manage the aws-auth ConfigMap to allow role access to the cluster
  manage_aws_auth_configmap = true

  # IAM role with cluster admin access
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.demo_role.arn
      username = "demo-role"
      groups   = ["system:masters"]
    },
  ]

  # Tags for EKS resources
  tags = var.tags
}
