
# Create a Security Group for Pods
resource "aws_security_group" "fullstack_webapp_pod_sg" {
  vpc_id      = aws_vpc.fullstack_webapplication.id
  name        = "fullstack-webapp-pod-sg"
  description = "Security group for fullstack webapp pods"

  tags = {
    Name = "fullstack-webapp-pod-sg"
  }
}

# Associate Security Group with EKS Cluster
resource "aws_eks_cluster" "fullstack_webapp_cluster" {
  name     = "fullstack-webapp-cluster"
  role_arn = aws_iam_role.fullstack_webapp_pod_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.fullstack_webapplication_private_subnet.id,
      aws_subnet.fullstack_webapplication_public_subnet.id,
    ]

    security_group_ids = [
      aws_security_group.fullstack_webapp_pod_sg.id,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.fullstack_eks_cluster_policy,
    aws_iam_role_policy_attachment.fullstack_eks_vpc_resource_controller_policy,
    aws_iam_role_policy_attachment.pod_role_policy,
  ]
}

# Output EKS Cluster Endpoint
output "endpoint" {
  description = "taking value when created"
  value = aws_eks_cluster.fullstack_webapp_cluster.endpoint
}

# Output Kubernetes Certificate Authority Data
output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.fullstack_webapp_cluster.certificate_authority[0].data
}
