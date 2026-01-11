resource "aws_security_group" "demo_sg" {
  name = "lifecycle-demo-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_s3_bucket" "critical" {
  bucket = "prajwal-lifecycle-demo-12345"

  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_instance" "demo" {
  ami           = "ami-00f46ccd1cbfb363e"
  instance_type = var.instance_type

  associate_public_ip_address = true
  security_groups             = [aws_security_group.demo_sg.name]

  tags = {
    Name        = "lifecycle-demo"
    Environment = var.environment
  }

  lifecycle {

    # 1️⃣ create_before_destroy
    create_before_destroy = true

    # 2️⃣ ignore_changes
    ignore_changes = [
      tags["Environment"]
    ]

    # 3️⃣ replace_triggered_by
    replace_triggered_by = [
      aws_security_group.demo_sg
    ]

    # 4️⃣ precondition
    precondition {
      condition     = var.instance_type == "t3.micro"
      error_message = "Only t2.micro is allowed."
    }

    # 5️⃣ postcondition
    postcondition {
      condition     = self.public_ip != ""
      error_message = "Instance must have a public IP."
    }
  }
}
