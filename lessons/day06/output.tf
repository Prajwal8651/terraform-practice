output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.my_jeskoabsolut_bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.my_jeskoabsolut_bucket.arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.regera_vpc.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = local.aws_vpc_name
}

output "environment" {
  description = "Environment used"
  value       = var.environment
}

output "tags" {
  description = "Common tags"
  value       = local.common_tags
}
