provider "aws" {
  region = var.region
}

data "aws_ami" "the_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"]
}

module "network_module" {
  source            = "./network_module"
}

resource "aws_instance" "instance1" {
  ami                    = data.aws_ami.the_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [data.aws_security_group.default.id, aws_security_group.allow_ssh_1.id]
  key_name               = "keys1"
}
