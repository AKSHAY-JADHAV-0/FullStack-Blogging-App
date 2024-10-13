# main.tf
# Creating EC2 instance for launching EKS

resource "aws_eks_cluster" "fullstack-webapplication-cluster" {
  name     = "fullstack-webapplication-cluster"
  role_arn = aws_iam_role.fullstack-webapplication-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.fullstack-webapplication-private-subnet.id, aws_subnet.fullstack-webapplication-public-subnet.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.fullstack-webapplication-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.fullstack-webapplication-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.fullstack-webapplication-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.fullstack-webapplication-cluster.certificate_authority[0].data
}
