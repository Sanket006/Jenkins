# terraform {
#   required_version = ">= 1.3.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = "~> 2.25"
#     }
#   }
# }

############################
# AWS Provider
############################

provider "aws" {
  region = var.aws_region
}

############################
# Default VPC + Subnets
############################

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

############################
# EKS Cluster IAM Role
############################

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

############################
# EKS Cluster
############################

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

############################
# Node Group IAM Role
############################

resource "aws_iam_role" "node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

############################
# EKS Node Group
############################

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "demo-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnets.default.ids
  instance_types  = [var.node_instance_type]

  scaling_config {
    desired_size = var.desired_nodes
    min_size     = 1
    max_size     = 3
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_policy
  ]
}

# ############################
# # EKS Auth Data Sources
# ############################

# data "aws_eks_cluster" "eks_auth" {
#   name = aws_eks_cluster.eks.name
# }

# data "aws_eks_cluster_auth" "eks_auth" {
#   name = aws_eks_cluster.eks.name
# }

# ############################
# # Kubernetes Provider
# ############################

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks_auth.endpoint
#   cluster_ca_certificate = base64decode(
#     data.aws_eks_cluster.eks_auth.certificate_authority[0].data
#   )
#   token = data.aws_eks_cluster_auth.eks_auth.token
# }

# ############################
# # Grant Admin Access (IAM Role/User)
# ############################

# resource "aws_eks_access_entry" "admin" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = var.admin_principal_arn
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "admin_policy" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = aws_eks_access_entry.admin.principal_arn
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

#   access_scope {
#     type = "cluster"
#   }
# }

# ############################
# # Grant Node Group Access (CRITICAL)
# ############################

# resource "aws_eks_access_entry" "nodes" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = aws_iam_role.node_role.arn
#   type          = "EC2_LINUX"
# }

