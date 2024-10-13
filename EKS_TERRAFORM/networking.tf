# network.tf
# Create VPC
resource "aws_vpc" "fullstack_webapplication" {
    cidr_block = "10.0.0.0/16" # Example CIDR block, adjust as needed

    tags = {
        Name = "fullstack-webapplication-vpc"
    }
}

# Create Public Subnet
resource "aws_subnet" "fullstack_webapplication_public_subnet" {
    cidr_block              = "10.0.1.0/24" # Adjust CIDR block as needed
    availability_zone       = "ap-south-1a" # Specify AZ correctly
    vpc_id                  = aws_vpc.fullstack_webapplication.id
    map_public_ip_on_launch = true # Automatically assign public IPs for instances

    tags = {
        Name = "fullstack-webapplication-public-subnet"
    }
}

# Create Private Subnet
resource "aws_subnet" "fullstack_webapplication_private_subnet" {
    cidr_block = "10.0.2.0/24" # Adjust CIDR block as needed
    availability_zone = "ap-south-1a" # Specify AZ to match public subnet
    vpc_id     = aws_vpc.fullstack_webapplication.id

    tags = {
        Name = "fullstack-webapplication-private-subnet"
    }
}

# Create Internet Gateway for Public Subnet
resource "aws_internet_gateway" "fullstack_webapplication_igw" {
    vpc_id = aws_vpc.fullstack_webapplication.id

    tags = {
        Name = "fullstack-webapplication-igw"
    }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "fullstack_webapplication_public_route_table" {
    vpc_id = aws_vpc.fullstack_webapplication.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.fullstack_webapplication_igw.id
    }

    tags = {
        Name = "fullstack-webapplication-public-route-table"
    }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "fullstack_webapplication_public_subnet_association" {
    subnet_id      = aws_subnet.fullstack_webapplication_public_subnet.id
    route_table_id = aws_route_table.fullstack_webapplication_public_route_table.id
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "fullstack_webapplication_nat_eip" {
    tags = {
        Name = "fullstack-webapplication-nat-eip"
    }
}

# Create NAT Gateway in Public Subnet
resource "aws_nat_gateway" "fullstack_webapplication_nat_gateway" {
    allocation_id = aws_eip.fullstack_webapplication_nat_eip.id
    subnet_id     = aws_subnet.fullstack_webapplication_public_subnet.id

    tags = {
        Name = "fullstack-webapplication-nat-gateway"
    }
}

# Create Route Table for Private Subnet
resource "aws_route_table" "fullstack_webapplication_private_route_table" {
    vpc_id = aws_vpc.fullstack_webapplication.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.fullstack_webapplication_nat_gateway.id
    }

    tags = {
        Name = "fullstack-webapplication-private-route-table"
    }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "fullstack_webapplication_private_subnet_association" {
    subnet_id      = aws_subnet.fullstack_webapplication_private_subnet.id
    route_table_id = aws_route_table.fullstack_webapplication_private_route_table.id
}

# Create Security Group
resource "aws_security_group" "fullstack_webapplication_sg" {
    name        = "fullstack-webapplication-sg"
    description = "Security group for fullstack web application"
    vpc_id      = aws_vpc.fullstack_webapplication.id

    tags = {
        Name = "fullstack-webapplication-sg"
    }
}

# Ingress Rule - Allow SSH
resource "aws_security_group_rule" "fullstack_webapplication_allow_ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"] # Open to all (for SSH), modify as needed
    security_group_id = aws_security_group.fullstack_webapplication_sg.id
}

# Ingress Rule - Allow HTTP (80)
resource "aws_security_group_rule" "fullstack_webapplication_allow_http" {
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"] # Open to all for HTTP
    security_group_id = aws_security_group.fullstack_webapplication_sg.id
}

# Ingress Rule - Allow HTTPS (443)
resource "aws_security_group_rule" "fullstack_webapplication_allow_https" {
    type              = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"] # Open to all for HTTPS
    security_group_id = aws_security_group.fullstack_webapplication_sg.id
}

# Egress Rule - Allow all outbound traffic
resource "aws_security_group_rule" "fullstack_webapplication_allow_all_outbound_ipv4" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1" # Allow all protocols
    cidr_blocks       = ["0.0.0.0/0"] # Allow outbound traffic to all
    security_group_id = aws_security_group.fullstack_webapplication_sg.id
}

# Egress Rule - Allow all outbound traffic (IPv6)
resource "aws_security_group_rule" "fullstack_webapplication_allow_all_outbound_ipv6" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1" # Allow all protocols
    ipv6_cidr_blocks  = ["::/0"] # Allow outbound traffic for IPv6
    security_group_id = aws_security_group.fullstack_webapplication_sg.id
}
