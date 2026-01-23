variable "bucket_names" {
  type = set(string)

  default = [
    "foreach-demo-bucket-1-12345",
    "foreach-demo-bucket-2-12345"
  ]
}
