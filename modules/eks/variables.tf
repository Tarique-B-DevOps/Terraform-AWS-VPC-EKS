variable "subnet_ids" {
  description = "Subnets for the EKS cluster"
  type        = list(string)
}

variable "environment" {
  description = "Environment (e.g., staging, production)"
  type        = string
}

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
  description = "The EKS cluster version"
  type        = string
}
