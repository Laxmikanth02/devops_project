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
resource "aws_security_group" "my_sg2" {
  name        = "my_sg2"
  description = "Allow SSH and custom port"
  vpc_id      = "vpc-064844fbdba0dda9d"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "my_sg2"
  }
}
resource "aws_instance" "my_instance2" {
  ami           = "ami-07a0715df72e58928" # This is an example AMI ID, replace with a current t3.micro compatible AMI in ap-south-1
  instance_type = "c5.xlarge" # 4cpus and 8gb ram
  subnet_id     = "subnet-007f35405ee92b28f"
  root_block_device {
  volume_size = 20
  }
  security_groups = [aws_security_group.my_sg2.id]
    user_data = <<-EOF
              #!/bin/bash
              echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTNiVMBv4m86Xsc6KjcB83eFGJa0wBAgL9yq8y96RNq9I+F4aEu/yWbbeJZ0lZ6KFZ1AiH5bMzdmdnna2yZHObXZqjkbx20NmGnJceG1K5i0TDiB8GkqsqP+q2DQua84t90/mgrmcNUsNHwdZcYLDeFI/z4MsLv4TJssWHtv1a4y3HjFXzEKGcoUaDU8TvRztjgEOTxWdWtqHQkF/jQcakW1QIc2GNNS44FE34lmrO55wJXM0iVNEdyDhKKRVDXUzqyjGwQfh/jfsEuuWOYwfFwWyJGRKSx3OlqJBNqoDDWYb2p2G1WNR6DCgsQ5EWXf62m4mpMCD3xkNrWKLBZl6nFYC2VsoD9fz1MyKabe48ZK/6nzQFvpHWsBv/LR5g7ga3qKsZSG+uxi1VGNwrW0f2T9T4wtOpMCE112A3evfyRpWuFjlSW6AfAagF11zBhEziUMceOeHA2rU39kO38/Ku1Yv++5liA4QePdJeeEuvMuBFb9UR4KJJjEVkMmCFzT0= ubuntu@ip-10-0-0-146" >> /home/ubuntu/.ssh/authorized_keys
              EOF
  tags = {
    Name = "Jenkins"
  }
}