provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "count_buckets" {
  count  = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  tags = {
    Name = var.bucket_names[count.index]
    Type = "count-example"
  }
}
