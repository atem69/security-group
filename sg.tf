form {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

variable "name" {
  type = string
}

resource "aws_security_group" "ced_sg" {
  name = var.name
  description = "allow SSH, HTTPS and HTTP"

  dynamic "ingress" {
    for_each = [ 433, 22, 80 ]
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}  

output "sg_id" {
  value = aws_security_group.ced_sg.id
}

