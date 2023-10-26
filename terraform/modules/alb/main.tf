module "alb_internal" {
  source = "../base/alb"

  name     = local.alb_internal_name
  internal = true

  vpc_id     = data.aws_vpc.selected.id
  subnets_id = data.aws_subnets.private.ids

  certificate_arn = data.aws_acm_certificate.certificate.arn

  ingress_rules = [{
    description      = "web port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block] # ALB only accessible from the VPC.
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    },
    {
      description      = "web port 443"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.selected.cidr_block] # ALB only accessible from the VPC.
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
  }]

  egress_rules = [
    {
      description      = "Out"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [data.aws_vpc.selected.cidr_block] # ALB only accessible from the VPC.
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = local.tags
}