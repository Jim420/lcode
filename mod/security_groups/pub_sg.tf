locals {
  common_tags = {
    environment  = "${var.environment}"
    project      = "${var.project}"  
    creationtime = "${var.creation_time}"
  }
}

variable "environment" {}
variable "project" {}
variable "creation_time" {}


variable "vpc_id" { }

variable "name" {
  default = "Lims"
}

resource "aws_security_group" "pub_sg" {
  vpc_id = var.vpc_id
  name = "public-sg"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = "${merge(
    local.common_tags,
    map(
        "Name", "pub-sg-${var.name}"
    )
)}" 
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "prv_sg" {
  vpc_id = var.vpc_id
  name = "private-sg"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = ["${aws_security_group.pub_sg.id}"]
  
  }
  tags = "${merge(
    local.common_tags,
    map(
        "Name", "prv-sg-${var.name}"
    )
)}"
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "public_sg" { 
  value = aws_security_group.pub_sg.id
}

output "private_sg" { 
  value = aws_security_group.prv_sg.id
}