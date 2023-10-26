resource "aws_ec2_transit_gateway" "tgw" { # TGW connects several VPC environments
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"

  transit_gateway_cidr_blocks = ["10.0.0.0/8"]
}
