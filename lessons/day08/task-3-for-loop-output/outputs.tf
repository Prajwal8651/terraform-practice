output "bucket_names" {
  value = [
    for bucket in aws_s3_bucket.buckets :
    bucket.bucket
  ]
}
output "bucket_ids" {
  value = [
    for bucket in aws_s3_bucket.buckets :
    bucket.id
  ]
}

output "bucket_name_id_map" {
  value = {
    for key, bucket in aws_s3_bucket.buckets :
    key => bucket.id
  }
}
