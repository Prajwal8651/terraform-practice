# =====================================================
# OUTPUTS FOR FULL MESH VPC PEERING DEMO
# =====================================================

# =====================================================
# VPC IDS
# =====================================================

output "primary_vpc_id" {
  description = "ID of the Primary VPC"
  value       = aws_vpc.primary_vpc.id
}

output "secondary_vpc_id" {
  description = "ID of the Secondary VPC"
  value       = aws_vpc.secondary_vpc.id
}

output "tertiary_vpc_id" {
  description = "ID of the Tertiary VPC"
  value       = aws_vpc.tertiary_vpc.id
}

# =====================================================
# VPC CIDR BLOCKS
# =====================================================

output "primary_vpc_cidr" {
  description = "CIDR block of the Primary VPC"
  value       = aws_vpc.primary_vpc.cidr_block
}

output "secondary_vpc_cidr" {
  description = "CIDR block of the Secondary VPC"
  value       = aws_vpc.secondary_vpc.cidr_block
}

output "tertiary_vpc_cidr" {
  description = "CIDR block of the Tertiary VPC"
  value       = aws_vpc.tertiary_vpc.cidr_block
}

# =====================================================
# PEERING CONNECTION IDS
# =====================================================

output "primary_to_secondary_peering_id" {
  description = "Primary to Secondary VPC Peering Connection ID"
  value       = aws_vpc_peering_connection.primary_to_secondary.id
}

output "secondary_to_tertiary_peering_id" {
  description = "Secondary to Tertiary VPC Peering Connection ID"
  value       = aws_vpc_peering_connection.secondary_to_tertiary.id
}

output "tertiary_to_primary_peering_id" {
  description = "Tertiary to Primary VPC Peering Connection ID"
  value       = aws_vpc_peering_connection.tertiary_to_primary.id
}

# =====================================================
# PEERING STATUS
# =====================================================

output "primary_to_secondary_peering_status" {
  description = "Status of Primary to Secondary Peering"
  value       = aws_vpc_peering_connection.primary_to_secondary.accept_status
}

output "secondary_to_tertiary_peering_status" {
  description = "Status of Secondary to Tertiary Peering"
  value       = aws_vpc_peering_connection.secondary_to_tertiary.accept_status
}

output "tertiary_to_primary_peering_status" {
  description = "Status of Tertiary to Primary Peering"
  value       = aws_vpc_peering_connection.tertiary_to_primary.accept_status
}

# =====================================================
# EC2 INSTANCE IDS
# =====================================================

output "primary_instance_id" {
  description = "ID of the Primary Bastion EC2 Instance"
  value       = aws_instance.primary_instance.id
}

output "secondary_instance_id" {
  description = "ID of the Secondary Private EC2 Instance"
  value       = aws_instance.secondary_instance.id
}

output "tertiary_instance_id" {
  description = "ID of the Tertiary Private EC2 Instance"
  value       = aws_instance.tertiary_instance.id
}

# =====================================================
# PRIVATE IPS
# =====================================================

output "primary_instance_private_ip" {
  description = "Private IP of the Primary EC2 Instance"
  value       = aws_instance.primary_instance.private_ip
}

output "secondary_instance_private_ip" {
  description = "Private IP of the Secondary EC2 Instance"
  value       = aws_instance.secondary_instance.private_ip
}

output "tertiary_instance_private_ip" {
  description = "Private IP of the Tertiary EC2 Instance"
  value       = aws_instance.tertiary_instance.private_ip
}

# =====================================================
# PUBLIC IP
# =====================================================

output "primary_instance_public_ip" {
  description = "Public IP of the Primary Bastion EC2 Instance"
  value       = aws_instance.primary_instance.public_ip
}

# =====================================================
# CONNECTIVITY TEST COMMANDS
# =====================================================

output "test_connectivity_commands" {
  description = "Commands to test connectivity between VPCs"

  value = <<-EOT

  ================================
  SSH INTO PRIMARY BASTION HOST
  ================================

  ssh -i your-key.pem ubuntu@${aws_instance.primary_instance.public_ip}

  ================================
  TEST PRIMARY -> SECONDARY
  ================================

  ping ${aws_instance.secondary_instance.private_ip}

  curl http://${aws_instance.secondary_instance.private_ip}

  ssh -i secondary-key.pem ubuntu@${aws_instance.secondary_instance.private_ip}

  ================================
  TEST PRIMARY -> TERTIARY
  ================================

  ping ${aws_instance.tertiary_instance.private_ip}

  curl http://${aws_instance.tertiary_instance.private_ip}

  ssh -i tertiary-key.pem ubuntu@${aws_instance.tertiary_instance.private_ip}

  ================================
  TEST SECONDARY -> PRIMARY
  ================================

  ping ${aws_instance.primary_instance.private_ip}

  ================================
  TEST TERTIARY -> PRIMARY
  ================================

  ping ${aws_instance.primary_instance.private_ip}

  EOT
}