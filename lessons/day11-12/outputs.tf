output "project_name" {
  value = local.project_sanitized
}

output "merged_tags" {
  value = local.merged_tags
}

output "bucket_name" {
  value = local.bucket_sanitized
}

output "security_group_ports" {
  value = local.sg_ports
}

output "instance_type_selected" {
  value = local.selected_instance
}

output "instance_type_valid" {
  value = local.instance_type_valid
}

output "backup_name_valid" {
  value = local.backup_name_valid
}

output "file_exists" {
  value = local.file_exists
}

output "file_directory" {
  value = local.file_dir
}

output "regions" {
  value = local.unique_regions
}

output "total_cost" {
  value = local.total_cost
}

output "current_date" {
  value = local.current_date
}

output "json_secret_payload" {
  value     = local.json_for_secret
  sensitive = true
}
