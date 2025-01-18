output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "eks_cluster_id" {
  description = "The ID of the EKS Cluster"
  value       = module.eks.eks_cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS Cluster"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_node_group_id" {
  description = "The ID of the EKS Node Group"
  value       = module.eks.eks_node_group_id
}
