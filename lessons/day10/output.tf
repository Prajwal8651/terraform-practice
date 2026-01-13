output "allowed_ports" {
    description = "List of allowed ports for the security group"
    value       = var.ingress_rules[*].port
  
}