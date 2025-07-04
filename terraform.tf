terraform {
  required_version = ">=1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {}

  backend "remote" {}
}

provider "aws" {
  region = var.region

  default_tags {
    tags = merge(
      var.tags,
      {
        "TF-Workspace" = terraform.workspace,
        "arch_type"    = var.eks_node_arch_type
      }
    )
  }
}
