provider "aws" {
  region     = var.region
}

data "aws_ami" "the_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*" ]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = [ "099720109477" ]
}

resource "aws_vpc" "vpc1" {
  cidr_block       = "10.0.1.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
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

resource "aws_vpc" "vpc2" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "vpc2"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet2"
  }
}

resource "aws_security_group" "allow_ssh_2" {
  name        = "allow_ssh_2"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc2.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_2"
  }
}

resource "aws_instance" "instance1" {
  ami                    = data.aws_ami.the_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet1.id
  security_groups        = [aws_security_group.allow_ssh_1.id]
  key_name               = "keys1"
 }

 resource "aws_instance" "instance2" {
   ami                    = data.aws_ami.the_ami.id
   instance_type          = var.instance_type
   subnet_id              = aws_subnet.subnet2.id
   security_groups        = [aws_security_group.allow_ssh_2.id]
   key_name               = "keys1"
  }
