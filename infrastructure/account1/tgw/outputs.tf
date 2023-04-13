output "aws_ec2_transit_gateway_route_table" {
  value = aws_ec2_transit_gateway_route_table.accesscontrol-tgw-rt.id
  description = "The Route Table ID of the Transit gateway"
}
