################################################################################
# Route Table
################################################################################\
resource "aws_route_table" "public" {
  count = length(aws_subnet.public.*.id)

  vpc_id = aws_vpc.service.id

  tags = {
    Name = "${var.vpc_name}-Public-RT-${var.availability_zones[count.index]}"
  }
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private.*.id)

  vpc_id = aws_vpc.service.id

  tags = {
    Name = "${var.vpc_name}-Private-RT-${var.availability_zones[count.index]}"
  }
}


################################################################################
# Association Subnet
################################################################################
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public.*.id)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private.*.id)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

################################################################################
# Route
################################################################################

##### Public #####
resource "aws_route" "public_all_outbound" {
  count = length(aws_subnet.public.*.id)

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.service.id

  depends_on = [
    aws_internet_gateway.service
  ]
}

##### Private #####
resource "aws_route" "private_all_outbound" {
  count = length(aws_subnet.private.*.id)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[count.index].id

  depends_on = [
    aws_nat_gateway.ngw
  ]
}

##### Transit Gateway #####
resource "aws_route" "private_transit_gateway" {
  count = length(aws_subnet.private.*.id)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = var.accesscontrol_tgw_id
}

