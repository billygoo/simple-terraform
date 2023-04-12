################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "service" {
  vpc_id = aws_vpc.service.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

################################################################################
# Nat Gateway
################################################################################
resource "aws_eip" "ngw" {
  count = length(var.public_subnets)

  vpc = true

  tags = {
    Name = "${var.vpc_name}-EIP-NGW-${var.availability_zones[count.index]}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.public_subnets)

  allocation_id = aws_eip.ngw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.vpc_name}-NGW-${var.availability_zones[count.index]}"
  }
}

# resource "aws_nat_gateway" "private_ngw" {
#   count = length(var.private_subnets)

#   allocation_id = aws_eip.ngw[count.index].id
#   subnet_id         = aws_subnet.private[count.index].id

#   tags = {
#     Name = "${var.vpc_name}-Private-NGW-${var.availability_zones[count.index]}"
#   }
# }

resource "aws_ec2_transit_gateway_vpc_attachment" "private_accesscontrol" {
  vpc_id                                          = aws_vpc.service.id
  subnet_ids                                      = aws_subnet.private.*.id
  transit_gateway_id                              = var.accesscontrol_tgw_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "Accesscontrol-TGW-${var.vpc_name}-Attachment"
  }

  lifecycle {
    ignore_changes = [
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation
    ]
  }
}

