locals {
  has_public_subnets  = length(var.public_subnets) > 0
  has_private_subnets = length(var.private_subnets) > 0
  use_nat_gateway     = var.provision_nat_gateway && local.has_public_subnets
  use_igw             = local.has_public_subnets
  use_private_rt      = local.use_nat_gateway && local.has_private_subnets
}
