terraform {
  backend "s3" {
    bucket       = "terraform-state-1766811759"
    key          = "day14ls/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}