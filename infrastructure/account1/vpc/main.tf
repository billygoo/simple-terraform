provider "aws" {
  region                   = "ap-northeast-2"
  profile                  = "account1"
  shared_credentials_files = ["~/.aws/credentials"]
}

provider "aws" {
  region                   = "ap-northeast-2"
  profile                  = "account2"
  shared_credentials_files = ["~/.aws/credentials"]
  alias                    = "account2"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = var.vpc_subnet_cidrs
  vpc_id = aws_vpc.main.id

  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = "${var.vpc_name}-private-subnet-${each.key}"
  }
}

resource "aws_security_group" "main_sg" {
  name_prefix = "${var.vpc_name}-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = setunion(["1.238.185.24/32", var.vpc_cidr], values(var.vpc_subnet_cidrs))
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_only_tester-sg"
  }
}

resource "aws_route_table" "main_private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-rt"
  }
}

resource "aws_route" "internet-gateway" {
  route_table_id         = aws_route_table.main_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_vpc_igw.id
}


resource "aws_route_table_association" "route-table-association" {
  for_each = var.vpc_subnet_cidrs
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.main_private_rt.id
}


############################################################################################
# Peering Section
############################################################################################
resource "aws_vpc_peering_connection" "account1_to_account2" {
  peer_owner_id = data.terraform_remote_state.external_vpc.outputs.account_id
  peer_vpc_id   = data.terraform_remote_state.external_vpc.outputs.vpc_id

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "peering_account1_to_account2"
  }
}

resource "aws_vpc_peering_connection_accepter" "account_b_accepter" {
  provider                  = aws.account2
  vpc_peering_connection_id = aws_vpc_peering_connection.account1_to_account2.id
  auto_accept               = true
}

resource "aws_route" "private_route" {
  count           = length(local.external_vpc_subnet_cidrs)
  route_table_id            = aws_route_table.main_private_rt.id
  destination_cidr_block    = element(local.external_vpc_subnet_cidrs, count.index)
  vpc_peering_connection_id = aws_vpc_peering_connection.account1_to_account2.id
}

