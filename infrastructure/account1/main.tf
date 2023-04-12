provider "aws" {
  region                   = "ap-northeast-2"
  profile                  = "account1"
  shared_credentials_files = ["~/.aws/credentials"]
}

locals {
  vpc_name          = "cicd"
  vpc_cidr          = "10.0.0.0/16"
  external_vpc_cidr = ["10.1.0.0/16"] # other vpc cidr
  azs               = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]

  account_id   = data.aws_caller_identity.current.account_id
  cluster_name = "cicd-eks"
}

module "vpc" {
  source             = "../module/vpc"
  vpc_name           = local.vpc_name
  vpc_cidr           = local.vpc_cidr
  availability_zones = local.azs
  public_subnets     = local.public_subnets
  private_subnets    = local.private_subnets
  additional_cidr    = local.external_vpc_cidr

  accesscontrol_tgw_id = aws_ec2_transit_gateway.accesscontrol.id

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}
