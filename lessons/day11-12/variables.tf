variable "project_name" {
  default = "Project ALPHA Resource"
}

variable "default_tags" {
  default = {
    Owner = "DevOps"
    Team  = "Platform"
  }
}

variable "env_tags" {
  default = {
    Environment = "dev"
  }
}

variable "bucket_name" {
  default = "My_S3.Bucket@2026"
}

variable "ports" {
  default = "80,443,8080"
}

variable "environment" {
  default = "prod"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "backup_name" {
  default = "daily-backup"
}

variable "backup_key" {
  default = "super-secret-key"
}

variable "file_path" {
  default = "./config/app.json"
}

variable "regions_primary" {
  default = ["us-east-1", "us-west-2"]
}

variable "regions_secondary" {
  default = ["us-west-2", "eu-west-1"]
}

variable "costs" {
  default = [120, 80, -20]
}
