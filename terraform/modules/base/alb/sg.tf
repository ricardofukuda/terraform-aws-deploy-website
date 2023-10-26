resource "aws_security_group" "alb_sg" {
  name   = var.name
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress = var.ingress_rules

  egress = var.egress_rules

  tags = local.tags
}