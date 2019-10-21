locals {
  common_tags = {
    environment  = "${var.environment}"
    project      = "${var.project}"  
    creationtime = "${var.creation_time}"
  }
}
variable "vpc_id" { } 
variable "public_subnet_id" {}
variable "public_security_group_id" {}
variable "private_subnet_id" {}
variable "private_security_group_id" {}
variable "environment" {}
variable "project" {}
variable "creation_time" {}
variable "name" {
  default = "Lims"
}

data "aws_ami" "bastion" {
  most_recent = true
# owners      = ["aws-marketplace"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}




resource "aws_instance" "pub-srvs" {
count=1
ami = "ami-43a15f3e"
instance_type = "t2.nano"
#key_name="dell-dev"
subnet_id = var.public_subnet_id
vpc_security_group_ids = [var.public_security_group_id]
associate_public_ip_address=true
tags = "${merge(
    local.common_tags,
    map(
        "Name", "ec2-pub-${var.name}"
    )
)}"
} 


resource "aws_instance" "prv-srvs" {
count=1
ami = "ami-035b3c7efe6d061d5"
instance_type = "t2.nano"
#key_name="dell-dev"
subnet_id = var.private_subnet_id
vpc_security_group_ids = [var.private_security_group_id]
associate_public_ip_address=false

tags = "${merge(
    local.common_tags,
    map(
        "Name", "ec2-prv-${var.name}"
    )
)}"

}
