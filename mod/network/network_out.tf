output "vpc_id" {
  value = aws_vpc.primary_vpc.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

/* output "public_sg" { 
  value = aws_security_group.pub_sg.id
} */