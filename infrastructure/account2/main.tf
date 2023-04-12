provider "aws" {
  region                   = "ap-northeast-2"
  profile                  = "account2"
  shared_credentials_files = ["~/.aws/credentials"]
}

locals {
  vpc_name          = "staging"
  vpc_cidr          = "10.1.0.0/16"
  external_vpc_cidr = "10.0.0.0/16"
  azs               = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets    = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets   = ["10.1.3.0/24", "10.1.4.0/24"]

  account_id = data.aws_caller_identity.current.account_id
  
  accesscontrol_tgw_id          = data.terraform_remote_state.account1.outputs.tgw_accesscontrol_id
  cicd_vpc_tgw_attachment_id    = data.terraform_remote_state.account1.outputs.tgw_attachment_id
}

module "vpc" {
  source             = "../module/vpc"
  vpc_name           = local.vpc_name
  vpc_cidr           = local.vpc_cidr
  availability_zones = local.azs
  public_subnets     = local.public_subnets
  private_subnets    = local.private_subnets

  accesscontrol_tgw_id = local.accesscontrol_tgw_id
}

resource "aws_security_group" "cicd-sg" {
  name_prefix = "${local.vpc_name}-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["1.238.185.24/32", module.vpc.vpc_cidr, local.external_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound connections to internet"
  }

  # egress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "Allow HTTP connections to internet"
  # }

  # egress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "Allow HTTPS connections to internet"
  # }
  tags = {
    Name = "${local.vpc_name}-default-sg"
  }
}