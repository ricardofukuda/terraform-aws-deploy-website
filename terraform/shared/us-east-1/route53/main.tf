resource "aws_route53_zone" "public" {
  name = var.domain

  tags = local.tags
}

resource "aws_route53_zone" "private" {
  name = var.domain

  vpc {
    vpc_id = data.aws_vpc.stage.id
  }
  vpc {
    vpc_id = data.aws_vpc.dev.id
  }

  tags = local.tags
}
