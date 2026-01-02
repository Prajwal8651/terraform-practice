############################
# Task 1 + 6: Region
############################
variable "region" {
  type        = string
  description = "AWS region"

  validation {
    condition     = contains(var.allowed_region, var.region)
    error_message = "Region is not allowed."
  }
}

variable "allowed_region" {
  type    = set(string)
  default = ["us-east-1", "us-west-2", "eu-west-1"]
}

############################
# Task 2: Number constraint
############################
variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
}

############################
# Task 3: Boolean constraint
############################
variable "monitoring_enabled" {
  type    = bool
  default = true
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

############################
# Task 4: List(string) CIDRs
############################
variable "cidr_block" {
  type    = list(string)
  default = ["10.0.0.0/16", "192.168.0.0/16", "172.16.0.0/12"]
}

############################
# Task 5: Allowed VM types
############################
variable "allowed_vm_types" {
  type    = list(string)
  default = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

############################
# Task 7: Tags map
############################
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "dev-Instance"
    created_by  = "terraform"
  }
}

############################
# Task 8: Tuple
############################
variable "ingress_values" {
  type    = tuple([number, string, number])
  default = [443, "tcp", 443]
}

############################
# Task 9: Object
############################
variable "config" {
  type = object({
    region         = string
    monitoring     = bool
    instance_count = number
  })

  default = {
    region         = "us-east-1"
    monitoring     = true
    instance_count = 1
  }
}

############################
# Task 10: Environment
############################
variable "environment" {
  type    = string
  default = "dev"
}

