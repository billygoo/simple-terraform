output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "public_subnet_cidrs" {
  value = module.vpc.public_subnet_cidrs
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "private_subnet_cidrs" {
  value = module.vpc.private_subnet_cidrs

}

output "igw_id" {
  value = module.vpc.igw_id
}

output "ngw_ids" {
  value = module.vpc.ngw_ids
}

output "account_id" {
  value = local.account_id
}

output "tgw_attachment_id" {
  value = module.vpc.tgw_accesscontrol_attachment_id
}
