provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "foreach_buckets" {
  for_each = var.bucket_names
  bucket   = each.value

  tags = {
    Name = each.value
    Type = "foreach-example"
  }
}
