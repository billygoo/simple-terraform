locals {
  account_id = data.aws_caller_identity.current.account_id
  external_vpc_subnet_cidrs = data.terraform_remote_state.external_vpc.outputs.private_subnet_cidrs
}


variable "vpc_name" {
  type = string
  description = "VPC Name"
}

variable "vpc_cidr" {
  type = string
  description = "CIDR for VPC"
}

variable "vpc_subnet_cidrs" {
  type = map
  description = <<EOF
    Map of subnet AZ,CIDR for VPC.  This value must be specified in the form *AZ=CIDR*.

    for example:
    ```
    vpc_subnet_cidr={"ap-northeast-2a"="10.0.0.0/24", "ap-northeast-2b"="10.0.1.0/24"}
    ```
    EOF
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}


