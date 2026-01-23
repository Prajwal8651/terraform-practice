output "bucket_names" {
  value = [
    for bucket in aws_s3_bucket.foreach_buckets :
    bucket.bucket
  ]
}
