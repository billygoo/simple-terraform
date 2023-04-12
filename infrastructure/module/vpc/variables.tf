variable "vpc_name" {
  description = "Vpc name. This value is referenced in the tag name of the associated resource."
}

variable "vpc_cidr" {
  description = "Manage IPv4 CIDR blocks for a VPC."
}

variable "availability_zones" {
  description = "Avialiability zones for VPC subnets. You must enter the same number of subnets."
}

variable "public_subnets" {
  description = "Public subnets. You must enter the same number of availability_zones."
}

variable "private_subnets" {
  description = "Private subnets. You must enter the same number of availability_zones."
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "accesscontrol_tgw_id" {
  description = "The ID of Transit gateway for cross access."
}
