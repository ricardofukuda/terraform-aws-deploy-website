resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.vpc.id

  availability_zone       = var.private_subnets[count.index].availability_zone
  cidr_block              = var.private_subnets[count.index].cidr_block
  map_public_ip_on_launch = false

  tags = merge(
    local.tags,
    {
      "Name" = "${var.name}-${var.private_subnets[count.index].availability_zone}-private",
      "Tier" = "private"
    }
  )
}

resource "aws_route_table" "private" {
  count = var.high_availability ? length(var.private_subnets) : 1

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    { "Name" = var.high_availability ? "${var.name}-${var.private_subnets[count.index].availability_zone}-private" : "${var.name}-private" }
  )
}

resource "aws_route" "private_nat_gateway" {
  count = var.high_availability ? length(var.private_subnets) : 1

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, var.high_availability ? count.index : 0)
}

resource "aws_eip" "nat" {
  count = var.high_availability ? length(var.private_subnets) : 1

  domain = "vpc"

  tags = merge(
    local.tags,
    { "Name" = var.high_availability ? "natgw-${var.name}-${var.private_subnets[count.index].availability_zone}" : "natgw-${var.name}" }
  )

  depends_on = [aws_internet_gateway.igw]
}