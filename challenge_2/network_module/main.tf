# This module creates a new vpc, subnet, security group to allow ssh access, and then creates a routing table
# and associates routing table with subnet to allow external IP connections 

resource "aws_vpc" "vpc1" {
  cidr_block       = "10.0.1.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet1"
  }
}

resource "aws_security_group" "allow_ssh_1" {
  name        = "allow_ssh_1"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_1"
  }
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table.id
}
