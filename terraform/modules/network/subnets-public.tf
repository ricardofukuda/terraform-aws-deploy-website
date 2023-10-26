resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id = aws_vpc.vpc.id

  availability_zone       = var.public_subnets[count.index].availability_zone
  cidr_block              = var.public_subnets[count.index].cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    local.tags,
    {
      "Name" = "${var.name}-${var.public_subnets[count.index].availability_zone}-public",
      "Tier" = "public"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    { "Name" = "${var.name}-public" }
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}