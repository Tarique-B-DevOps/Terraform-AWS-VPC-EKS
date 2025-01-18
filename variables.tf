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

variable "public_subnet_a_cidr" {
  description = "CIDR block for Public Subnet A"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for Public Subnet B"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for Private Subnet A"
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for Private Subnet B"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "environment" {
  description = "Environment (e.g., staging, production)"
  type        = string
}

# EKS related variables
variable "eks_node_instance_type" {
  description = "The EC2 instance type for the EKS worker nodes"
  type        = string
}

variable "eks_node_group_desired_capacity" {
  description = "The desired number of worker nodes in the EKS cluster"
  type        = number
}

variable "eks_node_group_min_size" {
  description = "The minimum number of worker nodes in the EKS cluster"
  type        = number
}

variable "eks_node_group_max_size" {
  description = "The maximum number of worker nodes in the EKS cluster"
  type        = number
}

variable "eks_version" {
  description = "The EKS cluster's kubernetes version"
  type        = string
}
