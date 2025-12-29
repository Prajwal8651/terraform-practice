resource "aws_vpc" "regera_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    local.common_tags,
    {
      Name = local.aws_vpc_name
    }
  )
}

resource "aws_s3_bucket" "my_jeskoabsolut_bucket" {
  bucket = local.full_bucket_name

  tags = merge(
    local.common_tags,
    {
      Name = local.full_bucket_name
    }
  )
}
