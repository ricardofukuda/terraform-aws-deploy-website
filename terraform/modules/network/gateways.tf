resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.tags
}

resource "aws_nat_gateway" "natgw" { # when using HA, it is going to allocate an exclusive natgateway for each subnet/AZ.
  count = var.high_availability ? length(var.private_subnets) : 1

  allocation_id = element(aws_eip.nat[*].id, count.index)
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  tags = merge(
    local.tags,
    { "Name" = var.high_availability ? "${var.name}-${var.private_subnets[count.index].availability_zone}" : var.name }
  )

  depends_on = [aws_internet_gateway.igw]
}
