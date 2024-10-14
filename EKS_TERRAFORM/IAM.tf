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

# Attach the AmazonEKSClusterPolicy to the EKS role
resource "aws_iam_role_policy_attachment" "fullstack_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.fullstack_webapp_pod_role.name
}

# Attach the AmazonEKSVPCResourceController policy to the EKS role
resource "aws_iam_role_policy_attachment" "fullstack_eks_vpc_resource_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.fullstack_webapp_pod_role.name
}