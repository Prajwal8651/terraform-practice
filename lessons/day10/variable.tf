variable "environment" {
  type = string
  default = "Deployment environment"
}

variable "ingress_rules" {
  type = list(object({
    port     = number
    protocol = string
    cidr     = string
  }))
}
