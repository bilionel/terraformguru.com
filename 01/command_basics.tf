# Terraform Settings Block
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        #version = "~> 3,21" # Optional but recommended in production
    }
  }
}

# Provider Block
provider "aws" {
  profile = "labprofile"
  region = "eu-north-1"
}

# Resource Block
resource "aws_instance" "ec2demo" {
  ami = "ami-0c2e61fdcb5495691"
  instance_type = "t3.micro"
}