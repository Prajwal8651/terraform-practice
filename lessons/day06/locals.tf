locals {
  common_tags = {
    Environment = var.environment
    Project     = "Terraform-Demo"
  }

  full_bucket_name = "${var.environment}-${var.bucket_name}-${random_string.suffix.result}"
  aws_vpc_name     = "${var.environment}-vpc"
}
