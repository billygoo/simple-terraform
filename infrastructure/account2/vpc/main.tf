terraform {
  required_version = "1.4.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
  }

  backend "s3" {
    encrypt                 = true
    bucket                  = "kcd-temp-tf-backend"
    key                     = "account2/vpc/terraform.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "account1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "ap-northeast-2"
  profile                 = "account2"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_vpc" "staging" {
  # 172.16.0.0 ~ 172.16.3.255 (1024 ea)
  cidr_block = "172.16.0.0/22"

  tags = {
    Name = "staging-vpc"
  }
}

resource "aws_subnet" "staging" {
  vpc_id     = aws_vpc.staging.id
  # 172.16.0.0 ~ 172.16.0.255
  cidr_block = "172.16.0.0/24"
  availability_zone = "ap-northeast-2a"
  
  tags = {
    Name = "staging-private-subnet-ap-northeast-2a"
  }
}

resource "aws_security_group" "allow_only_tester" {
  name_prefix = "staging-sg"
  vpc_id      = aws_vpc.staging.id
  
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [aws_vpc.staging.cidr_block, "1.238.185.24/32"]
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
