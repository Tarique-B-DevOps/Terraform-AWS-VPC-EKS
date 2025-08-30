# Common Vars Values
region      = "ap-south-2"
environment = "staging"
tags = {
  "Environment" = "Staging"
  "App"         = "NoteIT"
}

# VPC Vars Values
vpc_cidr              = "10.0.0.0/16"
public_subnet_a_cidr  = "10.0.1.0/24"
public_subnet_b_cidr  = "10.0.2.0/24"
private_subnet_a_cidr = "10.0.3.0/24"
private_subnet_b_cidr = "10.0.4.0/24"
availability_zones    = ["ap-south-2a", "ap-south-2b"]

# EKS Vars Values
eks_auth_mode                   = "API_AND_CONFIG_MAP"
eks_node_instance_type          = "t3.medium"
eks_node_group_desired_capacity = 1
eks_node_group_min_size         = 1
eks_node_group_max_size         = 3
eks_version                     = "1.33"