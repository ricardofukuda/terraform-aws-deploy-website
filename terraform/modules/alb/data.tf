data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${var.environment}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Tier = "private"
  }
}

data "aws_acm_certificate" "certificate" {
  domain      = var.domain
  statuses    = ["ISSUED"]
  most_recent = true
}
