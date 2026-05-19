variable "aws_region" {
    description = "The AWS region to create resource in."
    type = string
    default = "us-east-1"
}

variable "bucket_name" {
    description = "prefix for the s3 bucket name."
    type = string
    default = "my-static-website"
}