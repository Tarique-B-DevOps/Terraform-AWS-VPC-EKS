# Common Vars Values
region      = "ap-south-2"
environment = "dev"
tags = {
  "Environment" = "dev"
  "App"         = "core"
}

# VPC Vars Values
vpc_cidr = "10.0.0.0/16"

public_subnets = {
  "sub1" = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-south-2a"

  },
  "sub2" = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-south-2b"

  }
}

private_subnets = {
  "sub1" = {
    cidr_block        = "10.0.3.0/24"
    availability_zone = "ap-south-2a"
  },
  "sub2" = {
    cidr_block        = "10.0.4.0/24"
    availability_zone = "ap-south-2b"

  }
}

provision_nat_gateway = false

# EKS Vars Values
eks_auth_mode                   = "API_AND_CONFIG_MAP"
eks_launch_type                 = "ec2"
eks_node_instance_type          = "t4g.medium"
eks_node_arch_type              = "arm"
eks_node_group_desired_capacity = 1
eks_node_group_min_size         = 1
eks_node_group_max_size         = 2
eks_version                     = "1.33"
