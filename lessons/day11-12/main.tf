terraform {
  required_version = ">= 1.3.0"
}

locals {

  #################################
  # Assignment 1: Project Naming
  #################################
  project_sanitized = replace(lower(var.project_name), " ", "-")

  #################################
  # Assignment 2: Resource Tagging
  #################################
  merged_tags = merge(var.default_tags, var.env_tags)

  #################################
  # Assignment 3: S3 Bucket Naming
  #################################
  bucket_sanitized = substr(
    replace(
      replace(
        replace(lower(var.bucket_name), "_", "-"),
        ".", "-"
      ),
      "@", "-"
    ),
    0,
    63
  )

  #################################
  # Assignment 4: Security Group Ports
  #################################
  sg_ports = [
    for p in split(",", var.ports) : {
      from = tonumber(p)
      to   = tonumber(p)
    }
  ]

  #################################
  # Assignment 5: Environment Lookup
  #################################
  instance_map = {
    dev  = "t2.micro"
    qa   = "t2.small"
    prod = "t3.medium"
  }

  selected_instance = lookup(local.instance_map, var.environment, "t2.micro")

  #################################
  # Assignment 6: Instance Validation
  #################################
  instance_type_valid = (
    length(var.instance_type) > 2 &&
    can(regex("^t[0-9]\\.(micro|small|medium|large)$", var.instance_type))
  )

  #################################
  # Assignment 7: Backup Configuration
  #################################
  backup_name_valid = endswith(var.backup_name, "-backup")
  backup_key_safe   = sensitive(var.backup_key)

  #################################
  # Assignment 8: File Path Processing
  #################################
  file_exists = fileexists(var.file_path)
  file_dir    = dirname(var.file_path)

  #################################
  # Assignment 9: Location Management
  #################################
  unique_regions = toset(concat(var.regions_primary, var.regions_secondary))

  #################################
  # Assignment 10: Cost Calculation
  #################################
  normalized_costs = [for c in var.costs : abs(c)]
  total_cost       = max(sum(local.normalized_costs), 0)

  #################################
  # Assignment 11: Timestamp Management
  #################################
  current_date = formatdate("YYYY-MM-DD", timestamp())

  #################################
  # Assignment 12: File Content Handling
  #################################
  json_raw        = file(var.file_path)
  json_decoded    = jsondecode(local.json_raw)
  json_for_secret = sensitive(jsonencode(local.json_decoded))
}
