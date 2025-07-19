resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.environment}-eks-cluster-role-${local.arch_type_launch_type}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.environment}-eks-cluster-role-${local.arch_type_launch_type}"
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.environment}-eks-cluster-${local.arch_type_launch_type}"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Name = "${var.environment}-eks-cluster-${local.arch_type_launch_type}"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EC2 Node Group resources
resource "aws_iam_role" "eks_node_group_role" {
  count = var.eks_launch_type == "ec2" ? 1 : 0
  name  = "${var.environment}-eks-node-group-role-${local.arch_type_launch_type}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.environment}-eks-node-group-role-${local.arch_type_launch_type}"
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy" {
  count      = var.eks_launch_type == "ec2" ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  count      = var.eks_launch_type == "ec2" ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  count      = var.eks_launch_type == "ec2" ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "eks_node_group" {
  count           = var.eks_launch_type == "ec2" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.environment}-eks-node-group-${local.arch_type_launch_type}"
  node_role_arn   = aws_iam_role.eks_node_group_role[0].arn

  scaling_config {
    desired_size = var.eks_node_group_desired_capacity
    min_size     = var.eks_node_group_min_size
    max_size     = var.eks_node_group_max_size
  }

  instance_types = [var.eks_node_instance_type]
  ami_type       = local.selected_ami_type

  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.environment}-eks-node-group-${local.arch_type_launch_type}"
  }
}

# Fargate Profile resources
resource "aws_iam_role" "fargate_pod_execution_role" {
  count = var.eks_launch_type == "fargate" ? 1 : 0

  name = "${var.environment}-eks-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks-fargate-pods.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.environment}-eks-fargate-pod-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
  count      = var.eks_launch_type == "fargate" ? 1 : 0
  role       = aws_iam_role.fargate_pod_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_eks_fargate_profile" "fargate_profile" {
  count                  = var.eks_launch_type == "fargate" ? 1 : 0
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "${var.environment}-fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role[0].arn
  subnet_ids             = var.subnet_ids

  dynamic "selector" {
    for_each = var.fargate_profile_namespaces
    content {
      namespace = selector.value
    }
  }

  # Add CoreDNS to use Fargate
  selector {
    namespace = "kube-system"
    labels = {
      k8s-app = "kube-dns"
    }
  }

  tags = {
    Name = "${var.environment}-fargate-profile"
  }
}


