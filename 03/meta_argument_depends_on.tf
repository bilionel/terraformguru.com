# Terraform Block
terraform {
  required_version = "~> 0.14.6"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = "eu-west-3"
  profile = "labprofile"
}

# Resource Block
# Resource-1: Create VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "name" = "vpc-dev"
  }
}

# Resource-2: Create Subnets
resource "aws_subnet" "vpc-dev-public-subnet-1" {
  vpc_id = aws_vpc.vpc-dev.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-3a"
  map_public_ip_on_launch = true
}

# Resource-3: Internet Gateway
resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = aws_vpc.vpc-dev.id
}

# Resource-4: Create Route Table
resource "aws_route_table" "vpc-dev-public-route-Table" {
  vpc_id = aws_vpc.vpc-dev.id
}

# Resource-5: Create Rounte in Route Table for Internet Access
resource "aws_route" "vpc-dev-public-route" {
  route_table_id = aws_route_table.vpc-dev-public-route-Table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.vpc-dev-igw.id
}

# Resource-6: Associate the Route Table with the subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate" {
  route_table_id = aws_route_table.vpc-dev-public-route-Table.id
  subnet_id = aws_subnet.vpc-dev-public-subnet-1.id
}

# Resource-7: Create Security Group
resource "aws_security_group" "dev-vpc-sg" {
  name = "dev-vpc-default-sg"
  vpc_id = aws_vpc.vpc-dev.id
  description = "Dev VPC Default Security Group"

  ingress {
    description = "Allow Port 22"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all ip and ports outboun"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Resource-8: Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami = "ami-0eaf62527f5bb8940"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.vpc-dev-public-subnet-1.id
  key_name = "terraform-key"
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in eu-west-3 Region</h1>" > /var/www/html/index.html
    EOF
  vpc_security_group_ids = [ aws_security_group.dev-vpc-sg.id ]
}

# Resource-9: Create Elastic ip
resource "aws_eip" "my-eip" {
  instance = aws_instance.my-ec2-vm.id
  vpc = true
  depends_on = [ aws_internet_gateway.vpc-dev-igw ]
}