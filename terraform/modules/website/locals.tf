locals {
  name           = lower("website-${var.environment}")
  service_adress = lower("${local.name}.${var.domain}")
  bucket_name    = lower("mclp-${local.name}")
  lb_name        = lower("alb-internal-${var.environment}")

  tags = merge(var.tags, { "Name" = local.name })
}
