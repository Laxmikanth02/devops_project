#Provider Plugin Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Provider Block
provider "aws" {
  region = "eu-north-1"
  profile = "project1"
}
#Resource block
resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Allow SSH and custom port"
  vpc_id      = "vpc-064844fbdba0dda9d"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my_sg"
  }
}
resource "aws_instance" "my_instance" {
  ami           = "ami-07a0715df72e58928" # This is an example AMI ID, replace with a current t3.micro compatible AMI in ap-south-1
  instance_type = "t3.medium"
  subnet_id     = "subnet-007f35405ee92b28f"
  root_block_device {
  volume_size = 10
  }
  security_groups = [aws_security_group.my_sg.id]
    user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install software-properties-common -y
              sudo add-apt-repository --yes --update ppa:ansible/ansible
              sudo apt install ansible -y
              EOF
  tags = {
    Name = "MyController"
  }
}