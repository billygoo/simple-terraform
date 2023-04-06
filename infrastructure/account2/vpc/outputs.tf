output "account_id" {
  value = local.account_id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = values(aws_subnet.private_subnet)[*].id
}

output "private_subnet_cidrs" {
  value = values(aws_subnet.private_subnet)[*].cidr_block
}

output "security_group_id" {
  value = aws_security_group.main_sg.id
}