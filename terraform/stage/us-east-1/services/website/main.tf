module "website" {
  source = "../../../../modules/website"

  domain      = var.domain
  environment = var.environment
}