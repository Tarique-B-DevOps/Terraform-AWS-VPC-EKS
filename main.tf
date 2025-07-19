module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnets        = var.public_subnets
  private_subnets       = var.private_subnets
  provision_nat_gateway = var.provision_nat_gateway
  environment           = var.environment
}

module "eks" {
  source                          = "./modules/eks"
  subnet_ids                      = var.eks_launch_type == "fargate" ? module.vpc.private_subnet_ids : module.vpc.public_subnet_ids
  environment                     = var.environment
  eks_node_instance_type          = var.eks_node_instance_type
  eks_node_arch_type              = var.eks_node_arch_type
  eks_node_group_desired_capacity = var.eks_node_group_desired_capacity
  eks_node_group_min_size         = var.eks_node_group_min_size
  eks_node_group_max_size         = var.eks_node_group_max_size
  eks_version                     = var.eks_version
  eks_launch_type                 = var.eks_launch_type
  fargate_profile_namespaces      = var.fargate_profile_namespaces
}
