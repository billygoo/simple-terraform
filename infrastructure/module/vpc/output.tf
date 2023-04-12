output "vpc_id" {
  value = aws_vpc.service.id
}

output "vpc_cidr" {
  value = aws_vpc.service.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "public_subnet_cidrs" {
  value = aws_subnet.public.*.cidr_block
}

output "private_subnet_cidrs" {
  value = aws_subnet.private.*.cidr_block
}

output "igw_id" {
  value = aws_internet_gateway.service.id
}

output "ngw_ids" {
  value = aws_nat_gateway.ngw.*.id
}

output "public_route_table_ids" {
  value = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  value = aws_route_table.private.*.id
}

output "tgw_accesscontrol_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.private_accesscontrol.id
}
