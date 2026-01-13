resource "aws_security_group" "web_sg" {
  name = "web-sg"

  # ✅ Conditional + Dynamic Block + List of Objects
  dynamic "ingress" {
    for_each = var.environment == "prod" ? var.ingress_rules: []

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr]
    }
  }

  tags = {
    Environment = var.environment
  }
}
