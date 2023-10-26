data "aws_region" "current" {}

locals {
  aws_region = data.aws_region.current.name
}

module "vpc" {
  source = "../../../modules/network"

  name                    = "vpc-${var.environment}"
  cidr_block              = "10.0.0.0/16"
  map_public_ip_on_launch = false
  high_availability       = false #Enable high availabilty mode which is going to create an exclusive natgateway for each AZ. Very expensive!"

  public_subnets = [{
    availability_zone = "${local.aws_region}a"
    cidr_block        = "10.0.0.0/22"
    }, {
    availability_zone = "${local.aws_region}b"
    cidr_block        = "10.0.4.0/22"
    }, {
    availability_zone = "${local.aws_region}c"
    cidr_block        = "10.0.8.0/22"
  }]

  private_subnets = [{
    availability_zone = "${local.aws_region}a"
    cidr_block        = "10.0.16.0/22"
    },
    {
      availability_zone = "${local.aws_region}b"
      cidr_block        = "10.0.20.0/22"
      }, {
      availability_zone = "${local.aws_region}c"
      cidr_block        = "10.0.24.0/22"
  }]

  tags = {
    "Environment" = var.environment
  }
}