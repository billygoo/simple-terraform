resource "aws_ec2_transit_gateway" "accesscontrol" {
  description                     = "Access Control TGW"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "Accesscontrol-TGW"
  }
}

# TGW Resource Share
resource "aws_ram_resource_share" "accesscontrol" {
  name                      = "Accesscontrol-TGW-Share"
  allow_external_principals = true

  tags = {
    Name = "Accesscontrol-TGW-Share"
  }
}

resource "aws_ram_resource_association" "accesscontrol" {
  resource_arn       = aws_ec2_transit_gateway.accesscontrol.arn
  resource_share_arn = aws_ram_resource_share.accesscontrol.id
}

resource "aws_ram_principal_association" "accesscontrol" {
  principal          = "751218278275" // account2 id
  resource_share_arn = aws_ram_resource_share.accesscontrol.id
}
