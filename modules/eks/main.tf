resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [var.subnet_1_id, var.subnet_2_id]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.eks_cloudwatch,
  ]
}

# Create IAM Role for EKS Cluster
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_role" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_role.name
}

# Enable cloudwatch for control plane logging
resource "aws_cloudwatch_log_group" "eks_cloudwatch" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

}

# Create IAM Roles for service accounts
data "tls_certificate" "tls" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "openid_connect_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.tls.url
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.openid_connect_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.openid_connect_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "service_accounts" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = "service-accounts-role"
}

# Create EKS Node Group
resource "aws_eks_node_group" "frontend_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "frontend-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [var.subnet_1_id, var.subnet_2_id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key = var.key_name
    source_security_group_ids = var.security_group_id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "backend_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "backend-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [var.subnet_1_id, var.subnet_2_id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key = var.key_name
    source_security_group_ids = var.security_group_id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "node_role" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}