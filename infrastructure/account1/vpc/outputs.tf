output "vpc_id" {
  value = aws_vpc.management.id
}

output "subnet" {
  value = aws_subnet.management
}

output "security_group_id" {
  value = aws_security_group.allow_only_tester.id
}