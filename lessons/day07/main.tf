############################
# Task 4 & 7: VPC + Subnets
############################
resource "aws_vpc" "dev" {
  cidr_block = var.cidr_block[0]
  tags       = var.tags
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = var.cidr_block[1]
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = var.cidr_block[2]
}

############################
# Task 8: Security Group
############################
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.dev.id

  ingress {
    from_port   = var.ingress_values[0]
    protocol    = var.ingress_values[1]
    to_port     = var.ingress_values[2]
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# Task 2,3,5,9: EC2
############################
resource "aws_instance" "ec2" {
  count         = var.config.instance_count
  ami           = "ami-0c02fb55956c7d316"
  instance_type = var.instance_type
  monitoring    = var.config.monitoring

  associate_public_ip_address = var.associate_public_ip

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.subnet_1.id
  tags                   = var.tags

  lifecycle {
    precondition {
      condition     = contains(var.allowed_vm_types, var.instance_type)
      error_message = "Instance type is not allowed."
    }
  }
}
