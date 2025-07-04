module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  availability_zones    = var.availability_zones
  environment           = var.environment
}

module "eks" {
  source                          = "./modules/eks"
  subnet_ids                      = module.vpc.public_subnet_ids
  environment                     = var.environment
  eks_node_instance_type          = var.eks_node_instance_type
  eks_node_arch_type              = var.eks_node_arch_type
  eks_node_group_desired_capacity = var.eks_node_group_desired_capacity
  eks_node_group_min_size         = var.eks_node_group_min_size
  eks_node_group_max_size         = var.eks_node_group_max_size
  eks_version                     = var.eks_version
}
