terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "labprofile"
  region = "eu-west-3"
}

# Create EC2 Instance
resource "aws_instance" "web" {
  ami = "ami-0eaf62527f5bb8940"
  instance_type = "t3.micro"
  count = 5
  tags = {
    "Name" = "web-${count.index}"
  }
}

