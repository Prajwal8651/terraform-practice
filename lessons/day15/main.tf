# =====================================================
# VPC PEERING DEMO - FULL MESH MULTI REGION SETUP
# =====================================================

# =====================================================
# PRIMARY VPC (us-east-1)
# =====================================================

resource "aws_vpc" "primary_vpc" {
  provider             = aws.primary
  cidr_block           = var.primary_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Primary-VPC-${var.primary_region}"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# SECONDARY VPC (us-west-2)
# =====================================================

resource "aws_vpc" "secondary_vpc" {
  provider             = aws.secondary
  cidr_block           = var.secondary_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Secondary-VPC-${var.secondary_region}"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# TERTIARY VPC (ap-south-1)
# =====================================================

resource "aws_vpc" "tertiary_vpc" {
  provider             = aws.tertiary
  cidr_block           = var.tertiary_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Tertiary-VPC-${var.tertiary_region}"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# PRIMARY PUBLIC SUBNET
# =====================================================

resource "aws_subnet" "primary_subnet" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.primary_subnet_cidr
  availability_zone       = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Primary-Public-Subnet"
    Environment = "Demo"
    Type        = "Public"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# SECONDARY PRIVATE SUBNET
# =====================================================

resource "aws_subnet" "secondary_subnet" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary_vpc.id
  cidr_block              = var.secondary_subnet_cidr
  availability_zone       = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "Secondary-Private-Subnet"
    Environment = "Demo"
    Type        = "Private"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# TERTIARY PRIVATE SUBNET
# =====================================================

resource "aws_subnet" "tertiary_subnet" {
  provider                = aws.tertiary
  vpc_id                  = aws_vpc.tertiary_vpc.id
  cidr_block              = var.tertiary_subnet_cidr
  availability_zone       = data.aws_availability_zones.tertiary.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "Tertiary-Private-Subnet"
    Environment = "Demo"
    Type        = "Private"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# INTERNET GATEWAY
# =====================================================

resource "aws_internet_gateway" "primary_igw" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  tags = {
    Name        = "Primary-IGW"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# PRIMARY ROUTE TABLE
# =====================================================

resource "aws_route_table" "primary_rt" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }

  tags = {
    Name        = "Primary-Route-Table"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# SECONDARY ROUTE TABLE
# =====================================================

resource "aws_route_table" "secondary_rt" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary_vpc.id

  tags = {
    Name        = "Secondary-Private-Route-Table"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# TERTIARY ROUTE TABLE
# =====================================================

resource "aws_route_table" "tertiary_rt" {
  provider = aws.tertiary
  vpc_id   = aws_vpc.tertiary_vpc.id

  tags = {
    Name        = "Tertiary-Private-Route-Table"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# ROUTE TABLE ASSOCIATIONS
# =====================================================

resource "aws_route_table_association" "primary_rta" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_rt.id
}

resource "aws_route_table_association" "secondary_rta" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_rt.id
}

resource "aws_route_table_association" "tertiary_rta" {
  provider       = aws.tertiary
  subnet_id      = aws_subnet.tertiary_subnet.id
  route_table_id = aws_route_table.tertiary_rt.id
}

# =====================================================
# PRIMARY ↔ SECONDARY PEERING
# =====================================================

resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider    = aws.primary
  vpc_id      = aws_vpc.primary_vpc.id
  peer_vpc_id = aws_vpc.secondary_vpc.id
  peer_region = var.secondary_region
  auto_accept = false

  tags = {
    Name        = "Primary-to-Secondary-Peering"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

resource "aws_vpc_peering_connection_accepter" "secondary_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true
}

# =====================================================
# SECONDARY ↔ TERTIARY PEERING
# =====================================================

resource "aws_vpc_peering_connection" "secondary_to_tertiary" {
  provider    = aws.secondary
  vpc_id      = aws_vpc.secondary_vpc.id
  peer_vpc_id = aws_vpc.tertiary_vpc.id
  peer_region = var.tertiary_region
  auto_accept = false

  tags = {
    Name        = "Secondary-to-Tertiary-Peering"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

resource "aws_vpc_peering_connection_accepter" "tertiary_accept_secondary" {
  provider                  = aws.tertiary
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_tertiary.id
  auto_accept               = true
}

# =====================================================
# TERTIARY ↔ PRIMARY PEERING
# =====================================================

resource "aws_vpc_peering_connection" "tertiary_to_primary" {
  provider    = aws.tertiary
  vpc_id      = aws_vpc.tertiary_vpc.id
  peer_vpc_id = aws_vpc.primary_vpc.id
  peer_region = var.primary_region
  auto_accept = false

  tags = {
    Name        = "Tertiary-to-Primary-Peering"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

resource "aws_vpc_peering_connection_accepter" "primary_accept_tertiary" {
  provider                  = aws.primary
  vpc_peering_connection_id = aws_vpc_peering_connection.tertiary_to_primary.id
  auto_accept               = true
}

# =====================================================
# PRIMARY ROUTES
# =====================================================

resource "aws_route" "primary_to_secondary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [
    aws_vpc_peering_connection_accepter.secondary_accepter
  ]
}

resource "aws_route" "primary_to_tertiary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = var.tertiary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.tertiary_to_primary.id

  depends_on = [
    aws_vpc_peering_connection_accepter.primary_accept_tertiary
  ]
}

# =====================================================
# SECONDARY ROUTES
# =====================================================

resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [
    aws_vpc_peering_connection_accepter.secondary_accepter
  ]
}

resource "aws_route" "secondary_to_tertiary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = var.tertiary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_tertiary.id

  depends_on = [
    aws_vpc_peering_connection_accepter.tertiary_accept_secondary
  ]
}

# =====================================================
# TERTIARY ROUTES
# =====================================================

resource "aws_route" "tertiary_to_primary" {
  provider                  = aws.tertiary
  route_table_id            = aws_route_table.tertiary_rt.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.tertiary_to_primary.id

  depends_on = [
    aws_vpc_peering_connection_accepter.primary_accept_tertiary
  ]
}

resource "aws_route" "tertiary_to_secondary" {
  provider                  = aws.tertiary
  route_table_id            = aws_route_table.tertiary_rt.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_tertiary.id

  depends_on = [
    aws_vpc_peering_connection_accepter.tertiary_accept_secondary
  ]
}

# =====================================================
# PRIMARY SECURITY GROUP
# =====================================================

resource "aws_security_group" "primary_sg" {
  provider = aws.primary
  name     = "primary-vpc-sg"
  vpc_id   = aws_vpc.primary_vpc.id

  ingress {
    description = "SSH from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Peered VPCs"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"

    cidr_blocks = [
      var.secondary_vpc_cidr,
      var.tertiary_vpc_cidr
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Primary-SG"
    Environment = "Demo"
  }
}

# =====================================================
# SECONDARY SECURITY GROUP
# =====================================================

resource "aws_security_group" "secondary_sg" {
  provider = aws.secondary
  name     = "secondary-vpc-sg"
  vpc_id   = aws_vpc.secondary_vpc.id

  

  ingress {
    description = "SSH from Primary VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "ICMP from Peered VPCs"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"

    cidr_blocks = [
      var.primary_vpc_cidr,
      var.tertiary_vpc_cidr
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Peered VPCs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = [
      var.primary_vpc_cidr,
      var.secondary_vpc_cidr,
      var.tertiary_vpc_cidr
    ]
  }

  tags = {
    Name        = "Secondary-SG"
    Environment = "Demo"
  }
}

# =====================================================
# TERTIARY SECURITY GROUP
# =====================================================

resource "aws_security_group" "tertiary_sg" {
  provider = aws.tertiary
  name     = "tertiary-vpc-sg"
  vpc_id   = aws_vpc.tertiary_vpc.id

  ingress {
    description = "SSH from Peered VPCs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [
      var.primary_vpc_cidr,
      var.secondary_vpc_cidr
    ]
  }

  ingress {
    description = "ICMP from Peered VPCs"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"

    cidr_blocks = [
      var.primary_vpc_cidr,
      var.secondary_vpc_cidr
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Peered VPCs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = [
      var.primary_vpc_cidr,
      var.secondary_vpc_cidr,
      var.tertiary_vpc_cidr
    ]
  }

  tags = {
    Name        = "Tertiary-SG"
    Environment = "Demo"
  }
}

# =====================================================
# PRIMARY EC2 (PUBLIC BASTION)
# =====================================================

resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.primary_sg.id]
  key_name               = var.primary_key_name

  user_data = local.primary_user_data

  depends_on = [
    aws_route.primary_to_secondary,
    aws_route.primary_to_tertiary
  ]

  tags = {
    Name        = "Primary-Bastion-EC2"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# SECONDARY EC2 (PRIVATE)
# =====================================================

resource "aws_instance" "secondary_instance" {
  provider                    = aws.secondary
  ami                         = data.aws_ami.secondary_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.secondary_subnet.id
  vpc_security_group_ids      = [aws_security_group.secondary_sg.id]
  key_name                    = var.secondary_key_name
  associate_public_ip_address = false

  depends_on = [
    aws_route.secondary_to_primary,
    aws_route.secondary_to_tertiary
  ]

  tags = {
    Name        = "Secondary-Private-EC2"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# =====================================================
# TERTIARY EC2 (PRIVATE)
# =====================================================

resource "aws_instance" "tertiary_instance" {
  provider                    = aws.tertiary
  ami                         = data.aws_ami.tertiary_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.tertiary_subnet.id
  vpc_security_group_ids      = [aws_security_group.tertiary_sg.id]
  key_name                    = var.tertiary_key_name
  associate_public_ip_address = false

  depends_on = [
    aws_route.tertiary_to_primary,
    aws_route.tertiary_to_secondary
  ]

  tags = {
    Name        = "Tertiary-Private-EC2"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}