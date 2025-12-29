terraform {
  backend "s3" {
    bucket       = "terraform-state-1766811759"
    key          = "day06/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
