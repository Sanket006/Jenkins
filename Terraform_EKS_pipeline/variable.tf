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

