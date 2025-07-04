locals {
  ami_type_map = {
    arm = "AL2023_ARM_64_STANDARD"
    amd = "AL2023_x86_64_STANDARD"
  }

  selected_ami_type = local.ami_type_map[var.eks_node_arch_type]
}
