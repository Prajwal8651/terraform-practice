terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-state-1766811759"
    key          = "day05/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "bucket_name" {
  description = "Bucket name"
  type        = string
  default     = "regera-bucket"
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = "Terraform-Demo"
  }
  
  full_bucket_name = "${var.environment}-${var.bucket_name}-${random_string.suffix.result}"
  aws_vpc_name = "${var.environment}-vpc"
}


provider "aws" {
  # Configuration options
    region = "us-east-1"
}

resource "aws_vpc" "regera_vpc" {
    cidr_block = "10.0.0.0/16" 

    tags = {
        Name        =  local.full_bucket_name
        Environment = local.aws_vpc_name
    }
  
}

resource "aws_s3_bucket" "my_jeskoabsolut_bucket" {
    bucket =  local.full_bucket_name

    tags = {
        Name        = "My Jesko Absolut Bucket"
        Environment = "dev"
    }
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.my_jeskoabsolut_bucket.bucket

}

output "aws_vpc_name" {
  description = "Name of the vpc"
  value       = aws_vpc.regera_vpc.id


}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Output a resource attribute


output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.my_jeskoabsolut_bucket.arn
}

# Output an input variable (to confirm what was used)
output "environment" {
  description = "Environment from input variable"
  value       = var.environment
}

# Output a local variable (to see computed values)
output "tags" {
  description = "Tags from local variable"
  value       = local.common_tags
}

