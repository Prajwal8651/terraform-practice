provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "day03-vpc"
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "30daysofawsterraform-demo-bucket-12345"

  tags = {
    Name    = "day03-bucket"
    VPC_ID = aws_vpc.main_vpc.id
  }
}
