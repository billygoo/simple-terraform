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
  region                   = local.region
  profile                  = "account1"
  shared_credentials_files = ["~/.aws/credentials"]
}

provider "aws" {
  region                   = local.region
  profile                  = "account2"
  shared_credentials_files = ["~/.aws/credentials"]
  alias                    = "account2"
}


resource "aws_vpc" "management" {
  # 10.0.0.0 ~ 10.0.3.255 (1024 ea)
  cidr_block = "10.0.0.0/22"

  tags = {
    Name = "management-vpc"
  }
}

resource "aws_internet_gateway" "management" {
  vpc_id = aws_vpc.management.id
  tags = {
    Name = "management-igw"
  }
}

resource "aws_subnet" "management" {
  vpc_id = aws_vpc.management.id
  # 10.0.0.0 ~ 10.0.0.255
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.az

  tags = {
    Name = "management-private-subnet-${local.az}"
  }
}

resource "aws_security_group" "allow_only_tester" {
  name_prefix = "mgmt-sg-"
  vpc_id      = aws_vpc.management.id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.management.cidr_block,
      data.terraform_remote_state.account2_vpc.outputs.subnet_cidr,

    "1.238.185.24/32"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-allow_only_tester"
  }
}

resource "aws_vpc_peering_connection" "account1_to_account2" {
  peer_owner_id = data.terraform_remote_state.account2_vpc.outputs.account_id
  peer_vpc_id = data.terraform_remote_state.account2_vpc.outputs.vpc_id

  vpc_id      = aws_vpc.management.id

  tags = {
    Name = "peering_account1_to_account2_${local.az}"
  }
}

resource "aws_vpc_peering_connection_accepter" "account_b_accepter" {
  provider                  = aws.account2
  vpc_peering_connection_id = aws_vpc_peering_connection.account1_to_account2.id
  auto_accept = true
}

resource "aws_route_table" "management" {
  vpc_id = aws_vpc.management.id

  tags = {
    Name = "management-rt"
  }
}

resource "aws_route" "account1_to_account2" {
  route_table_id            = aws_route_table.management.id
  destination_cidr_block    = data.terraform_remote_state.account2_vpc.outputs.subnet_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.account1_to_account2.id
}

resource "aws_route" "internet-gateway" {
  route_table_id            = aws_route_table.management.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.management.id
}

resource "aws_route_table_association" "route-table-association" {
  subnet_id      = aws_subnet.management.id
  route_table_id = aws_route_table.management.id
}
