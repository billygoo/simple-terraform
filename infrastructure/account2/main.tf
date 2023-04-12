provider "aws" {
  region                   = "ap-northeast-2"
  profile                  = "account2"
  shared_credentials_files = ["~/.aws/credentials"]
}

locals {
  vpc_name          = "staging"
  vpc_cidr          = "10.1.0.0/16"
  external_vpc_cidr = ["10.0.0.0/16"]
  azs               = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets    = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets   = ["10.1.3.0/24", "10.1.4.0/24"]

  account_id   = data.aws_caller_identity.current.account_id
  cluster_name = "staging-eks"

  accesscontrol_tgw_id       = data.terraform_remote_state.account1.outputs.tgw_accesscontrol_id
  cicd_vpc_tgw_attachment_id = data.terraform_remote_state.account1.outputs.tgw_attachment_id
}

module "vpc" {
  source             = "../module/vpc"
  vpc_name           = local.vpc_name
  vpc_cidr           = local.vpc_cidr
  availability_zones = local.azs
  public_subnets     = local.public_subnets
  private_subnets    = local.private_subnets
  additional_cidr    = local.external_vpc_cidr

  accesscontrol_tgw_id = local.accesscontrol_tgw_id

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}
