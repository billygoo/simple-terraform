terraform {
  required_version = ">= 1.4.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60.0"
    }
  }

  backend "s3" {
    encrypt                 = true
    bucket                  = "kcd-temp-tf-backend"
    key                     = "account1/vpc/terraform.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "account1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "ap-northeast-2"
  profile                 = "account1"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_vpc" "management" {
  # 10.0.0.0 ~ 10.0.3.255 (1024 ea)
  cidr_block = "10.0.0.0/22"

  tags = {
    Name = "management-vpc"
  }
}

resource "aws_subnet" "management" {
  vpc_id     = aws_vpc.management.id
  # 10.0.0.0 ~ 10.0.0.255
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  
  tags = {
    Name = "management-private-subnet-ap-northeast-2a"
  }
}

resource "aws_security_group" "allow_only_tester" {
  name_prefix = "management-sg"
  vpc_id      = aws_vpc.management.id
  
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [aws_vpc.management.cidr_block, "1.238.185.24/32"]
  }
  
  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_only_tester"
  }
}
