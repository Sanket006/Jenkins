variable "aws_region" {
  default = "ap-south-1"
}

variable "cluster_name" {
  default = "demo-eks-cluster"
}

variable "node_instance_type" {
  default = "c7i-flex.large"
}

variable "desired_nodes" {
  default = 2
}

# variable "admin_principal_arn" {
#   default = "arn:aws:iam::285513790808:user/sanket"
#   }