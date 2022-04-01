provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
ami = var.ami
instance_type = var.instance_type
key_name = aws_key_pair.deployer.key_name
vpc_security_group_ids = [aws_security_group.allow_tls.id]
tags = {
Name = var.ec2_tag
}
}
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.sg_tag
  }
}

