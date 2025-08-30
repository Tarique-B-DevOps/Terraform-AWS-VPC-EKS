variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "tags" {
  description = "default tags"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Map of public subnet names to their CIDR blocks and availability zones"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnet names to their CIDR blocks and availability zones"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "provision_nat_gateway" {
  description = "Specify whether to provision and configure the NAT gateway for private subnets"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment (e.g., staging, production)"
  type        = string
}

# EKS related variables
variable "eks_auth_mode" {
  description = "EKS authentication mode. NOTE: CONFIG_MAP is deprecated and will be removed in future versions."
  type        = string

}

variable "eks_node_instance_type" {
  description = "The EC2 instance type for the EKS worker nodes"
  type        = string
  default     = ""
}

variable "eks_node_arch_type" {
  description = "Architecture type: 'arm' for ARM64, 'amd' for x86_64"
  type        = string
  default     = ""

}

variable "eks_node_group_desired_capacity" {
  description = "The desired number of worker nodes in the EKS cluster"
  type        = number
  default     = 0
}

variable "eks_node_group_min_size" {
  description = "The minimum number of worker nodes in the EKS cluster"
  type        = number
  default     = 0
}

variable "eks_node_group_max_size" {
  description = "The maximum number of worker nodes in the EKS cluster"
  type        = number
  default     = 0
}

variable "eks_version" {
  description = "The EKS cluster's kubernetes version"
  type        = string
}

variable "eks_launch_type" {
  description = "Launch type for worker nodes: 'ec2' for EC2 Node Group, 'fargate' for EKS Fargate"
  type        = string
}

variable "fargate_profile_namespaces" {
  description = "List of Kubernetes namespaces to use for Fargate profile"
  type        = list(string)
  default     = []
}
