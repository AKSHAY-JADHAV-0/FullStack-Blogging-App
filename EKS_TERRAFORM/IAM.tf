# main.tf

# IAM Role for Service Account
resource "aws_iam_role" "fullstack_webapp_pod_role" {
  name               = "fullstack-webapp-pod-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "fullstack-webapp-pod-role"
  }
}

# Attach necessary policies to the IAM Role
resource "aws_iam_role_policy_attachment" "pod_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.fullstack_webapp_pod_role.name
}

# Create a Security Group for Pods
resource "aws_security_group" "fullstack_webapp_pod_sg" {
  vpc_id      = aws_vpc.fullstack_webapp.id
  name        = "fullstack-webapp-pod-sg"
  description = "Security group for fullstack webapp pods"

  tags = {
    Name = "fullstack-webapp-pod-sg"
  }
}

# Associate Security Group with EKS Cluster
resource "aws_eks_cluster" "fullstack_webapp_cluster" {
  name     = "app-01"
  role_arn = aws_iam_role.fullstack_webapp_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.fullstack_webapp_private_subnet.id,
      aws_subnet.fullstack_webapp_public_subnet.id,
    ]

    security_group_ids = [
      aws_security_group.fullstack_webapp_pod_sg.id,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.example_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example_AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.pod_role_policy,
  ]
}
