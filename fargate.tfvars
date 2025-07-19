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
  "nat-gw-pub1" = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-south-2a"

  }
}

private_subnets = {
  "priv1" = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-south-2a"
  },
  "priv2" = {
    cidr_block        = "10.0.3.0/24"
    availability_zone = "ap-south-2b"

  }
}

provision_nat_gateway = true

# EKS Vars Values
eks_launch_type            = "fargate"
fargate_profile_namespaces = ["default", "kube-system"]
eks_version                = "1.32"
