output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "frontend_node_group_name" {
  value = aws_eks_node_group.frontend_node_group.node_group_name
}

output "backend_node_group_name" {
  value = aws_eks_node_group.backend_node_group.node_group_name
}