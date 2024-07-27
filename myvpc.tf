# Provider Plugin Block
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
#Resources Block
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/20"  
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}
resource "aws_subnet" "subnet_one" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/21"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_one"
  }
}
resource "aws_subnet" "subnet_two" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.8.0/21"
  availability_zone = "eu-north-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_two"
  }
}
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_gateway"
  }
}
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }
  tags = {
    Name = "my_route_table"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_one.id
  route_table_id = aws_route_table.my_route_table.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_two.id
  route_table_id = aws_route_table.my_route_table.id
}