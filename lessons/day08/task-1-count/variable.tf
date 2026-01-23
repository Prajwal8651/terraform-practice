variable "bucket_names" {
  type = list(string)

  default = [
    "count-demo-bucket-1-12345",
    "count-demo-bucket-2-12345"
  ]
}
