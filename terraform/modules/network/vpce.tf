data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  policy       = data.aws_iam_policy_document.policy_vpce.json

  tags = local.tags
}

data "aws_iam_policy_document" "policy_vpce" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    effect = "Allow"

    resources = ["*"]
  }

  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["*"]

    effect = "Deny"

    resources = ["*"]

    condition {
      test     = "StringNotEquals" # Only requests from the VPC are allowed through the S3 Endpoint
      variable = "aws:sourceVpc"

      values = [aws_vpc.vpc.id]
    }
  }
}

resource "aws_vpc_endpoint_route_table_association" "route_table_association" {
  count = length(aws_route_table.private[*].id)

  route_table_id  = element(aws_route_table.private[*].id, count.index)
  vpc_endpoint_id = aws_vpc_endpoint.s3.id

  depends_on = [aws_route_table.private]
}