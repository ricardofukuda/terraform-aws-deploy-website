data "aws_ec2_transit_gateway" "main" {
  filter {
    name   = "tag:Environment"
    values = ["shared"]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" { # attach the VPC to the transit gateway
  subnet_ids         = aws_subnet.private[*].id
  transit_gateway_id = data.aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.vpc.id

  tags = local.tags
}

resource "aws_route" "tgw" {
  for_each = toset(aws_route_table.private[*].id)

  route_table_id         = each.key
  destination_cidr_block = data.aws_ec2_transit_gateway.main.transit_gateway_cidr_blocks[0]
  transit_gateway_id     = data.aws_ec2_transit_gateway.main.id
}