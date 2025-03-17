terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

# Provider-1 for us-east-1 (Default Provider)
provider "aws" {
   region = "eu-north-1"
   profile = "labprofile"
}

# Provider-2 for us-west-1
provider "aws" {
   region = "eu-west-3"
   profile = "labprofile"
   alias = "eu-west-3"
}

# Resource Block to create VPC in eu-west-3
resource "aws_vpc" "test_vpc_eu_west_3" {
   cidr_block = "10.2.0.0/16"
   provider = aws.eu-west-3
   tags = {
    "Name" = "test_vpc_eu_west_3"
   }
}