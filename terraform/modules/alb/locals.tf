locals {
  alb_internal_name = "alb-internal-${var.environment}"
  tags              = { "Name" : local.alb_internal_name }
}