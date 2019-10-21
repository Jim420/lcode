variable "name" {
  default = "Lims"
}
variable "environment" {}
variable "project" {}
variable "creation_time" {}
variable "vpc_cidr" { }

data "aws_availability_zones" azs {}
