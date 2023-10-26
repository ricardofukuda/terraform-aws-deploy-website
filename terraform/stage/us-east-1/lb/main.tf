module "alb" {
  source = "../../../modules/alb"

  domain      = var.domain
  environment = var.environment
}
