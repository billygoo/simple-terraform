################################################################################
# VPC - Service
################################################################################
resource "aws_vpc" "service" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}-VPC"
  }
}

################################################################################
# Subnet - Public
################################################################################
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.service.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.vpc_name}-Public-Subnet-${var.availability_zones[count.index]}"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

################################################################################
# Subnet - Private (Nat Gateway, Transit Gateway)
################################################################################
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.service.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.vpc_name}-Pirvate-${var.availability_zones[count.index]}"
  }
}
