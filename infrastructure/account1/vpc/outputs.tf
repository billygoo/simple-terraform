output "account_id" {
  value = local.account_id
}

output "vpc_id" {
  value = aws_vpc.management.id
}

output "subnet" {
  value = aws_subnet.management
}

output "subnet_cidr" {
  value = aws_subnet.management.cidr_block
}

output "security_group_id" {
  value = aws_security_group.allow_only_tester.id
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.account1_to_account2.id
}