############################
# Task 7 Output
############################
output "resource_name" {
  value = var.tags["Name"]
}

############################
# Task 10: Deployment Summary
############################
output "deployment_summary" {
  value = {
    environment    = var.environment
    instance_count = var.config.instance_count
    name_tag       = var.tags["Name"]
  }
}
