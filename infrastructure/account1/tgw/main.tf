provider "aws" {
  region                   = "ap-northeast-2"
  profile                  = "account1"
  shared_credentials_files = ["~/.aws/credentials"]
}

locals {
  accesscontrol_tgw_id          = data.terraform_remote_state.account1.outputs.tgw_accesscontrol_id
  cicd_vpc_tgw_attachment_id    = data.terraform_remote_state.account1.outputs.tgw_attachment_id
  staging_vpc_tgw_attachment_id = data.terraform_remote_state.account2.outputs.tgw_attachment_id
}


################################################################################
# Route Table for Transit Gatway 
################################################################################
resource "aws_ec2_transit_gateway_route_table" "accesscontrol-tgw-rt" {
  transit_gateway_id = local.accesscontrol_tgw_id
  tags = {
    Name = "Accesscontrol-TGW-RT"
  }
}


################################################################################
# Association for Transit Gatway 
################################################################################
resource "aws_ec2_transit_gateway_route_table_association" "cicd-tgw-rt-assoc" {
  transit_gateway_attachment_id  = local.cicd_vpc_tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.accesscontrol-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "staging-tgw-rt-assoc" {
  transit_gateway_attachment_id  = local.staging_vpc_tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.accesscontrol-tgw-rt.id
}


################################################################################
# Propagation for Transit Gatway 
################################################################################
resource "aws_ec2_transit_gateway_route_table_propagation" "cicd-tgw-rt-prop" {
  transit_gateway_attachment_id  = local.cicd_vpc_tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.accesscontrol-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "staging-tgw-rt-prop" {
  transit_gateway_attachment_id  = local.staging_vpc_tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.accesscontrol-tgw-rt.id
}
