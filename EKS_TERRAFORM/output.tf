# output.tf

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.fullstack_webapp_cluster.name
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = aws_eks_cluster.fullstack_webapp_cluster.endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Certificate authority data for EKS"
  value       = aws_eks_cluster.fullstack_webapp_cluster.certificate_authority[0].data
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.fullstack_webapplication.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.fullstack_webapplication_public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.fullstack_webapplication_private_subnet.id
}

output "security_group_id" {
  description = "The ID of the security group for the web application"
  value       = aws_security_group.fullstack_webapplication_sg.id
}
