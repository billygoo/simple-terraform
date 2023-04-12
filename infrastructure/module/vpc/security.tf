resource "aws_security_group" "vpc-sg" {
  name_prefix = "${var.vpc_name}-sg"
  vpc_id      = aws_vpc.service.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = setunion(["1.238.185.24/32", var.vpc_cidr], var.additional_cidr)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound connections to internet"
  }

  tags = {
    Name = "${var.vpc_name}-default-sg"
  }
}