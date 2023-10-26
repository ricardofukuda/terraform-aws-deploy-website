resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.tags
}

resource "aws_default_network_acl" "nacl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  subnet_ids = concat(aws_subnet.private[*].id, aws_subnet.public[*].id)

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = local.tags
}