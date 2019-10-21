locals {
  common_tags = {
    environment  = "${var.environment}"
    project      = "${var.project}"  
    creationtime = "${var.creation_time}"
  }
}

resource "aws_vpc" "primary_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support  =true
  tags = "${merge(
    local.common_tags,
    map(
        "Name", "vpc-${var.name}"
    )
)}"
}

resource aws_subnet "public_subnet"{
count=1
vpc_id=aws_vpc.primary_vpc.id
cidr_block = "${cidrsubnet(aws_vpc.primary_vpc.cidr_block, 8, count.index)}"
availability_zone=data.aws_availability_zones.azs.names[count.index]
tags = "${merge(
    local.common_tags,
    map(
        "Name", "pub-sub-${var.name}--${count.index + 1}"
    )
)}" 
}

resource aws_subnet "private_subnet"{
count=1
vpc_id=aws_vpc.primary_vpc.id
cidr_block = "${cidrsubnet(aws_vpc.primary_vpc.cidr_block, 8, count.index+2)}"
availability_zone=data.aws_availability_zones.azs.names[count.index]
tags = "${merge(
    local.common_tags,
    map(
        "Name", "pri-sub-${var.name}--${count.index + 1}"
    )
)}" 
}



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.primary_vpc.id
    tags = "${merge(
    local.common_tags,
    map(
        "Name", "igw-${var.name}"
    )
)}"
}

resource "aws_route_table" "pub_rt" {
   vpc_id = aws_vpc.primary_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
   tags = "${merge(
    local.common_tags,
    map(
        "Name", "pub-rt-${var.name}"
    )
)}"
}

resource "aws_route_table_association" "public"{
count = 1
subnet_id = "${element(aws_subnet.public_subnet.*.id,count.index)}"
route_table_id = "${aws_route_table.pub_rt.id}"
}


/* resource "aws_flow_log" "vpc-flow-logs" {
  iam_role_arn    = "${aws_iam_role.flowlogrole.arn}"
  log_destination = "${aws_cloudwatch_log_group.cw-flow-log-group.arn}"
  traffic_type    = "ALL"
  vpc_id=aws_vpc.primary_vpc.id
}
resource "aws_cloudwatch_log_group" "cw-flow-log-group" {
  name = "cw-flow-log-group"
  retention_in_days = 7
  tags = "${merge(
    local.common_tags,
    map(
        "Name", "cw-flowlogs-${var.name}"
    )
)}"

}
resource "aws_iam_role" "flowlogrole" {
  name = "flowlogrole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
} */


############# public ec2 

/* resource "aws_security_group" "pub_sg" {
  vpc_id = aws_vpc.primary_vpc.id
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
 */
/* resource "aws_instance" "pub-srvs" {
count=1
ami = "ami-035b3c7efe6d061d5"
instance_type = "t2.nano"
key_name="dell-dev"
subnet_id = aws_subnet.public_subnet.*.id[count.index]
vpc_security_group_ids = ["${aws_security_group.pub_sg.id}"]
associate_public_ip_address=true
tags = "${merge(
    local.common_tags,
    map(
        "Name", "pub-ec2-${var.name}"
    )
)}"
}  */

####### Private EC2 

/* resource "aws_security_group" "prv_sg" {
  vpc_id = aws_vpc.primary_vpc.id
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

resource "aws_instance" "prv-srvs" {
count=1
ami = "ami-035b3c7efe6d061d5"
instance_type = "t2.nano"
key_name="dell-dev"
subnet_id = aws_subnet.private_subnet.*.id[count.index]
vpc_security_group_ids = ["${aws_security_group.prv_sg.id}"]
associate_public_ip_address=true
tags = "${merge(
    local.common_tags,
    map(
        "Name", "ec2-prv-${var.name}"
    )
)}"
}  */
