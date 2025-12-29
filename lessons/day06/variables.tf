variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "bucket_name" {
  description = "Base bucket name"
  type        = string
  default     = "regera-bucket"
}
