# variable.tf

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "ap-south-1" # Change to your preferred region
}

variable "eks_cluster_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster"
  type        = string
  sensitive   = true # Mark as sensitive
}

variable "instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t3.medium" # Change to your preferred instance type
}

variable "ssh_key_name" {
  description = "The name of the SSH key to access the EC2 instances"
  type        = string
  sensitive   = true # Mark as sensitive
}

variable "allowed_ssh_ips" {
  description = "CIDR block of allowed IPs for SSH access"
  type        = string
  default     = "0.0.0.0/0" # Modify this to restrict access for security purposes
}

variable "allowed_http_ips" {
  description = "CIDR block of allowed IPs for HTTP access"
  type        = string
  default     = "0.0.0.0/0" # Modify this to restrict access for security purposes
}

variable "allowed_https_ips" {
  description = "CIDR block of allowed IPs for HTTPS access"
  type        = string
  default     = "0.0.0.0/0" # Modify this to restrict access for security purposes
}
