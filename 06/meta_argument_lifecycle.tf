terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "eu-west-3"
  profile = "labprofile"
}

# ec2 instance
resource "aws_instance" "web" {
  ami = "ami-0eaf62527f5bb8940"
  instance_type = "t3.micro"
  tags = {
    "Name" = "web-server"
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}