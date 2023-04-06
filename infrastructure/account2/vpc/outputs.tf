output "account_id" {
  value = local.account_id
}

output "vpc_id" {
  value = aws_vpc.staging.id
}

output "subnet" {
  value = aws_subnet.staging
}

output "subnet_cidr" {
  value = aws_subnet.staging.cidr_block
}

output "security_group_id" {
  value = aws_security_group.allow_only_tester.id
}