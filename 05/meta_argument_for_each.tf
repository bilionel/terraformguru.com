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

# Create S3 Bucket per environment with for_each and maps
resource "aws_s3_bucket" "mys3bucket" {

  for_each = {
    dev  = "my-dapp-bucket"
    qa   = "my-qapp-bucket"
    stag = "my-sapp-bucket"
    prod = "my-papp-bucket"
  }

  bucket = "20250328-${each.key}-${each.value}"

  tags = {
    eachvalue   = each.value
    Environment = each.key
    bucketname  = "${each.key}-${each.value}"
  }
}

# Create 4 IAM Users
resource "aws_iam_user" "myuser" {
  for_each = toset(["Jack", "James", "Madhu", "Dave"])
  name = each.key
}